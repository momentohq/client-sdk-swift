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
    let grpcManager: TopicsGrpcManager
    let client: CacheClient_Pubsub_PubsubAsyncClient
    var firstRequest = true
    
    init(
        configuration: TopicClientConfigurationProtocol,
        credentialProvider: CredentialProviderProtocol
    ) {
        self.configuration = configuration
        self.credentialProvider = credentialProvider
        self.grpcManager = TopicsGrpcManager(
            credentialProvider: credentialProvider,
            eventLoopGroup: self.eventLoopGroup
        )
        self.client = self.grpcManager.getClient()
    }

    func makeHeaders() -> [String:String] {
        let headers = constructHeaders(firstRequest: self.firstRequest)
        if self.firstRequest {
            self.firstRequest = false
        }
        return headers
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
            let result = try await self.client.publish(
                request,
                callOptions: .init(
                    customMetadata: .init(makeHeaders().map { ($0, $1) }), 
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
                TopicPublishError(error: UnknownError(message: "unknown publish error: '\(error)'", innerException: error))
            )
        }
    }
    
    func subscribe(cacheName: String, topicName: String, resumeAtTopicSequenceNumber: UInt64?) async throws -> TopicSubscribeResponse {
        var request = CacheClient_Pubsub__SubscriptionRequest()
        request.cacheName = cacheName
        request.topic = topicName
        request.resumeAtTopicSequenceNumber = UInt64(resumeAtTopicSequenceNumber ?? 0)
        
        
        let result = self.client.makeSubscribeCall(
            request,
            callOptions: .init(
                customMetadata: .init(makeHeaders().map { ($0, $1) })
            )
        )
        
        do {
            var messageIterator = result.responseStream.makeAsyncIterator()
            let firstElement = try await messageIterator.next()
            if let nonNilFirstElement = firstElement {
                switch nonNilFirstElement.kind {
                case .heartbeat:
                    logger.debug("Received heartbeat as first message, returning subscription")
                    return TopicSubscribeResponse.subscription(
                        TopicSubscription(
                            subscribeCallResponse: result,
                            messageIterator: messageIterator,
                            lastSequenceNumber: request.resumeAtTopicSequenceNumber,
                            pubsubClient: self,
                            cacheName: cacheName,
                            topicName: topicName
                        )
                    )
                default:
                    return TopicSubscribeResponse.error(TopicSubscribeError(error: InternalServerError(message: "Expected heartbeat message for topic \(topicName) on cache \(cacheName), got \(String(describing: nonNilFirstElement.kind))")))
                }
            }
            return TopicSubscribeResponse.error(TopicSubscribeError(error: InternalServerError(message: "Expected heartbeat message for topic \(topicName) on cache \(cacheName), got \(String(describing: firstElement))")))
        } catch let err as GRPCStatus {
            return TopicSubscribeResponse.error(TopicSubscribeError(error: grpcStatusToSdkError(grpcStatus: err)))
        } catch let err as GRPCConnectionPoolError {
            return TopicSubscribeResponse.error(TopicSubscribeError(error: grpcStatusToSdkError(grpcStatus: err.makeGRPCStatus())))
        } catch {
            return TopicSubscribeResponse.error(
                TopicSubscribeError(error: UnknownError(message: "unknown subscribe error \(error)"))
            )
        }
    }
    
    func close() {
        self.grpcManager.close()
    }
}
