import GRPC
import NIO
import NIOHPACK
import Logging

@available(macOS 10.15, iOS 13, *)
protocol PubsubClientProtocol {
    var configuration: TopicClientConfigurationProtocol { get }
    
    func publish(
        cacheName: String,
        topicName: String,
        value: ScalarType
    ) async throws -> TopicPublishResponse

    func subscribe(
        cacheName: String,
        topicName: String,
        resumeAtTopicSequenceNumber: UInt64?
    ) async throws -> TopicSubscribeResponse
    
    func close()
}

@available(macOS 10.15, iOS 13, *)
class PubsubClient: PubsubClientProtocol {
    let logger = Logger(label: "PubsubClient")
    let configuration: TopicClientConfigurationProtocol
    let credentialProvider: CredentialProviderProtocol
    let eventLoopGroup = PlatformSupport.makeEventLoopGroup(loopCount: 1)
    let headers = ["agent": "swift:0.3.2"]
    let grpcManager: TopicsGrpcManager
    let client: CacheClient_Pubsub_PubsubAsyncClient
    
    init(
        configuration: TopicClientConfigurationProtocol,
        credentialProvider: CredentialProviderProtocol
    ) {
        self.configuration = configuration
        self.credentialProvider = credentialProvider
        self.grpcManager = TopicsGrpcManager(
            credentialProvider: credentialProvider,
            eventLoopGroup: self.eventLoopGroup,
            headers: self.headers
        )
        self.client = self.grpcManager.getClient()
    }
    
    func publish(
        cacheName: String,
        topicName: String,
        value: ScalarType
    ) async -> TopicPublishResponse {
        var request = CacheClient_Pubsub__PublishRequest()
        request.cacheName = cacheName
        request.topic = topicName
        
        switch value {
        case .string(let s):
            request.value.text = s
        case .data(let b):
            request.value.binary = b
        }
        
        do {
            let result = try await self.client.publish(request, callOptions: .init(
                timeLimit: .timeout(.seconds(Int64(self.configuration.transportStrategy.getClientTimeout())))
                )
            )
            // Successful publish returns client_sdk_swift.CacheClient_Pubsub__Empty
            self.logger.debug("Publish response: \(result)")
            return TopicPublishResponse.success(TopicPublishSuccess())
        } catch let err as GRPCStatus {
            return TopicPublishResponse.error(TopicPublishError(error: grpcStatusToSdkError(grpcStatus: err)))
        } catch let err as GRPCConnectionPoolError {
            return TopicPublishResponse.error(TopicPublishError(error: grpcStatusToSdkError(grpcStatus: err.makeGRPCStatus())))
        } catch {
            return TopicPublishResponse.error(
                TopicPublishError(error: UnknownError(message: "unknown publish error \(error)"))
            )
        }
    }
    
    func subscribe(cacheName: String, topicName: String, resumeAtTopicSequenceNumber: UInt64?) async throws -> TopicSubscribeResponse {
        var request = CacheClient_Pubsub__SubscriptionRequest()
        request.cacheName = cacheName
        request.topic = topicName
        request.resumeAtTopicSequenceNumber = UInt64(resumeAtTopicSequenceNumber ?? 0)
        
        let result = self.client.makeSubscribeCall(request)
        return TopicSubscribeResponse.subscription(
            TopicSubscription(
                subscribeCallResponse: result,
                lastSequenceNumber: request.resumeAtTopicSequenceNumber,
                pubsubClient: self,
                cacheName: cacheName,
                topicName: topicName
            )
        )
    }
    
    func close() {
        self.grpcManager.close()
    }
}
