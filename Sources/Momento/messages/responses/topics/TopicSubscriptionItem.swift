import Foundation

/**
 Enum to represent the data received from a topic subscription.
 
 Pattern matching can be used to operate on the appropriate subtype.
 ```
  switch response {
  case .error(let err):
      print("Error: \(err)")
  case .itemText(let text):
      print("Text: \(text)")
  case .itemBinary(let binary):
      print("Binary: \(binary)")
  }
 ```
 */
public enum TopicSubscriptionItemResponse {
    case itemText(TopicSubscriptionItemText)
    case itemBinary(TopicSubscriptionItemBinary)
    case error(TopicSubscriptionItemError)
}

/// Topic subscription item that was recieved as type String and can be accessed using the `value` field
public class TopicSubscriptionItemText {
    public let value: String
    
    init(value: String) {
        self.value = value
    }
}

/// Topic subscription item that was recieved as type Data and can be accessed using the `value` field
public class TopicSubscriptionItemBinary {
    public let value: Data
    
    init(value: Data) {
        self.value = value
    }
}

/**
 Indicates that an error occurred while receiving a topic subscription item.
 
 The response object includes the following fields you can use to determine how you want to handle the error:
 - `errorCode`: a unique Momento error code indicating the type of error that occurred
 - `message`: a human-readable description of the error
 - `innerException`: the original error that caused the failure; can be re-thrown
 */
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
