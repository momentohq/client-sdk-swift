import Foundation
import GRPC
import NIO
import NIOHPACK
import Logging

protocol DataClientProtocol {
    func get(cacheName: String, key: ScalarType) async -> GetResponse

    func set(
        cacheName: String,
        key: ScalarType,
        value: ScalarType,
        ttl: TimeInterval?
    ) async -> SetResponse

    func delete(cacheName: String, key: ScalarType) async -> DeleteResponse

    func listConcatenateBack(
        cacheName: String,
        listName: String,
        values: [ScalarType],
        truncateFrontToSize: Int?,
        ttl: CollectionTtl?
    ) async -> CacheListConcatenateBackResponse

    func listConcatenateFront(
        cacheName: String,
        listName: String,
        values: [ScalarType],
        truncateBackToSize: Int?,
        ttl: CollectionTtl?
    ) async -> CacheListConcatenateFrontResponse

    func listFetch(
        cacheName: String,
        listName: String,
        startIndex: Int?,
        endIndex: Int?
    ) async -> CacheListFetchResponse

    func listLength(
        cacheName: String,
        listName: String
    ) async -> CacheListLengthResponse
    
    func listPopBack(
        cacheName: String,
        listName: String
    ) async -> CacheListPopBackResponse
    
    func listPopFront(
        cacheName: String,
        listName: String
    ) async -> CacheListPopFrontResponse
    
    func listPushBack(
        cacheName: String,
        listName: String,
        value: ScalarType,
        truncateFrontToSize: Int?,
        ttl: CollectionTtl?
    ) async -> CacheListPushBackResponse
    
    func listPushFront(
        cacheName: String,
        listName: String,
        value: ScalarType,
        truncateBackToSize: Int?,
        ttl: CollectionTtl?
    ) async -> CacheListPushFrontResponse
    
    func listRemoveValue(
        cacheName: String,
        listName: String,
        value: ScalarType
    ) async -> CacheListRemoveValueResponse
    
    func listRetain(
        cacheName: String,
        listName: String,
        startIndex: Int?,
        endIndex: Int?,
        ttl: CollectionTtl?
    ) async -> CacheListRetainResponse
}

@available(macOS 10.15, iOS 13, *)
class DataClient: DataClientProtocol {
    internal let logger: Logger
    private let credentialProvider: CredentialProviderProtocol
    private let configuration: CacheClientConfigurationProtocol
    private let grpcChannel: GRPCChannel
    private let eventLoopGroup = PlatformSupport.makeEventLoopGroup(loopCount: 1)
    private let client: CacheClient_ScsNIOClient
    private let headers: Dictionary<String, String>
    private let defaultTtlSeconds: TimeInterval
    
    init(
        configuration: CacheClientConfigurationProtocol,
        credentialProvider: CredentialProviderProtocol,
        defaultTtlSeconds: TimeInterval
    ) {
        self.configuration = configuration
        self.credentialProvider = credentialProvider
        self.logger = Logger(label: "CacheDataClient")
        self.defaultTtlSeconds = defaultTtlSeconds
        
        do {
            self.grpcChannel = try GRPCChannelPool.with(
                target: .host(credentialProvider.cacheEndpoint, port: 443),
                transportSecurity: .tls(
                    GRPCTLSConfiguration.makeClientDefault(compatibleWith: eventLoopGroup)
                ),
                eventLoopGroup: self.eventLoopGroup
                ) { configuration in
                    // Additional configuration, like keepalive.
                    // Note: Keepalive should in most circumstances not be necessary.
                    configuration.keepalive = ClientConnectionKeepalive(
                        interval: .seconds(15),
                        timeout: .seconds(10)
                    )
                }
        } catch {
            fatalError("Failed to open GRPC channel")
        }
        
        self.headers = ["agent": "swift:0.1.0"]
        
        self.client = CacheClient_ScsNIOClient(
            channel: self.grpcChannel,
            defaultCallOptions: .init(
                customMetadata: .init(self.headers.map { ($0, $1) }),
                timeLimit: .timeout(.seconds(Int64(self.configuration.transportStrategy.getClientTimeout())))
            ),
            interceptors: DataClientInterceptorFactory(apiKey: credentialProvider.apiKey)
        )
    }
    
    private func makeHeaders(cacheName: String) -> Dictionary<String, String> {
        return self.headers.merging(["cache": cacheName]) { (_, new) in new }
    }
    
    private func convertScalarTypeToData(element: ScalarType) -> Data {
        switch element {
        case .string(let s):
            return Data(s.utf8)
        case .data(let d):
            return d
        }
    }
    
