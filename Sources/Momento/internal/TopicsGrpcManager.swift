import GRPC
import NIO
import NIOHPACK

@available(macOS 10.15, iOS 13, *)
internal class TopicsGrpcManager {
    var channel: GRPCChannel
    var client: CacheClient_Pubsub_PubsubAsyncClient
    
    init(
        credentialProvider: CredentialProviderProtocol,
        eventLoopGroup: EventLoopGroup,
        headers: [String: String]
    ) {
        do {
            self.channel = try GRPCChannelPool.with(
                target: .host(credentialProvider.cacheEndpoint, port: 443),
                transportSecurity: .tls(
                    GRPCTLSConfiguration.makeClientDefault(compatibleWith: eventLoopGroup)
                ),
                eventLoopGroup: eventLoopGroup
            ) { configuration in
                // Additional configuration, like keepalive.
                // Note: Keepalive should in most circumstances not be necessary.
                configuration.keepalive = ClientConnectionKeepalive(
                    interval: .seconds(10),
                    timeout: .seconds(5)
                )
            }
        } catch {
            fatalError("Failed to open GRPC channel")
        }
        
        self.client = CacheClient_Pubsub_PubsubAsyncClient(
            channel: self.channel,
            defaultCallOptions: .init(
                customMetadata: .init(headers.map { ($0, $1) })
            ),
            interceptors: PubsubClientInterceptorFactory(apiKey: credentialProvider.apiKey)
        )
    }
    
    func getClient() -> CacheClient_Pubsub_PubsubAsyncClient {
        return self.client
    }
    
    func close() {
        let _ = self.channel.close()
    }
}
