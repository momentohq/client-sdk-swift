import GRPC
import Logging

@available(macOS 10.15, iOS 13, *)
public enum TopicSubscribeResponse {
    case subscription(TopicSubscription)
    case error(TopicSubscribeError)
}

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

public class TopicSubscribeError: ErrorResponseBase {}