    func get(cacheName: String, key: ScalarType) async -> GetResponse {
        var request = CacheClient__GetRequest()
        request.cacheKey = self.convertScalarTypeToData(element: key)

        let headers = self.makeHeaders(cacheName: cacheName)
        let call = self.client.get(
            request,
            callOptions: CallOptions(
                customMetadata: .init(
                    headers.map { ($0, $1) }
                )
            )
        )
        
        do {
            let result = try await call.response.get()
            if result.result == .hit {
                return GetResponse.hit(GetHit(value: result.cacheBody))
            } else if result.result == .miss {
                return GetResponse.miss(GetMiss())
            } else {
                return GetResponse.error(GetError(
                    error: UnknownError(message: "unknown cache get error \(result)")
                ))
            }
        } catch let err as GRPCStatus {
            return GetResponse.error(GetError(error: grpcStatusToSdkError(grpcStatus: err)))
        } catch let err as GRPCConnectionPoolError {
            return GetResponse.error(GetError(
                error: grpcStatusToSdkError(grpcStatus: err.makeGRPCStatus())
            ))
        } catch {
            return GetResponse.error(GetError(
                error: UnknownError(message: "unknown cache get error \(error)")
            ))
        }
    }
    
    func set(
        cacheName: String,
        key: ScalarType,
        value: ScalarType,
        ttl: TimeInterval? = nil
    ) async -> SetResponse {
        var request = CacheClient__SetRequest()
        let ttlSeconds = ttl ?? self.defaultTtlSeconds
        request.ttlMilliseconds = UInt64(ttlSeconds*1000)
        request.cacheKey = self.convertScalarTypeToData(element: key)
        request.cacheBody = self.convertScalarTypeToData(element: value)

        let headers = self.makeHeaders(cacheName: cacheName)
        let call = self.client.set(
            request,
            callOptions: CallOptions(
                customMetadata: .init(
                    headers.map { ($0, $1) }
                )
            )
        )

        do {
            _ = try await call.response.get()
            return SetResponse.success(SetSuccess())
        } catch let err as GRPCStatus {
            return SetResponse.error(SetError(error: grpcStatusToSdkError(grpcStatus: err)))
        } catch let err as GRPCConnectionPoolError {
            return SetResponse.error(SetError(
                error: grpcStatusToSdkError(grpcStatus: err.makeGRPCStatus())
            ))
        } catch {
            return SetResponse.error(SetError(
                error: UnknownError(message: "unknown cache set error \(error)")
            ))
        }
    }
    
    func delete(cacheName: String, key: ScalarType) async -> DeleteResponse {
        var request = CacheClient__DeleteRequest()
        request.cacheKey = self.convertScalarTypeToData(element: key)
        let headers = self.makeHeaders(cacheName: cacheName)
        let call = self.client.delete(
            request,
            callOptions: CallOptions(
                customMetadata: .init(
                    headers.map { ($0, $1) }
                )
            )
        )

        do {
            _ = try await call.response.get()
            return DeleteResponse.success(DeleteSuccess())
        } catch let err as GRPCStatus {
            return DeleteResponse.error(DeleteError(error: grpcStatusToSdkError(grpcStatus: err)))
        } catch let err as GRPCConnectionPoolError {
            return DeleteResponse.error(DeleteError(
                error: grpcStatusToSdkError(grpcStatus: err.makeGRPCStatus())
            ))
        } catch {
            return DeleteResponse.error(DeleteError(
                error: UnknownError(message: "unknown cache set error \(error)")
            ))
        }
    }

    func listConcatenateBack(
        cacheName: String,
        listName: String,
        values: [ScalarType],
        truncateFrontToSize: Int? = nil,
        ttl: CollectionTtl? = nil
    ) async -> CacheListConcatenateBackResponse {
        var request = CacheClient__ListConcatenateBackRequest()
        request.listName = Data(listName.utf8)
        request.values = values.map(self.convertScalarTypeToData)
        request.truncateFrontToSize = UInt32(truncateFrontToSize ?? 0)
        
        let _ttl = ttl ?? CollectionTtl.fromCacheTtl()
        request.ttlMilliseconds = UInt64(_ttl.ttlMilliseconds() ?? self.defaultTtlSeconds * 1000)
        request.refreshTtl = _ttl.refreshTtl()
        
        let headers = self.makeHeaders(cacheName: cacheName)
        let call = self.client.listConcatenateBack(
            request,
            callOptions: CallOptions(
                customMetadata: .init(
                    headers.map { ($0, $1) }
                )
            )
        )
        
        do {
            let result = try await call.response.get()
            return CacheListConcatenateBackSuccess(length: result.listLength)
        } catch let err as GRPCStatus {
            return CacheListConcatenateBackError(error: grpcStatusToSdkError(grpcStatus: err))
        } catch let err as GRPCConnectionPoolError {
            return CacheListConcatenateBackError(
                error: grpcStatusToSdkError(grpcStatus: err.makeGRPCStatus())
            )
        } catch {
            return CacheListConcatenateBackError(
                error: UnknownError(message: "unknown list concatenate back error \(error)")
            )
        }
    }
    
