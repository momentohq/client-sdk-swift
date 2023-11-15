import GRPC
import NIO
import NIOHPACK

final class AuthHeaderInterceptor<Request, Response>: ClientInterceptor<Request, Response> {

    private let apiKey: String

    init(apiKey: String) {
        self.apiKey = apiKey
    }

    override func send(
        _ part: GRPCClientRequestPart<Request>,
        promise: EventLoopPromise<Void>?,
        context: ClientInterceptorContext<Request, Response>
    ) {
        guard case .metadata(var headers) = part else {
            return context.send(part, promise: promise)
        }

        headers.add(name: "authorization", value: apiKey)
        context.send(.metadata(headers), promise: promise)
    }
}

final class PubsubClientInterceptorFactory: CacheClient_Pubsub_PubsubClientInterceptorFactoryProtocol {
    
    private let apiKey: String
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    func makePublishInterceptors() -> [ClientInterceptor<CacheClient_Pubsub__PublishRequest, CacheClient_Pubsub__Empty>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }

    func makeSubscribeInterceptors() -> [ClientInterceptor<CacheClient_Pubsub__SubscriptionRequest, CacheClient_Pubsub__SubscriptionItem>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
}

protocol PubsubClientProtocol {
    var logger: MomentoLoggerProtocol { get }
    var configuration: TopicClientConfigurationProtocol { get }
    
    func publish(
        cacheName: String,
        topicName: String,
        value: String
    ) async throws -> TopicPublishResponse
    
    func subscribe(
        cacheName: String,
        topicName: String
    ) async throws -> TopicSubscribeResponse
    
    func close()
}

@available(macOS 10.15, *)
class PubsubClient: PubsubClientProtocol {
    var logger: MomentoLoggerProtocol
    var configuration: TopicClientConfigurationProtocol
    var credentialProvider: CredentialProviderProtocol
    var sharedChannel: GRPCChannel
    var eventLoopGroup = PlatformSupport.makeEventLoopGroup(loopCount: 1)
    var client: CacheClient_Pubsub_PubsubAsyncClient
    
    init(
        logger: MomentoLoggerProtocol,
        configuration: TopicClientConfigurationProtocol,
        credentialProvider: CredentialProviderProtocol
    ) {
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
        
        let headers = ["agent": "swift:0.1.0"]

        self.client = CacheClient_Pubsub_PubsubAsyncClient(
            channel: self.sharedChannel,
            defaultCallOptions: .init(
                customMetadata: .init(headers.map { ($0, $1) }),
                timeLimit: .timeout(.seconds(Int64(self.configuration.transportStrategy.getClientTimeout())))
            ),
            interceptors: PubsubClientInterceptorFactory(apiKey: credentialProvider.authToken)
        )
    }
    
    func publish(
        cacheName: String,
        topicName: String,
        value: String
    ) async -> TopicPublishResponse {
        var request = CacheClient_Pubsub__PublishRequest()
        request.cacheName = cacheName
        request.topic = topicName
        request.value.text = value
        do {
            let result = try await self.client.publish(request)
            // Successful publish returns client_sdk_swift.CacheClient_Pubsub__Empty
            self.logger.debug(msg: "Publish response: \(result)")
            // TODO: I'm just resetting customMetadata after it's sent once to prevent the agent
            //  header from being sent more than once. Need to repeat this in subscribe().
            self.client.defaultCallOptions.customMetadata = HPACKHeaders()
            return TopicPublishSuccess()
        } catch let err as GRPCStatus {
            return TopicPublishError(error: grpcStatusToSdkError(grpcStatus: err))
        } catch let err as GRPCConnectionPoolError {
            return TopicPublishError(error: grpcStatusToSdkError(grpcStatus: err.makeGRPCStatus()))
        } catch {
            return TopicPublishError(error: UnknownError(message: "unknown publish error \(error)"))
        }
    }
    
    func subscribe(cacheName: String, topicName: String) async throws -> TopicSubscribeResponse {
        var request = CacheClient_Pubsub__SubscriptionRequest()
        request.cacheName = cacheName
        request.topic = topicName
        
        let result = self.client.subscribe(request)
        return TopicSubscribeSuccess(subscription: result)
    }
    
    func close() {
        let _ = self.client.channel.close()
    }
}
