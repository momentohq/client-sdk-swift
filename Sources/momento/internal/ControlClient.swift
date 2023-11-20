import Foundation
import GRPC
import NIO
import NIOHPACK

protocol ControlClientProtocol {
    func createCache(cacheName: String) async -> CacheCreateResponse
    
    func deleteCache(cacheName: String) async -> CacheDeleteResponse
    
    func listCaches() async -> CacheListResponse
}

@available(macOS 10.15, iOS 13, *)
class ControlClient: ControlClientProtocol {
    internal let logger: MomentoLoggerProtocol
    private let credentialProvider: CredentialProviderProtocol
    private let configuration: CacheClientConfigurationProtocol
    private let sharedChannel: GRPCChannel
    private let eventLoopGroup = PlatformSupport.makeEventLoopGroup(loopCount: 1)
    private let client: ControlClient_ScsControlNIOClient
    
    init(
        configuration: CacheClientConfigurationProtocol,
        credentialProvider: CredentialProviderProtocol
    ) {
        self.configuration = configuration
        self.credentialProvider = credentialProvider
        self.logger = LogProvider.getLogger(name: "CacheControlClient")
        
        do {
            self.sharedChannel = try GRPCChannelPool.with(
                target: .host(credentialProvider.controlEndpoint, port: 443),
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
        
        let headers = ["agent": "swift:0.1.0"]
        
        self.client = ControlClient_ScsControlNIOClient(
            channel: self.sharedChannel,
            defaultCallOptions: .init(
                customMetadata: .init(headers.map { ($0, $1) }),
                timeLimit: .timeout(.seconds(Int64(self.configuration.transportStrategy.getClientTimeout())))
            ),
            interceptors: ControlClientInterceptorFactory(apiKey: credentialProvider.authToken)
        )
    }
    
    func createCache(cacheName: String) async -> CacheCreateResponse {
        var request = ControlClient__CreateCacheRequest()
        request.cacheName = cacheName
        let call = self.client.createCache(request)
        do {
            _ = try await call.response.get()
            // Successful creation returns ControlClient__CreateCacheResponse
            return CacheCreateSuccess()
        } catch let err as GRPCStatus {
            if err.code == GRPCStatus.Code.alreadyExists {
                return CacheCreateCacheAlreadyExists()
            }
            return CacheCreateError(error: grpcStatusToSdkError(grpcStatus: err))
        } catch let err as GRPCConnectionPoolError {
            return CacheCreateError(error: grpcStatusToSdkError(grpcStatus: err.makeGRPCStatus()))
        } catch {
            return CacheCreateError(error: UnknownError(message: "unknown cache create error \(error)"))
        }
    }
    
    func deleteCache(cacheName: String) async -> CacheDeleteResponse {
        var request = ControlClient__DeleteCacheRequest()
        request.cacheName = cacheName
        let call = self.client.deleteCache(request)
        do {
            _ = try await call.response.get()
            // Successful creation returns ControlClient__DeleteCacheResponse
            return CacheDeleteSuccess()
        } catch let err as GRPCStatus {
            return CacheDeleteError(error: grpcStatusToSdkError(grpcStatus: err))
        } catch let err as GRPCConnectionPoolError {
            return CacheDeleteError(error: grpcStatusToSdkError(grpcStatus: err.makeGRPCStatus()))
        } catch {
            return CacheDeleteError(error: UnknownError(message: "unknown cache create error \(error)"))
        }
    }
    
    func listCaches() async -> CacheListResponse {
        let call = self.client.listCaches(ControlClient__ListCachesRequest())
        do {
            let result = try await call.response.get()
            // Successful creation returns ControlClient__ListCachesResponse
            self.logger.debug(msg: "list caches received: \(result.cache)")
            return CacheListSuccess(caches: result.cache)
        } catch let err as GRPCStatus {
            return CacheListError(error: grpcStatusToSdkError(grpcStatus: err))
        } catch let err as GRPCConnectionPoolError {
            return CacheListError(error: grpcStatusToSdkError(grpcStatus: err.makeGRPCStatus()))
        } catch {
            return CacheListError(error: UnknownError(message: "unknown cache create error \(error)"))
        }
    }
}
