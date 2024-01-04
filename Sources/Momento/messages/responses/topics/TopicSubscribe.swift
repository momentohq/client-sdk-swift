import GRPC
import Foundation
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
@available(macOS 10.15, iOS 13, *)
public enum TopicSubscribeResponse {
    case subscription(TopicSubscription)
    case error(TopicSubscribeError)
}

/// Encapsulates a topic subscription. Iterate over the subscription's `stream` property to retrieve `TopicSubscriptionItemResponse` objects containing data published to the topic.
@available(macOS 10.15, iOS 13, *)
public class TopicSubscription {
    private var subscription: GRPCAsyncResponseStream<CacheClient_Pubsub__SubscriptionItem>
    private var lastSequenceNumber: UInt64
    private let pubsubClient: PubsubClientProtocol
    private let logger = Logger(label: "TopicSubscribeResponse")
    private var retry = true
    private let cacheName: String
    private let topicName: String
    
    lazy private var messageIterator = subscription.makeAsyncIterator()
    
    // Constructs an AsyncStream of subscription items using the iterator provided
    // by the GRPCAsyncResponseStream object.
    // If the iterator throws a `cancelled` GRPC status code, the AsyncStream will stop.
    // If the user calls `unsubscribe` (sets the retry boolean to false), the AsyncStream will stop.
    // Otherwise, given any other error, it will attempt to resubscribe (get new GRPCAsyncResponseStream
    // and corresponding iterator).
    lazy public var stream = AsyncStream<TopicSubscriptionItemResponse> {
        while (self.retry) {
            do {
                let item = try await self.messageIterator.next()
                if let nonNilItem = item {
                    if let processedItem = self.processResult(item: nonNilItem) {
                        return processedItem
                    }
                } else {
                    self.logger.debug("Received nil from iterator, attempting to resubscribe")
                    await self.attemptResubscribe()
                }
                
            } catch let err as GRPCStatus {
                if (err.code == .cancelled) {
                    self.logger.debug("Canceled, not resubscribing")
                    return nil
                } else {
                    self.logger.debug("Caught GRPCStatus \(err), attempting to resubscribe")
                    await self.attemptResubscribe()
                }
            } catch {
                self.logger.error("Unknown error from iterator: \(error.localizedDescription), attempting to resubscribe")
                await self.attemptResubscribe()
            }
        }
        return nil
    }
    
    init(
        subscription: GRPCAsyncResponseStream<CacheClient_Pubsub__SubscriptionItem>, 
        lastSequenceNumber: UInt64,
        pubsubClient: PubsubClientProtocol,
        cacheName: String,
        topicName: String
    ) {
        self.lastSequenceNumber = lastSequenceNumber
        self.pubsubClient = pubsubClient
        self.cacheName = cacheName
        self.topicName = topicName
        self.subscription = subscription
    }
    
    public func unsubscribe() {
        self.retry = false
    }
    
    internal func processResult(item: CacheClient_Pubsub__SubscriptionItem) -> TopicSubscriptionItemResponse? {
        let messageType = item.kind
        switch messageType {
        case .item:
            lastSequenceNumber = item.item.topicSequenceNumber
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
                resumeAtTopicSequenceNumber: self.lastSequenceNumber
            )
            switch (subResp) {
            case .subscription(let s):
                self.subscription = s.subscription
                self.messageIterator = s.subscription.makeAsyncIterator()
                logger.debug("Successfully resubscribed")
            case .error(let err):
                logger.error("Received error instead of new subscription: \(err)")
            }
        } catch {
            logger.error("Received error while attempting resubscribe: \(error)")
        }
    }
}

/**
 Indicates that an error occurred during the topic subscribe request.
 
 The response object includes the following fields you can use to determine how you want to handle the error:
 - `errorCode`: a unique Momento error code indicating the type of error that occurred
 - `message`: a human-readable description of the error
 - `innerException`: the original error that caused the failure; can be re-thrown
 */
public class TopicSubscribeError: ErrorResponseBase {}
