import Foundation
import GRPC
import NIO
import NIOHPACK

protocol DataClientProtocol {
    func get(cacheName: String, key: StringOrData) async -> CacheGetResponse
    
    func set(
        cacheName: String,
        key: StringOrData,
        value: StringOrData,
        ttl: TimeInterval?
    ) async -> CacheSetResponse
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
            interceptors: DataClientInterceptorFactory(apiKey: credentialProvider.apiKey)
        )
    }
    
    private func makeHeaders(cacheName: String) -> Dictionary<String, String> {
        return self.headers.merging(["cache": cacheName]) { (_, new) in new }
    }
    
    func get(cacheName: String, key: StringOrData) async -> CacheGetResponse {
        var request = CacheClient__GetRequest()
        
        switch key {
        case .string(let s):
            request.cacheKey = Data(s.utf8)
        case .bytes(let b):
            request.cacheKey = b
        }
        
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
    
    func set(
        cacheName: String,
        key: StringOrData,
        value: StringOrData,
        ttl: TimeInterval? = nil
    ) async -> CacheSetResponse {
        var request = CacheClient__SetRequest()
        request.ttlMilliseconds = UInt64(ttl ?? self.defaultTtlSeconds*1000)
        
        switch key {
        case .string(let s):
            request.cacheKey = Data(s.utf8)
        case .bytes(let b):
            request.cacheKey = b
        }
        
        switch value {
        case .string(let s):
            request.cacheBody = Data(s.utf8)
        case .bytes(let b):
            request.cacheBody = b
        }
        
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
