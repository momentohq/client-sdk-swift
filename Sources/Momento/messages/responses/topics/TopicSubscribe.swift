import GRPC
import Logging

/**
 Enum for a topic subscribe request response type.
 
 Pattern matching can be used to operate on the appropriate subtype.
 ```
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
    public typealias SubscriptionItemsMap = AsyncCompactMapSequence<GRPCAsyncResponseStream<CacheClient_Pubsub__SubscriptionItem>, TopicSubscriptionItemResponse>
    
    public let stream: SubscriptionItemsMap
    
    init(subscription: GRPCAsyncResponseStream<CacheClient_Pubsub__SubscriptionItem>) {
        self.stream = subscription.compactMap(processResult)
    }
}

internal func processResult(item: CacheClient_Pubsub__SubscriptionItem) -> TopicSubscriptionItemResponse? {
    let logger = Logger(label: "TopicSubscribeResponse")
    let messageType = item.kind
    switch messageType {
    case .item:
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

/**
 Indicates that an error occurred during the topic subscribe request.
 
 The response object includes the following fields you can use to determine how you want to handle the error:
 - `errorCode`: a unique Momento error code indicating the type of error that occurred
 - `message`: a human-readable description of the error
 - `innerException`: the original error that caused the failure; can be re-thrown
 */
public class TopicSubscribeError: ErrorResponseBase {}
