import Foundation

public enum TopicValue {
    case string(String)
    case bytes(Data)
}

public protocol TopicSubscriptionItemResponse {}

public class TopicSubscriptionItemText: TopicSubscriptionItemResponse {
    public let value: String
    
    init(value: String) {
        self.value = value
    }
}

public class TopicSubscriptionItemBinary: TopicSubscriptionItemResponse {
    public let value: Data
    
    init(value: Data) {
        self.value = value
    }
}

public class TopicSubscriptionItemError: ErrorResponseBase, TopicSubscriptionItemResponse {}

internal func createTopicItemResponse(item: CacheClient_Pubsub__TopicItem) -> TopicSubscriptionItemResponse {
    switch item.value.kind {
    case .text:
        return TopicSubscriptionItemText(value: item.value.text)
    case .binary:
        return TopicSubscriptionItemBinary(value: item.value.binary)
    default:
        return TopicSubscriptionItemError(error: UnknownError(message: "unknown TopicItemResponse value: \(item.value)"))
    }
}
