import Foundation

/// Enum to represent the data received from a topic subscription.
///
/// Pattern matching can be used to operate on the appropriate subtype.
/// ```swift
///  switch response {
///  case .error(let err):
///      print("Error: \(err)")
///  case .itemText(let text):
///      print("Text: \(text)")
///  case .itemBinary(let binary):
///      print("Binary: \(String(decoding: binary, as: UTF8.self))")
///  }
/// ```
public enum TopicSubscriptionItemResponse {
    case itemText(TopicSubscriptionItemText)
    case itemBinary(TopicSubscriptionItemBinary)
    case error(TopicSubscriptionItemError)
}

/// Topic subscription item that was recieved as type String and can be accessed using the `value` field
public struct TopicSubscriptionItemText: CustomStringConvertible {
    public let value: String
    public let lastSequenceNumber: UInt64
    public let lastSequencePage: UInt64

    init(value: String, lastSequenceNumber: UInt64, lastSequencePage: UInt64) {
        self.value = value
        self.lastSequenceNumber = lastSequenceNumber
        self.lastSequencePage = lastSequencePage
    }

    public var description: String {
        return "[\(type(of: self))] Value: \(self.value)"
    }
}

/// Topic subscription item that was recieved as type Data and can be accessed using the `value` field
public struct TopicSubscriptionItemBinary: CustomStringConvertible {
    public let value: Data
    public let lastSequenceNumber: UInt64
    public let lastSequencePage: UInt64

    init(value: Data, lastSequenceNumber: UInt64, lastSequencePage: UInt64) {
        self.value = value
        self.lastSequenceNumber = lastSequenceNumber
        self.lastSequencePage = lastSequencePage
    }

    public var description: String {
        return "[\(type(of: self))] Value: \(String(decoding: self.value, as: UTF8.self))"
    }
}

/// Indicates that an error occurred while receiving a topic subscription item.
///
/// The response object includes the following fields you can use to determine how you want to handle the error:
/// - `errorCode`: a unique Momento error code indicating the type of error that occurred
/// - `message`: a human-readable description of the error
/// - `innerException`: the original error that caused the failure; can be re-thrown
public struct TopicSubscriptionItemError: ErrorResponseBaseProtocol {
    public let message: String
    public let errorCode: MomentoErrorCode
    public let innerException: Error?

    init(error: SdkError) {
        self.message = error.message
        self.errorCode = error.errorCode
        self.innerException = error.innerException
    }
}

internal func createTopicItemResponse(item: CacheClient_Pubsub__TopicItem)
    -> TopicSubscriptionItemResponse
{
    switch item.value.kind {
    case .text:
        return TopicSubscriptionItemResponse.itemText(
            TopicSubscriptionItemText(
                value: item.value.text, lastSequenceNumber: item.topicSequenceNumber,
                lastSequencePage: item.sequencePage
            )
        )
    case .binary:
        return TopicSubscriptionItemResponse.itemBinary(
            TopicSubscriptionItemBinary(
                value: item.value.binary, lastSequenceNumber: item.topicSequenceNumber,
                lastSequencePage: item.sequencePage
            )
        )
    default:
        return TopicSubscriptionItemResponse.error(
            TopicSubscriptionItemError(
                error: SdkError.UnknownError(
                    UnknownError(message: "unknown TopicItemResponse value: \(item.value)")))
        )
    }
}
