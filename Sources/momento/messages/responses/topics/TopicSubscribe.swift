import GRPC
import Foundation

public protocol TopicSubscribeResponse {}

@available(macOS 10.15, iOS 13, *)
public class TopicSubscribeSuccess: TopicSubscribeResponse {
    public let subscription: AsyncCompactMapSequence<GRPCAsyncResponseStream<CacheClient_Pubsub__SubscriptionItem>, TopicSubscriptionItemResponse>
    
    init(subscription: GRPCAsyncResponseStream<CacheClient_Pubsub__SubscriptionItem>) {
        self.subscription = subscription.compactMap(processResult)
    }
}

public var subscribeLogger = DefaultMomentoLogger(loggerName: "momento-topics-subscribe", level: DefaultMomentoLoggerLevel.debug)

internal func processResult(item: CacheClient_Pubsub__SubscriptionItem) -> TopicSubscriptionItemResponse? {
    let messageType = item.kind
    switch messageType {
    case .item:
        return createTopicItemResponse(item: item.item)
    case .heartbeat:
        subscribeLogger.info(msg: "topic client received a heartbeat")
    case .discontinuity:
        subscribeLogger.info(msg: "topic client received a discontinuity")
    default:
        subscribeLogger.error(msg: "topic client received unknown subscription item: \(item)")
    }
    return nil
}

public class TopicSubscribeError: ErrorResponseBase, TopicSubscribeResponse {}
