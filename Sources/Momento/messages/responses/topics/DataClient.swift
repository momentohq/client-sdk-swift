import Foundation
import GRPC
import NIO
import NIOHPACK
import Logging

@available(macOS 10.15, iOS 13, *)
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
    ) async -> ListConcatenateBackResponse

    func listConcatenateFront(
        cacheName: String,
        listName: String,
        values: [ScalarType],
        truncateBackToSize: Int?,
        ttl: CollectionTtl?
    ) async -> ListConcatenateFrontResponse

    func listFetch(
        cacheName: String,
        listName: String,
        startIndex: Int?,
        endIndex: Int?
    ) async -> ListFetchResponse

    func listLength(
        cacheName: String,
        listName: String
    ) async -> ListLengthResponse
    
    func listPopBack(
        cacheName: String,
        listName: String
    ) async -> ListPopBackResponse
    
    func listPopFront(
        cacheName: String,
        listName: String
    ) async -> ListPopFrontResponse
    
    func listPushBack(
        cacheName: String,
        listName: String,
        value: ScalarType,
        truncateFrontToSize: Int?,
        ttl: CollectionTtl?
    ) async -> ListPushBackResponse
    
    func listPushFront(
        cacheName: String,
        listName: String,
        value: ScalarType,
        truncateBackToSize: Int?,
        ttl: CollectionTtl?
    ) async -> ListPushFrontResponse
    
    func listRemoveValue(
        cacheName: String,
        listName: String,
        value: ScalarType
    ) async -> ListRemoveValueResponse
    
    func listRetain(
        cacheName: String,
        listName: String,
        startIndex: Int?,
        endIndex: Int?,
        ttl: CollectionTtl?
    ) async -> ListRetainResponse
}

@available(macOS 10.15, iOS 13, *)
class DataClient: DataClientProtocol {
    internal let logger: Logger
    private let credentialProvider: CredentialProviderProtocol
    private let configuration: CacheClientConfigurationProtocol
    private let grpcChannel: GRPCChannel
    private let eventLoopGroup = PlatformSupport.makeEventLoopGroup(loopCount: 1)
    private let client: CacheClient_ScsNIOClient
    private let defaultTtlSeconds: TimeInterval
    private var firstRequest = true
    
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
        
