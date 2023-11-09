import GRPC
import NIO

final class AuthHeaderInterceptor<Request, Response>: ClientInterceptor<Request, Response> {

    private let credentialProvider: CredentialProviderProtocol

    init(credentialProvider: CredentialProviderProtocol) {
        self.credentialProvider = credentialProvider
    }

    override func send(_ part: GRPCClientRequestPart<Request>, promise: EventLoopPromise<Void>?, context: ClientInterceptorContext<Request, Response>) {
        guard case .metadata(var headers) = part else {
            return context.send(part, promise: promise)
        }

        let authToken = credentialProvider.authToken
        headers.add(name: "authorization", value: authToken)
        context.send(.metadata(headers), promise: promise)
    }
}

final class PubsubClientInterceptorFactory: CacheClient_Pubsub_PubsubClientInterceptorFactoryProtocol {
    
    private let credentialProvider: CredentialProviderProtocol
    
    init(credentialProvider: CredentialProviderProtocol) {
        self.credentialProvider = credentialProvider
    }
    
    func makePublishInterceptors() -> [ClientInterceptor<CacheClient_Pubsub__PublishRequest, CacheClient_Pubsub__Empty>] {
        [AuthHeaderInterceptor(credentialProvider: self.credentialProvider)]
    }

    func makeSubscribeInterceptors() -> [ClientInterceptor<CacheClient_Pubsub__SubscriptionRequest, CacheClient_Pubsub__SubscriptionItem>] {
        [AuthHeaderInterceptor(credentialProvider: self.credentialProvider)]
    }
}

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
        
        self.client = CacheClient_Pubsub_PubsubAsyncClient(channel: self.sharedChannel, interceptors: PubsubClientInterceptorFactory(credentialProvider: credentialProvider))
    }
    
    func publish() async -> PublishResponse {
        var request = CacheClient_Pubsub__PublishRequest()
        request.cacheName = "cache"
        request.topic = "bar"
        request.value.text = "baz"
        do {
            let result = try await self.client.publish(request)
            print(result)
            return PublishSuccess()
        } catch {
            return PublishError(error: error)
        }
    }
    
    func subscribe() async -> String {
        var request = CacheClient_Pubsub__SubscriptionRequest()
        request.cacheName = "cache"
        request.topic = "bar"
        let result = self.client.subscribe(request)
        print(result)
        
        print("About to print items loop:")
        do {
            for try await item in result {
                print("Item:", item)
            }
        } catch {
            print("Caught error while looping:", error)
        }
        
        return "calling client.subscribe"
    }
    
    
}
