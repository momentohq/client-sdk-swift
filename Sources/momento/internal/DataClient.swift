import Foundation
import GRPC
import NIO
import NIOHPACK

protocol DataClientProtocol {
    func get(cacheName: String, key: String) async -> CacheGetResponse
    func get(cacheName: String, key: Data) async -> CacheGetResponse
    
    func set(cacheName: String, key: String, value: String, ttl: TimeInterval?) async -> CacheSetResponse
    func set(cacheName: String, key: String, value: Data, ttl: TimeInterval?) async -> CacheSetResponse
    func set(cacheName: String, key: Data, value: String, ttl: TimeInterval?) async -> CacheSetResponse
    func set(cacheName: String, key: Data, value: Data, ttl: TimeInterval?) async -> CacheSetResponse
}

@available(macOS 10.15, iOS 13, *)
class DataClient: DataClientProtocol {
    internal let logger: MomentoLoggerProtocol
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
        self.logger = LogProvider.getLogger(name: "CacheDataClient")
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
            interceptors: DataClientInterceptorFactory(apiKey: credentialProvider.authToken)
        )
    }
    
    private func makeHeaders(cacheName: String) -> Dictionary<String, String> {
        return self.headers.merging(["cache": cacheName]) { (_, new) in new }
    }
    
    func get(cacheName: String, key: String) async -> CacheGetResponse {
        var request = CacheClient__GetRequest()
        request.cacheKey = Data(key.utf8)
        let headers = self.makeHeaders(cacheName: cacheName)
        return await doGet(request: request, headers: headers)
    }
    
    func get(cacheName: String, key: Data) async -> CacheGetResponse {
        var request = CacheClient__GetRequest()
        request.cacheKey = key
        let headers = self.makeHeaders(cacheName: cacheName)
        return await doGet(request: request, headers: headers)
    }
    
    private func doGet(
        request: CacheClient__GetRequest,
        headers: Dictionary<String, String>
    ) async -> CacheGetResponse {
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
                return CacheGetHit(value: result.cacheBody)
            } else if result.result == .miss {
                return CacheGetMiss()
            } else {
                return CacheGetError(
                    error: UnknownError(message: "unknown cache get error \(result)")
                )
            }
        } catch let err as GRPCStatus {
            return CacheGetError(error: grpcStatusToSdkError(grpcStatus: err))
        } catch let err as GRPCConnectionPoolError {
            return CacheGetError(
                error: grpcStatusToSdkError(grpcStatus: err.makeGRPCStatus())
            )
        } catch {
            return CacheGetError(
                error: UnknownError(message: "unknown cache get error \(error)")
            )
        }
    }
    
    func set(cacheName: String, key: String, value: String, ttl: TimeInterval? = nil) async -> CacheSetResponse {
        var request = CacheClient__SetRequest()
        request.cacheKey = Data(key.utf8)
        request.cacheBody = Data(value.utf8)
        request.ttlMilliseconds = UInt64(ttl ?? self.defaultTtlSeconds*1000)
        let headers = self.makeHeaders(cacheName: cacheName)
        return await doSet(request: request, headers: headers)
    }
    
    func set(cacheName: String, key: Data, value: String, ttl: TimeInterval? = nil) async -> CacheSetResponse {
        var request = CacheClient__SetRequest()
        request.cacheKey = key
        request.cacheBody = Data(value.utf8)
        request.ttlMilliseconds = UInt64(ttl ?? self.defaultTtlSeconds*1000)
        let headers = self.makeHeaders(cacheName: cacheName)
        return await doSet(request: request, headers: headers)
    }
    
    func set(cacheName: String, key: String, value: Data, ttl: TimeInterval? = nil) async -> CacheSetResponse {
        var request = CacheClient__SetRequest()
        request.cacheKey = Data(key.utf8)
        request.cacheBody = value
        request.ttlMilliseconds = UInt64(ttl ?? self.defaultTtlSeconds*1000)
        let headers = self.makeHeaders(cacheName: cacheName)
        return await doSet(request: request, headers: headers)
    }
    
    func set(cacheName: String, key: Data, value: Data, ttl: TimeInterval? = nil) async -> CacheSetResponse {
        var request = CacheClient__SetRequest()
        request.cacheKey = key
        request.cacheBody = value
        request.ttlMilliseconds = UInt64(ttl ?? self.defaultTtlSeconds*1000)
        let headers = self.makeHeaders(cacheName: cacheName)
        return await doSet(request: request, headers: headers)
    }
    
    private func doSet(
        request: CacheClient__SetRequest,
        headers: Dictionary<String, String>
    ) async -> CacheSetResponse {
        let call = self.client.set(
            request,
            callOptions: CallOptions(
                customMetadata: .init(
                    headers.map { ($0, $1) }
                )
            )
        )
        do {
            let result = try await call.response.get()
            return CacheSetSuccess()
        } catch let err as GRPCStatus {
            return CacheSetError(error: grpcStatusToSdkError(grpcStatus: err))
        } catch let err as GRPCConnectionPoolError {
            return CacheSetError(
                error: grpcStatusToSdkError(grpcStatus: err.makeGRPCStatus())
            )
        } catch {
            return CacheSetError(
                error: UnknownError(message: "unknown cache set error \(error)")
            )
        }
    }
}
