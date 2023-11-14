import GRPC
import Foundation

public protocol TopicSubscribeResponse {}

@available(macOS 10.15, iOS 13, *)
public class TopicSubscribeSuccess: TopicSubscribeResponse, AsyncSequence, AsyncIteratorProtocol {
    public typealias Element = TopicSubscriptionItemResponse
    
    let subscription: GRPCAsyncResponseStream<CacheClient_Pubsub__SubscriptionItem>
    
    init(subscription: GRPCAsyncResponseStream<CacheClient_Pubsub__SubscriptionItem>) {
        self.subscription = subscription
    }
    
    public func makeAsyncIterator() -> TopicSubscribeSuccess {
        self
    }
    
    public func next() async -> Element? {
        while true {
            do {
                for try await item in subscription {
                    let result = processResult(item: item)
                    if result != nil {
                        print("returning next result: \(String(describing: result))")
                        return result
                    }
                }
            } catch let myError as GRPCStatus {
                return TopicSubscriptionItemError(
                    error: grpcStatusToSdkError(grpcStatus: myError)
                )
            } catch {
                // TODO: should go to logger
                print("unknown subscription item error \(error)")
                continue
            }
        }
    }
}

internal func processResult(item: CacheClient_Pubsub__SubscriptionItem) -> TopicSubscriptionItemResponse? {
    let messageType = item.kind
    switch messageType {
    case .item:
        return createTopicItemResponse(item: item.item)
    case .heartbeat:
        // TODO: should go to a logger
        print("topic client received a heartbeat")
    case .discontinuity:
        // TODO: should go to a logger
        print("topic client received a discontinuity")
    default:
        // TODO: should go to a logger
        print("topic client received unknown subscription item: \(item)")
    }
    return nil
}

public class TopicSubscribeError: ErrorResponseBase, TopicSubscribeResponse {}
