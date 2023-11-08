import GRPC
@available(macOS 10.15, *)
class PubsubClient: PubsubClientProtocol {
    var logger: MomentoLoggerProtocol
    var configuration: TopicClientConfiguration
    var credentialProvider: CredentialProviderProtocol
    var sharedChannel: GRPCChannel
    var eventLoopGroup = PlatformSupport.makeEventLoopGroup(loopCount: 1)
    var client: CacheClient_Pubsub_PubsubAsyncClient
    
    init(logger: MomentoLoggerProtocol, configuration: TopicClientConfiguration, credentialProvider: CredentialProviderProtocol) {
        self.logger = logger
        self.configuration = configuration
        self.credentialProvider = credentialProvider
        
        do {
            self.sharedChannel = try GRPCChannelPool.with(
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
        
        self.client = CacheClient_Pubsub_PubsubAsyncClient(channel: self.sharedChannel)
    }
    
    func publish() async -> String {
        var request = CacheClient_Pubsub__PublishRequest()
        request.cacheName = "foo"
        request.topic = "bar"
        request.value.text = "baz"
        do {
            var result = try await self.client.publish(request)
            print(result)
        } catch {
            print(error)
        }
        return "calling client.publish"
    }
    
    func subscribe() async -> String {
        return "calling client.subscribe"
    }
    
    
}