    func listConcatenateFront(
        cacheName: String,
        listName: String,
        values: [ScalarType],
        truncateBackToSize: Int? = nil,
        ttl: CollectionTtl? = nil
    ) async -> CacheListConcatenateFrontResponse {
        var request = CacheClient__ListConcatenateFrontRequest()
        request.listName = Data(listName.utf8)
        request.values = values.map(self.convertScalarTypeToData)
        request.truncateBackToSize = UInt32(truncateBackToSize ?? 0)
        
        let _ttl = ttl ?? CollectionTtl.fromCacheTtl()
        request.ttlMilliseconds = UInt64(_ttl.ttlMilliseconds() ?? self.defaultTtlSeconds * 1000)
        request.refreshTtl = _ttl.refreshTtl()
        
        let headers = self.makeHeaders(cacheName: cacheName)
        let call = self.client.listConcatenateFront(
            request,
            callOptions: CallOptions(
                customMetadata: .init(
                    headers.map { ($0, $1) }
                )
            )
        )
        
        do {
            let result = try await call.response.get()
            return CacheListConcatenateFrontSuccess(length: result.listLength)
        } catch let err as GRPCStatus {
            return CacheListConcatenateFrontError(error: grpcStatusToSdkError(grpcStatus: err))
        } catch let err as GRPCConnectionPoolError {
            return CacheListConcatenateFrontError(
                error: grpcStatusToSdkError(grpcStatus: err.makeGRPCStatus())
            )
        } catch {
            return CacheListConcatenateFrontError(
                error: UnknownError(message: "unknown list concatenate front error \(error)")
            )
        }
    }
    
    func listFetch(
        cacheName: String,
        listName: String,
        startIndex: Int? = nil,
        endIndex: Int? = nil
    ) async -> CacheListFetchResponse {
        var request = CacheClient__ListFetchRequest()
        request.listName = Data(listName.utf8)
        
        if let s = startIndex {
            request.startIndex = CacheClient__ListFetchRequest.OneOf_StartIndex.inclusiveStart(Int32(s))
        } else {
            request.startIndex = CacheClient__ListFetchRequest.OneOf_StartIndex.unboundedStart(CacheClient__Unbounded())
        }
        
        if let e = endIndex {
            request.endIndex = CacheClient__ListFetchRequest.OneOf_EndIndex.exclusiveEnd(Int32(e))
        } else {
            request.endIndex = CacheClient__ListFetchRequest.OneOf_EndIndex.unboundedEnd(CacheClient__Unbounded())
        }
        
        let headers = self.makeHeaders(cacheName: cacheName)
        let call = self.client.listFetch(
            request,
            callOptions: CallOptions(
                customMetadata: .init(
                    headers.map { ($0, $1) }
                )
            )
        )
        
        do {
            let result = try await call.response.get()
            switch result.list {
            case .found(let foundList):
                return CacheListFetchHit(values: foundList.values)
            case .missing:
                return CacheListFetchMiss()
            default:
                return CacheListFetchError(
                    error: UnknownError(message: "unknown list fetch error \(result)")
                )
            }
        } catch let err as GRPCStatus {
            return CacheListFetchError(error: grpcStatusToSdkError(grpcStatus: err))
        } catch let err as GRPCConnectionPoolError {
            return CacheListFetchError(
                error: grpcStatusToSdkError(grpcStatus: err.makeGRPCStatus())
            )
        } catch {
            return CacheListFetchError(
                error: UnknownError(message: "unknown list fetch error \(error)")
            )
        }
    }
    
    func listLength(
        cacheName: String,
        listName: String
    ) async -> CacheListLengthResponse {
        var request = CacheClient__ListLengthRequest()
        request.listName = Data(listName.utf8)
        
        let headers = self.makeHeaders(cacheName: cacheName)
        let call = self.client.listLength(
            request,
            callOptions: CallOptions(
                customMetadata: .init(
                    headers.map { ($0, $1) }
                )
            )
        )
        
        do {
            let result = try await call.response.get()
            switch result.list {
            case .found(let foundList):
                return CacheListLengthHit(length: foundList.length)
            case .missing:
                return CacheListLengthMiss()
            default:
                return CacheListLengthError(
                    error: UnknownError(message: "unknown list length error \(result)")
                )
            }
        } catch let err as GRPCStatus {
            return CacheListLengthError(error: grpcStatusToSdkError(grpcStatus: err))
        } catch let err as GRPCConnectionPoolError {
            return CacheListLengthError(
                error: grpcStatusToSdkError(grpcStatus: err.makeGRPCStatus())
            )
        } catch {
            return CacheListLengthError(
                error: UnknownError(message: "unknown list length error \(error)")
            )
        }
    }
    
