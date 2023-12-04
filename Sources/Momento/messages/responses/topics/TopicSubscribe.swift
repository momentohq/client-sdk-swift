import GRPC
import Logging

public protocol TopicSubscribeResponse {}

@available(macOS 10.15, iOS 13, *)
public class TopicSubscribeSuccess: TopicSubscribeResponse {
    public let subscription: AsyncCompactMapSequence<GRPCAsyncResponseStream<CacheClient_Pubsub__SubscriptionItem>, TopicSubscriptionItemResponse>
    
    init(subscription: GRPCAsyncResponseStream<CacheClient_Pubsub__SubscriptionItem>) {
        self.subscription = subscription.compactMap(processResult)
    }
}

internal func processResult(item: CacheClient_Pubsub__SubscriptionItem) -> TopicSubscriptionItemResponse? {
    let logger = Logger(label: "MomentoTopicSubscribeResponse")
    let messageType = item.kind
    switch messageType {
    case .item:
        return createTopicItemResponse(item: item.item)
    case .heartbeat:
        logger.debug("Momento: topic client received a heartbeat")
    case .discontinuity:
        logger.debug("Momento: topic client received a discontinuity")
    default:
        logger.error("Momento: topic client received unknown subscription item: \(item)")
    }
    return nil
}

public class TopicSubscribeError: ErrorResponseBase, TopicSubscribeResponse {}
