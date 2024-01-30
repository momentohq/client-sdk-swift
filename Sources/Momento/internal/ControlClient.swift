import GRPC
import NIO
import NIOHPACK
import Logging

@available(macOS 10.15, iOS 13, *)
protocol ControlClientProtocol {
    func createCache(cacheName: String) async -> CreateCacheResponse
    
    func deleteCache(cacheName: String) async -> DeleteCacheResponse
    
    func listCaches() async -> ListCachesResponse

    func close()
}

@available(macOS 10.15, iOS 13, *)
class ControlClient: ControlClientProtocol {
    internal let logger: Logger
    private let credentialProvider: CredentialProviderProtocol
    private let configuration: CacheClientConfigurationProtocol
    private let grpcChannel: GRPCChannel
    private let eventLoopGroup = PlatformSupport.makeEventLoopGroup(loopCount: 1)
    private let client: ControlClient_ScsControlNIOClient
    private var firstRequest = true
    
    init(
        configuration: CacheClientConfigurationProtocol,
        credentialProvider: CredentialProviderProtocol
    ) {
        self.configuration = configuration
        self.credentialProvider = credentialProvider
        self.logger = Logger(label: "CacheControlClient")
        
        do {
            self.grpcChannel = try GRPCChannelPool.with(
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
        
        self.client = ControlClient_ScsControlNIOClient(
            channel: self.grpcChannel,
            defaultCallOptions: .init(
                timeLimit: .timeout(.seconds(Int64(self.configuration.transportStrategy.getClientTimeout())))
            ),
            interceptors: ControlClientInterceptorFactory(apiKey: credentialProvider.apiKey)
        )
    }
    
    func makeHeaders() -> [String:String] {
        let headers = constructHeaders(firstRequest: self.firstRequest)
        if self.firstRequest {
            self.firstRequest = false
        }
        return headers
    }
    
    func createCache(cacheName: String) async -> CreateCacheResponse {
        var request = ControlClient__CreateCacheRequest()
        request.cacheName = cacheName
        let call = self.client.createCache(request, callOptions: .init(
            customMetadata: .init(makeHeaders().map { ($0, $1) })
        ))
        do {
            _ = try await call.response.get()
            // Successful creation returns ControlClient__CreateCacheResponse
            return CreateCacheResponse.success(CreateCacheSuccess())
        } catch let err as GRPCStatus {
            if err.code == GRPCStatus.Code.alreadyExists {
                return CreateCacheResponse.alreadyExists(CreateCacheAlreadyExists())
            }
            return CreateCacheResponse.error(
                CreateCacheError(error: grpcStatusToSdkError(grpcStatus: err))
            )
        } catch let err as GRPCConnectionPoolError {
            return CreateCacheResponse.error(
                CreateCacheError(error: grpcStatusToSdkError(grpcStatus: err.makeGRPCStatus()))
            )
        } catch {
            return CreateCacheResponse.error(
                CreateCacheError(error: UnknownError(message: "unknown cache create error \(error)"))
            )
        }
    }
    
    func deleteCache(cacheName: String) async -> DeleteCacheResponse {
        var request = ControlClient__DeleteCacheRequest()
        request.cacheName = cacheName
        let call = self.client.deleteCache(request, callOptions: .init(
            customMetadata: .init(makeHeaders().map { ($0, $1) })
        ))
        do {
            _ = try await call.response.get()
            // Successful creation returns ControlClient__DeleteCacheResponse
            return DeleteCacheResponse.success(DeleteCacheSuccess())
        } catch let err as GRPCStatus {
            return DeleteCacheResponse.error(
                DeleteCacheError(error: grpcStatusToSdkError(grpcStatus: err))
            )
        } catch let err as GRPCConnectionPoolError {
            return DeleteCacheResponse.error(
                DeleteCacheError(error: grpcStatusToSdkError(grpcStatus: err.makeGRPCStatus()))
            )
        } catch {
            return DeleteCacheResponse.error(
                DeleteCacheError(error: UnknownError(message: "unknown cache create error \(error)"))
            )
        }
    }
    
    func listCaches() async -> ListCachesResponse {
        let call = self.client.listCaches(ControlClient__ListCachesRequest(), callOptions: .init(
            customMetadata: .init(makeHeaders().map { ($0, $1) })
        ))
        do {
            let result = try await call.response.get()
            // Successful creation returns ControlClient__ListCachesResponse
            self.logger.debug("list caches received: \(result.cache)")
            return ListCachesResponse.success(ListCachesSuccess(caches: result.cache))
        } catch let err as GRPCStatus {
            return ListCachesResponse.error(
                ListCachesError(error: grpcStatusToSdkError(grpcStatus: err))
            )
        } catch let err as GRPCConnectionPoolError {
            return ListCachesResponse.error(
                ListCachesError(error: grpcStatusToSdkError(grpcStatus: err.makeGRPCStatus()))
            )
        } catch {
            return ListCachesResponse.error(
                ListCachesError(error: UnknownError(message: "unknown cache create error \(error)"))
            )
        }
    }

    func close() {
        do {
            try self.grpcChannel.close().wait()
        } catch {
            self.logger.error("Failed to close cache control client GRPC channel: \(error)")
        }
    }
}