        self.client = CacheClient_ScsNIOClient(
            channel: self.grpcChannel,
            defaultCallOptions: .init(
                timeLimit: .timeout(.seconds(Int64(self.configuration.transportStrategy.getClientTimeout())))
            ),
            interceptors: DataClientInterceptorFactory(apiKey: credentialProvider.apiKey)
        )
    }
    
    private func makeHeaders(cacheName: String) -> Dictionary<String, String> {
        let headers = constructHeaders(firstRequest: self.firstRequest, cacheName: cacheName)
        if self.firstRequest {
            self.firstRequest = false
        }
        return headers
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
    ) async -> ListConcatenateBackResponse {
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
            return ListConcatenateBackResponse.success(ListConcatenateBackSuccess(length: result.listLength))
        } catch let err as GRPCStatus {
            return ListConcatenateBackResponse.error(
                ListConcatenateBackError(error: grpcStatusToSdkError(grpcStatus: err))
            )
        } catch let err as GRPCConnectionPoolError {
            return ListConcatenateBackResponse.error(
                ListConcatenateBackError(error: grpcStatusToSdkError(grpcStatus: err.makeGRPCStatus()))
            )
        } catch {
            return ListConcatenateBackResponse.error(ListConcatenateBackError(
                error: UnknownError(message: "unknown list concatenate back error \(error)"))
            )
        }
    }
    
    func listConcatenateFront(
        cacheName: String,
        listName: String,
        values: [ScalarType],
        truncateBackToSize: Int? = nil,
        ttl: CollectionTtl? = nil
    ) async -> ListConcatenateFrontResponse {
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
            return ListConcatenateFrontResponse.success(ListConcatenateFrontSuccess(length: result.listLength))
        } catch let err as GRPCStatus {
            return ListConcatenateFrontResponse.error(ListConcatenateFrontError(error: grpcStatusToSdkError(grpcStatus: err)))
        } catch let err as GRPCConnectionPoolError {
            return ListConcatenateFrontResponse.error(
                ListConcatenateFrontError(error: grpcStatusToSdkError(grpcStatus: err.makeGRPCStatus()))
            )
        } catch {
            return ListConcatenateFrontResponse.error(
                ListConcatenateFrontError(error: UnknownError(message: "unknown list concatenate front error \(error)"))
            )
        }
    }
    
    func listFetch(
        cacheName: String,
        listName: String,
        startIndex: Int? = nil,
        endIndex: Int? = nil
    ) async -> ListFetchResponse {
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
                return ListFetchResponse.hit(ListFetchHit(values: foundList.values))
            case .missing:
                return ListFetchResponse.miss(ListFetchMiss())
            default:
                return ListFetchResponse.error(
                    ListFetchError(error: UnknownError(message: "unknown list fetch error \(result)"))
                )
            }
        } catch let err as GRPCStatus {
            return ListFetchResponse.error(ListFetchError(error: grpcStatusToSdkError(grpcStatus: err)))
        } catch let err as GRPCConnectionPoolError {
            return ListFetchResponse.error(
                ListFetchError(error: grpcStatusToSdkError(grpcStatus: err.makeGRPCStatus()))
            )
        } catch {
            return ListFetchResponse.error(
                ListFetchError(error: UnknownError(message: "unknown list fetch error \(error)"))
            )
        }
    }
    
    func listLength(
        cacheName: String,
        listName: String
    ) async -> ListLengthResponse {
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
                return ListLengthResponse.hit(ListLengthHit(length: foundList.length))
            case .missing:
                return ListLengthResponse.miss(ListLengthMiss())
            default:
                return ListLengthResponse.error(
                    ListLengthError(error: UnknownError(message: "unknown list length error \(result)"))
                )
            }
        } catch let err as GRPCStatus {
            return ListLengthResponse.error(ListLengthError(error: grpcStatusToSdkError(grpcStatus: err)))
        } catch let err as GRPCConnectionPoolError {
            return ListLengthResponse.error(
                ListLengthError(error: grpcStatusToSdkError(grpcStatus: err.makeGRPCStatus()))
            )
        } catch {
            return ListLengthResponse.error(
                ListLengthError(error: UnknownError(message: "unknown list length error \(error)"))
            )
        }
    }
    
    func listPopBack(
        cacheName: String,
        listName: String
    ) async -> ListPopBackResponse {
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
                return ListPopBackResponse.hit(ListPopBackHit(value: foundList.back))
            case .missing:
                return ListPopBackResponse.miss(ListPopBackMiss())
            default:
                return ListPopBackResponse.error(
                    ListPopBackError(error: UnknownError(message: "unknown list pop back error \(result)"))
                )
            }
        } catch let err as GRPCStatus {
            return ListPopBackResponse.error(ListPopBackError(error: grpcStatusToSdkError(grpcStatus: err)))
        } catch let err as GRPCConnectionPoolError {
            return ListPopBackResponse.error(
                ListPopBackError(error: grpcStatusToSdkError(grpcStatus: err.makeGRPCStatus()))
            )
        } catch {
            return ListPopBackResponse.error(
                ListPopBackError(error: UnknownError(message: "unknown list pop back error \(error)"))
            )
        }
    }
    
    func listPopFront(
        cacheName: String,
        listName: String
    ) async -> ListPopFrontResponse {
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
                return ListPopFrontResponse.hit(ListPopFrontHit(value: foundList.front))
            case .missing:
                return ListPopFrontResponse.miss(ListPopFrontMiss())
            default:
                return ListPopFrontResponse.error(
                    ListPopFrontError(error: UnknownError(message: "unknown list pop front error \(result)"))
                )
            }
        } catch let err as GRPCStatus {
            return ListPopFrontResponse.error(ListPopFrontError(error: grpcStatusToSdkError(grpcStatus: err)))
        } catch let err as GRPCConnectionPoolError {
            return ListPopFrontResponse.error(
                ListPopFrontError(error: grpcStatusToSdkError(grpcStatus: err.makeGRPCStatus()))
            )
        } catch {
            return ListPopFrontResponse.error(
                ListPopFrontError(error: UnknownError(message: "unknown list pop front error \(error)"))
            )
        }
    }
    
    func listPushBack(
        cacheName: String,
        listName: String,
        value: ScalarType,
        truncateFrontToSize: Int? = nil,
        ttl: CollectionTtl? = nil
    ) async -> ListPushBackResponse {
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
            return ListPushBackResponse.success(ListPushBackSuccess(length: result.listLength))
        } catch let err as GRPCStatus {
            return ListPushBackResponse.error(ListPushBackError(error: grpcStatusToSdkError(grpcStatus: err)))
        } catch let err as GRPCConnectionPoolError {
            return ListPushBackResponse.error(
                ListPushBackError(error: grpcStatusToSdkError(grpcStatus: err.makeGRPCStatus()))
            )
        } catch {
            return ListPushBackResponse.error(
                ListPushBackError(error: UnknownError(message: "unknown list push back error \(error)"))
            )
        }
    }
    
    func listPushFront(
        cacheName: String,
        listName: String,
        value: ScalarType,
        truncateBackToSize: Int? = nil,
        ttl: CollectionTtl? = nil
    ) async -> ListPushFrontResponse {
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
            return ListPushFrontResponse.success(ListPushFrontSuccess(length: result.listLength))
        } catch let err as GRPCStatus {
            return ListPushFrontResponse.error(ListPushFrontError(error: grpcStatusToSdkError(grpcStatus: err)))
        } catch let err as GRPCConnectionPoolError {
            return ListPushFrontResponse.error(
                ListPushFrontError(error: grpcStatusToSdkError(grpcStatus: err.makeGRPCStatus()))
            )
        } catch {
            return ListPushFrontResponse.error(
                ListPushFrontError(error: UnknownError(message: "unknown list push front error \(error)"))
            )
        }
    }
    
    func listRemoveValue(
        cacheName: String,
        listName: String,
        value: ScalarType
    ) async -> ListRemoveValueResponse {
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
            return ListRemoveValueResponse.success(ListRemoveValueSuccess())
        } catch let err as GRPCStatus {
            return ListRemoveValueResponse.error(ListRemoveValueError(error: grpcStatusToSdkError(grpcStatus: err)))
        } catch let err as GRPCConnectionPoolError {
            return ListRemoveValueResponse.error(
                ListRemoveValueError(error: grpcStatusToSdkError(grpcStatus: err.makeGRPCStatus()))
            )
        } catch {
            return ListRemoveValueResponse.error(
                ListRemoveValueError(error: UnknownError(message: "unknown list remove value error \(error)"))
            )
        }
    }
    
    func listRetain(
        cacheName: String,
        listName: String,
        startIndex: Int? = nil,
        endIndex: Int? = nil,
        ttl: CollectionTtl?
    ) async -> ListRetainResponse {
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
            return ListRetainResponse.success(ListRetainSuccess())
        } catch let err as GRPCStatus {
            return ListRetainResponse.error(ListRetainError(error: grpcStatusToSdkError(grpcStatus: err)))
        } catch let err as GRPCConnectionPoolError {
            return ListRetainResponse.error(
                ListRetainError(error: grpcStatusToSdkError(grpcStatus: err.makeGRPCStatus()))
            )
        } catch {
            return ListRetainResponse.error(
                ListRetainError(error: UnknownError(message: "unknown list retain error \(error)"))
            )
        }
    }
}
