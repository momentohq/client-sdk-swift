import Foundation

public enum TopicSubscriptionItemResponse {
    case itemText(TopicSubscriptionItemText)
    case itemBinary(TopicSubscriptionItemBinary)
    case error(TopicSubscriptionItemError)
}

public class TopicSubscriptionItemText: CustomStringConvertible {
    public let value: String
    
    init(value: String) {
        self.value = value
    }
    
    public var description: String {
        return "[\(type(of: self))] Value: \(self.value)"
    }
}

public class TopicSubscriptionItemBinary: CustomStringConvertible {
    public let value: Data
    
    init(value: Data) {
        self.value = value
    }
    
    public var description: String {
        return "[\(type(of: self))] Value: \(self.value)"
    }
}

public class TopicSubscriptionItemError: ErrorResponseBase {}

internal func createTopicItemResponse(item: CacheClient_Pubsub__TopicItem) -> TopicSubscriptionItemResponse {
    switch item.value.kind {
    case .text:
        return TopicSubscriptionItemResponse.itemText(TopicSubscriptionItemText(value: item.value.text))
    case .binary:
        return TopicSubscriptionItemResponse.itemBinary(TopicSubscriptionItemBinary(value: item.value.binary))
    default:
        return TopicSubscriptionItemResponse.error(
            TopicSubscriptionItemError(error: UnknownError(message: "unknown TopicItemResponse value: \(item.value)"))
        )
    }
}
