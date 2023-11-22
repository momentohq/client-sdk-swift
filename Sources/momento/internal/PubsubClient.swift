import Foundation
import GRPC
import NIO
import NIOHPACK

protocol PubsubClientProtocol {
    var logger: MomentoLoggerProtocol { get }
    var configuration: TopicClientConfigurationProtocol { get }
    
    func publish(
        cacheName: String,
        topicName: String,
        value: StringOrData
    ) async throws -> TopicPublishResponse

    func subscribe(
        cacheName: String,
        topicName: String
    ) async throws -> TopicSubscribeResponse
    
    func close()
}

@available(macOS 10.15, iOS 13, *)
class PubsubClient: PubsubClientProtocol {
    var logger: MomentoLoggerProtocol
    var configuration: TopicClientConfigurationProtocol
    var credentialProvider: CredentialProviderProtocol
    var sharedChannel: GRPCChannel
    var eventLoopGroup = PlatformSupport.makeEventLoopGroup(loopCount: 1)
    var client: CacheClient_Pubsub_PubsubAsyncClient
    
    init(
        configuration: TopicClientConfigurationProtocol,
        credentialProvider: CredentialProviderProtocol
    ) {
        self.configuration = configuration
        self.credentialProvider = credentialProvider
        self.logger = LogProvider.getLogger(name: "PubsubClient")
        
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
            interceptors: PubsubClientInterceptorFactory(apiKey: credentialProvider.apiKey)
        )
    }
    
    func publish(
        cacheName: String,
        topicName: String,
        value: StringOrData
    ) async -> TopicPublishResponse {
        var request = CacheClient_Pubsub__PublishRequest()
        request.cacheName = cacheName
        request.topic = topicName
        
        switch value {
        case .string(let s):
            request.value.text = s
        case .bytes(let b):
            request.value.binary = b
        }
        
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