    func listPopBack(
        cacheName: String,
        listName: String
    ) async -> CacheListPopBackResponse {
        var request = CacheClient__ListPopBackRequest()
        request.listName = Data(listName.utf8)
        
        let headers = self.makeHeaders(cacheName: cacheName)
        let call = self.client.listPopBack(
            request,
            callOptions: CallOptions(
                customMetadata: .init(
                    headers.map { ($0, $1) }
                )
            )
        )
        
        do {
            let result = try await call.response.get()
            switch result.list {
            case .found(let foundList):
                return CacheListPopBackHit(value: foundList.back)
            case .missing:
                return CacheListPopBackMiss()
            default:
                return CacheListPopBackError(
                    error: UnknownError(message: "unknown list pop back error \(result)")
                )
            }
        } catch let err as GRPCStatus {
            return CacheListPopBackError(error: grpcStatusToSdkError(grpcStatus: err))
        } catch let err as GRPCConnectionPoolError {
            return CacheListPopBackError(
                error: grpcStatusToSdkError(grpcStatus: err.makeGRPCStatus())
            )
        } catch {
            return CacheListPopBackError(
                error: UnknownError(message: "unknown list pop back error \(error)")
            )
        }
    }
    
    func listPopFront(
        cacheName: String,
        listName: String
    ) async -> CacheListPopFrontResponse {
        var request = CacheClient__ListPopFrontRequest()
        request.listName = Data(listName.utf8)
        
        let headers = self.makeHeaders(cacheName: cacheName)
        let call = self.client.listPopFront(
            request,
            callOptions: CallOptions(
                customMetadata: .init(
                    headers.map { ($0, $1) }
                )
            )
        )
        
        do {
            let result = try await call.response.get()
            switch result.list {
            case .found(let foundList):
                return CacheListPopFrontHit(value: foundList.front)
            case .missing:
                return CacheListPopFrontMiss()
            default:
                return CacheListPopFrontError(
                    error: UnknownError(message: "unknown list pop front error \(result)")
                )
            }
        } catch let err as GRPCStatus {
            return CacheListPopFrontError(error: grpcStatusToSdkError(grpcStatus: err))
        } catch let err as GRPCConnectionPoolError {
            return CacheListPopFrontError(
                error: grpcStatusToSdkError(grpcStatus: err.makeGRPCStatus())
            )
        } catch {
            return CacheListPopFrontError(
                error: UnknownError(message: "unknown list pop front error \(error)")
            )
        }
    }
    
    func listPushBack(
        cacheName: String,
        listName: String,
        value: ScalarType,
        truncateFrontToSize: Int? = nil,
        ttl: CollectionTtl? = nil
    ) async -> CacheListPushBackResponse {
        var request = CacheClient__ListPushBackRequest()
        request.listName = Data(listName.utf8)
        request.value = self.convertScalarTypeToData(element: value)
        request.truncateFrontToSize = UInt32(truncateFrontToSize ?? 0)
        
        let _ttl = ttl ?? CollectionTtl.fromCacheTtl()
        request.ttlMilliseconds = UInt64(_ttl.ttlMilliseconds() ?? self.defaultTtlSeconds * 1000)
        request.refreshTtl = _ttl.refreshTtl()
        
        let headers = self.makeHeaders(cacheName: cacheName)
        let call = self.client.listPushBack(
            request,
            callOptions: CallOptions(
                customMetadata: .init(
                    headers.map { ($0, $1) }
                )
            )
        )
        
        do {
            let result = try await call.response.get()
            return CacheListPushBackSuccess(length: result.listLength)
        } catch let err as GRPCStatus {
            return CacheListPushBackError(error: grpcStatusToSdkError(grpcStatus: err))
        } catch let err as GRPCConnectionPoolError {
            return CacheListPushBackError(
                error: grpcStatusToSdkError(grpcStatus: err.makeGRPCStatus())
            )
        } catch {
            return CacheListPushBackError(
                error: UnknownError(message: "unknown list push back error \(error)")
            )
        }
    }
    
