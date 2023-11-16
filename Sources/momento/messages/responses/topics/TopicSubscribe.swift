import GRPC
import Foundation

public protocol TopicSubscribeResponse {}

@available(macOS 10.15, iOS 13, *)
public class TopicSubscribeSuccess: TopicSubscribeResponse {
    public lazy var subscription: AsyncCompactMapSequence<GRPCAsyncResponseStream<CacheClient_Pubsub__SubscriptionItem>, TopicSubscriptionItemResponse> = _subscription.compactMap(self.processResult)
    
    private let _subscription: GRPCAsyncResponseStream<CacheClient_Pubsub__SubscriptionItem>
    
    private let logger: MomentoLoggerProtocol
    
    init(subscription: GRPCAsyncResponseStream<CacheClient_Pubsub__SubscriptionItem>, logger: MomentoLoggerProtocol) {
        self._subscription = subscription
        self.logger = logger
    }
    
    internal func processResult(item: CacheClient_Pubsub__SubscriptionItem) -> TopicSubscriptionItemResponse? {
        let messageType = item.kind
        switch messageType {
        case .item:
            return createTopicItemResponse(item: item.item)
        case .heartbeat:
            self.logger.info(msg: "topic client received a heartbeat")
        case .discontinuity:
            self.logger.info(msg: "topic client received a discontinuity")
        default:
            self.logger.error(msg: "topic client received unknown subscription item: \(item)")
        }
        return nil
    }
}

public class TopicSubscribeError: ErrorResponseBase, TopicSubscribeResponse {}
