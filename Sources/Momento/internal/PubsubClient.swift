@preconcurrency import GRPC
import Logging
import NIO
import NIOHPACK
import Atomics

protocol PubsubClientProtocol: Sendable {
    var configuration: TopicClientConfigurationProtocol { get }

    func publish(
        cacheName: String,
        topicName: String,
        value: ScalarType
    ) async throws -> TopicPublishResponse

    func subscribe(
        cacheName: String,
        topicName: String,
        resumeAtTopicSequenceNumber: UInt64?,
        resumeAtTopicSequencePage: UInt64?
    ) async throws -> TopicSubscribeResponse

    // Used by TopicSubscription for resubscribing after an error
    func subscribeRaw(
        cacheName: String,
        topicName: String,
        resumeAtTopicSequenceNumber: UInt64?,
        resumeAtTopicSequencePage: UInt64?
    ) async throws -> Result<SubscriptionComponents, TopicSubscribeError>

    func close()
}

final class PubsubClient: PubsubClientProtocol, Sendable {
    let logger = Logger(label: "PubsubClient")
    let configuration: TopicClientConfigurationProtocol
    let credentialProvider: CredentialProviderProtocol
    let eventLoopGroup = PlatformSupport.makeEventLoopGroup(loopCount: 1)
    let grpcManager: TopicsGrpcManager
    let client: CacheClient_Pubsub_PubsubAsyncClient
    let firstRequest = ManagedAtomic<Bool>(true)

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

    func makeHeaders() -> [String: String] {
        let isFirstRequest = self.firstRequest.exchange(false, ordering: .acquiringAndReleasing)
        let headers = constructHeaders(firstRequest: isFirstRequest, clientType: "topic")
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

        let call = self.client.makePublishCall(
            request,
            callOptions: .init(
                customMetadata: .init(makeHeaders().map { ($0, $1) }),
                timeLimit: .timeout(
                    .seconds(Int64(self.configuration.transportStrategy.getClientTimeout())))
            )
        )

        do {
            let result = try await call.response
            // Successful publish returns client_sdk_swift.CacheClient_Pubsub__Empty
            self.logger.debug("Publish response: \(result)")
            return TopicPublishResponse.success(TopicPublishSuccess())
        } catch let err as GRPCStatus {
            // The result is of type GRPCAsyncUnaryCall instead of UnaryCall so we manually extract
            // the trailers here instead before constructing the SdkError.
            //
            // We could use a pubsub client of type CacheClient_Pubsub_PubsubNIOClient instead
            // to use a publish method that returns UnaryCall, but it seems like that would require
            // nontrivial changes to the subscribe method below, so we put it in the backlog for now.
            do {
                let trailers = try await call.trailingMetadata
                return TopicPublishResponse.error(
                    TopicPublishError(
                        error: grpcStatusToSdkError(grpcStatus: err, metadata: trailers))
                )
            } catch {
                return TopicPublishResponse.error(
                    TopicPublishError(error: grpcStatusToSdkError(grpcStatus: err)))
            }
        } catch let err as GRPCConnectionPoolError {
            return TopicPublishResponse.error(
                TopicPublishError(error: grpcStatusToSdkError(grpcStatus: err.makeGRPCStatus())))
        } catch {
            return TopicPublishResponse.error(
                TopicPublishError(
                    error: SdkError.UnknownError(
                        UnknownError(
                            message: "unknown publish error: '\(error)'", innerException: error)))
            )
        }
    }

    func subscribeRaw(
        cacheName: String, topicName: String, resumeAtTopicSequenceNumber: UInt64?,
        resumeAtTopicSequencePage: UInt64?
    ) async throws -> Result<SubscriptionComponents, TopicSubscribeError> {
        var request = CacheClient_Pubsub__SubscriptionRequest()
        request.cacheName = cacheName
        request.topic = topicName
        request.resumeAtTopicSequenceNumber = UInt64(resumeAtTopicSequenceNumber ?? 0)
        request.sequencePage = UInt64(resumeAtTopicSequencePage ?? 0)

        let result:
            GRPCAsyncServerStreamingCall<
                CacheClient_Pubsub__SubscriptionRequest, CacheClient_Pubsub__SubscriptionItem
            > = self.client.makeSubscribeCall(
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
                    logger.debug(
                        "Received heartbeat as first message, returning subscription components")
                    return .success(
                        SubscriptionComponents(
                            subscribeCallResponse: result,
                            messageIterator: messageIterator,
                            lastSequenceNumber: request.resumeAtTopicSequenceNumber,
                            lastSequencePage: request.sequencePage
                        )
                    )
                default:
                    return .failure(
                        TopicSubscribeError(
                            error: SdkError.InternalServerError(
                                InternalServerError(
                                    message:
                                        "Expected heartbeat message for topic \(topicName) on cache \(cacheName), got \(String(describing: nonNilFirstElement.kind))"
                                ))))
                }
            }
            return .failure(
                TopicSubscribeError(
                    error: SdkError.InternalServerError(
                        InternalServerError(
                            message:
                                "Expected heartbeat message for topic \(topicName) on cache \(cacheName), got \(String(describing: firstElement))"
                        ))))
        } catch let err as GRPCStatus {
            // The result is of type GRPCAsyncServerStreamingCall instead of UnaryCall so we
            // manually extract the trailers here instead before constructing the SdkError.
            do {
                let trailers = try await result.trailingMetadata
                return .failure(
                    TopicSubscribeError(
                        error: grpcStatusToSdkError(grpcStatus: err, metadata: trailers))
                )
            } catch {
                return .failure(
                    TopicSubscribeError(error: grpcStatusToSdkError(grpcStatus: err)))
            }
        } catch let err as GRPCConnectionPoolError {
            return .failure(
                TopicSubscribeError(error: grpcStatusToSdkError(grpcStatus: err.makeGRPCStatus())))
        } catch {
            return .failure(
                TopicSubscribeError(
                    error: SdkError.UnknownError(
                        UnknownError(
                            message: "unknown subscribe error: '\(error)'", innerException: error)))
            )
        }
    }

    func subscribe(
        cacheName: String, topicName: String, resumeAtTopicSequenceNumber: UInt64?,
        resumeAtTopicSequencePage: UInt64?
    ) async throws -> TopicSubscribeResponse {
        let result = try await subscribeRaw(
            cacheName: cacheName,
            topicName: topicName,
            resumeAtTopicSequenceNumber: resumeAtTopicSequenceNumber,
            resumeAtTopicSequencePage: resumeAtTopicSequencePage
        )

        switch result {
        case .success(let components):
            return TopicSubscribeResponse.subscription(
                TopicSubscription(
                    components: components,
                    pubsubClient: self,
                    cacheName: cacheName,
                    topicName: topicName
                )
            )
        case .failure(let error):
            return TopicSubscribeResponse.error(error)
        }
    }

    func close() {
        self.grpcManager.close()
    }
}
