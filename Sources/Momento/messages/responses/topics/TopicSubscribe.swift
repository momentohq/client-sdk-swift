import Foundation
import GRPC
import Logging

/**
 Enum for a topic subscribe request response type.

 Pattern matching can be used to operate on the appropriate subtype.
 ```swift
  switch response {
  case .error(let err):
      print("Error: \(err)")
  case .subscription(let sub):
      for try await item in sub.stream {...}
  }
 ```
 */

public enum TopicSubscribeResponse {
    case subscription(TopicSubscription)
    case error(TopicSubscribeError)
}

/// Encapsulates a topic subscription. Iterate over the subscription's `stream` property to retrieve `TopicSubscriptionItemResponse` objects containing data published to the topic.

public final class TopicSubscription {
    private var subscribeCallResponse:
        GRPCAsyncServerStreamingCall<
            CacheClient_Pubsub__SubscriptionRequest, CacheClient_Pubsub__SubscriptionItem
        >
    private var lastSequenceNumber: UInt64
    private var lastSequencePage: UInt64
    private let pubsubClient: PubsubClientProtocol
    private let logger = Logger(label: "TopicSubscribeResponse")
    private let cacheName: String
    private let topicName: String
    private var messageIterator: any AsyncIteratorProtocol

    // Constructs an AsyncStream of subscription items using the iterator provided
    // by the GRPCAsyncResponseStream object.
    // If the iterator throws a `cancelled` GRPC status code, the AsyncStream will stop.
    // If the user calls `unsubscribe`, the AsyncStream will stop.
    // Otherwise, given any other error, it will attempt to resubscribe
    // (i.e. get new GRPCAsyncResponseStream and corresponding iterator).
    lazy public var stream = AsyncStream<TopicSubscriptionItemResponse> {
        while true {
            do {
                let item = try await self.messageIterator.next()
                if let nonNilItem = item {
                    if let processedItem = self.processResult(
                        item: nonNilItem as! CacheClient_Pubsub__SubscriptionItem)
                    {
                        return processedItem
                    }
                } else {
                    self.logger.debug("Received nil from iterator, attempting to resubscribe")
                    await self.attemptResubscribe()
                }

            } catch let err as GRPCStatus {
                if err.code == .cancelled {
                    self.logger.debug("Canceled, not resubscribing")
                    return nil
                } else if err.code == .resourceExhausted {
                    self.logger.debug("Too many subscribers, not resubscribing")
                    return nil
                } else if err.code == .unavailable {
                    // If the topic client is closed but the subscription is still open, we'll
                    // receive a "shutdown" error that gets converted into an "unavailable"
                    // GRPCStatus object. See: https://github.com/grpc/grpc-swift/blob/53e2739912b0d3090cfa6a8345fcadbe6fe2ba1a/Sources/GRPC/ConnectionPool/ConnectionPool.swift#L1025
                    self.logger.debug("Connection was shutdown, not resubscribing")
                    return nil
                } else {
                    self.logger.debug("Caught GRPCStatus \(err), attempting to resubscribe")
                    await self.attemptResubscribe()
                }
            } catch {
                self.logger.error(
                    "Unknown error from iterator: \(error.localizedDescription), attempting to resubscribe"
                )
                await self.attemptResubscribe()
            }
        }
    }

    init(
        subscribeCallResponse: GRPCAsyncServerStreamingCall<
            CacheClient_Pubsub__SubscriptionRequest, CacheClient_Pubsub__SubscriptionItem
        >,
        messageIterator: any AsyncIteratorProtocol,
        lastSequenceNumber: UInt64,
        lastSequencePage: UInt64,
        pubsubClient: PubsubClientProtocol,
        cacheName: String,
        topicName: String
    ) {
        self.lastSequenceNumber = lastSequenceNumber
        self.lastSequencePage = lastSequencePage
        self.pubsubClient = pubsubClient
        self.cacheName = cacheName
        self.topicName = topicName
        self.subscribeCallResponse = subscribeCallResponse
        self.messageIterator = messageIterator
    }

    public func unsubscribe() {
        self.subscribeCallResponse.cancel()
    }

    internal func processResult(item: CacheClient_Pubsub__SubscriptionItem)
        -> TopicSubscriptionItemResponse?
    {
        let messageType = item.kind
        switch messageType {
        case .item:
            lastSequenceNumber = item.item.topicSequenceNumber
            lastSequencePage = item.item.sequencePage
            return createTopicItemResponse(item: item.item)
        case .heartbeat:
            logger.debug("topic client received a heartbeat")
        case .discontinuity:
            logger.debug("topic client received a discontinuity")
        default:
            logger.error("topic client received unknown subscription item: \(item)")
        }
        return nil
    }

    internal func attemptResubscribe() async {
        do {
            let subResp = try await self.pubsubClient.subscribe(
                cacheName: self.cacheName,
                topicName: self.topicName,
                resumeAtTopicSequenceNumber: self.lastSequenceNumber,
                resumeAtTopicSequencePage: self.lastSequencePage
            )
            switch subResp {
            case .subscription(let s):
                self.messageIterator = s.messageIterator
                logger.debug("Successfully resubscribed")
            case .error(let err):
                logger.error("Received error instead of new subscription: \(err)")
            }
        } catch {
            logger.error("Received error while attempting resubscribe: \(error)")
        }
    }
}

/// Indicates that an error occurred during the topic subscribe request.
///
/// The response object includes the following fields you can use to determine how you want to handle the error:
/// - `errorCode`: a unique Momento error code indicating the type of error that occurred
/// - `message`: a human-readable description of the error
/// - `innerException`: the original error that caused the failure; can be re-thrown
public struct TopicSubscribeError: ErrorResponseBaseProtocol {
    public let message: String
    public let errorCode: MomentoErrorCode
    public let innerException: Error?

    init(error: SdkError) {
        self.message = error.message
        self.errorCode = error.errorCode
        self.innerException = error.innerException
    }
}
