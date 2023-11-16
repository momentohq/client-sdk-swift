import GRPC
import Foundation

public protocol TopicSubscribeResponse {}

@available(macOS 10.15, iOS 13, *)
public class TopicSubscribeSuccess: TopicSubscribeResponse {
    public var subscription: AsyncCompactMapSequence<GRPCAsyncResponseStream<CacheClient_Pubsub__SubscriptionItem>, TopicSubscriptionItemResponse>
    
    init(subscription: GRPCAsyncResponseStream<CacheClient_Pubsub__SubscriptionItem>) {
        self.subscription = subscription.compactMap(processResult)
    }
}

internal func processResult(item: CacheClient_Pubsub__SubscriptionItem) -> TopicSubscriptionItemResponse? {
    var logger: MomentoLoggerProtocol
    do {
        logger = try LogProvider.getLogger(name: "TopicSubscribeResponse")
    } catch {
        fatalError("Failed to initialize TopicSubscribeResponse logger")
    }
    
    let messageType = item.kind
    switch messageType {
    case .item:
        return createTopicItemResponse(item: item.item)
    case .heartbeat:
        logger.info(msg: "topic client received a heartbeat")
    case .discontinuity:
        logger.info(msg: "topic client received a discontinuity")
    default:
        logger.error(msg: "topic client received unknown subscription item: \(item)")
    }
    return nil
}

public class TopicSubscribeError: ErrorResponseBase, TopicSubscribeResponse {}