    func listPushFront(
        cacheName: String,
        listName: String,
        value: ScalarType,
        truncateBackToSize: Int? = nil,
        ttl: CollectionTtl? = nil
    ) async -> CacheListPushFrontResponse {
        var request = CacheClient__ListPushFrontRequest()
        request.listName = Data(listName.utf8)
        request.value = self.convertScalarTypeToData(element: value)
        request.truncateBackToSize = UInt32(truncateBackToSize ?? 0)

        let _ttl = ttl ?? CollectionTtl.fromCacheTtl()
        request.ttlMilliseconds = UInt64(_ttl.ttlMilliseconds() ?? self.defaultTtlSeconds * 1000)
        request.refreshTtl = _ttl.refreshTtl()
        
        let headers = self.makeHeaders(cacheName: cacheName)
        let call = self.client.listPushFront(
            request,
            callOptions: CallOptions(
                customMetadata: .init(
                    headers.map { ($0, $1) }
                )
            )
        )
        
        do {
            let result = try await call.response.get()
            return CacheListPushFrontSuccess(length: result.listLength)
        } catch let err as GRPCStatus {
            return CacheListPushFrontError(error: grpcStatusToSdkError(grpcStatus: err))
        } catch let err as GRPCConnectionPoolError {
            return CacheListPushFrontError(
                error: grpcStatusToSdkError(grpcStatus: err.makeGRPCStatus())
            )
        } catch {
            return CacheListPushFrontError(
                error: UnknownError(message: "unknown list push front error \(error)")
            )
        }
    }
    
    func listRemoveValue(
        cacheName: String,
        listName: String,
        value: ScalarType
    ) async -> CacheListRemoveValueResponse {
        var request = CacheClient__ListRemoveRequest()
        request.listName = Data(listName.utf8)
        request.allElementsWithValue = self.convertScalarTypeToData(element: value)
        
        let headers = self.makeHeaders(cacheName: cacheName)
        let call = self.client.listRemove(
            request,
            callOptions: CallOptions(
                customMetadata: .init(
                    headers.map { ($0, $1) }
                )
            )
        )
        
        do {
            _ = try await call.response.get()
            return CacheListRemoveValueSuccess()
        } catch let err as GRPCStatus {
            return CacheListRemoveValueError(error: grpcStatusToSdkError(grpcStatus: err))
        } catch let err as GRPCConnectionPoolError {
            return CacheListRemoveValueError(
                error: grpcStatusToSdkError(grpcStatus: err.makeGRPCStatus())
            )
        } catch {
            return CacheListRemoveValueError(
                error: UnknownError(message: "unknown list remove value error \(error)")
            )
        }
    }
    
    func listRetain(
        cacheName: String,
        listName: String,
        startIndex: Int? = nil,
        endIndex: Int? = nil,
        ttl: CollectionTtl?
    ) async -> CacheListRetainResponse {
        var request = CacheClient__ListRetainRequest()
        request.listName = Data(listName.utf8)
        
        let _ttl = ttl ?? CollectionTtl.fromCacheTtl()
        request.ttlMilliseconds = UInt64(_ttl.ttlMilliseconds() ?? self.defaultTtlSeconds * 1000)
        request.refreshTtl = _ttl.refreshTtl()
        
        if let s = startIndex {
            request.startIndex = CacheClient__ListRetainRequest.OneOf_StartIndex.inclusiveStart(Int32(s))
        } else {
            request.startIndex = CacheClient__ListRetainRequest.OneOf_StartIndex.unboundedStart(CacheClient__Unbounded())
        }
        
        if let e = endIndex {
            request.endIndex = CacheClient__ListRetainRequest.OneOf_EndIndex.exclusiveEnd(Int32(e))
        } else {
            request.endIndex = CacheClient__ListRetainRequest.OneOf_EndIndex.unboundedEnd(CacheClient__Unbounded())
        }
        
        let headers = self.makeHeaders(cacheName: cacheName)
        let call = self.client.listRetain(
            request,
            callOptions: CallOptions(
                customMetadata: .init(
                    headers.map { ($0, $1) }
                )
            )
        )
        
        do {
            _ = try await call.response.get()
            return CacheListRetainSuccess()
        } catch let err as GRPCStatus {
            return CacheListRetainError(error: grpcStatusToSdkError(grpcStatus: err))
        } catch let err as GRPCConnectionPoolError {
            return CacheListRetainError(
                error: grpcStatusToSdkError(grpcStatus: err.makeGRPCStatus())
            )
        } catch {
            return CacheListRetainError(
                error: UnknownError(message: "unknown list retain error \(error)")
            )
        }
    }
}
