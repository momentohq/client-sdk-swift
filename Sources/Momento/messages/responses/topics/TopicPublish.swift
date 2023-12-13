/**
 Enum for a topic publish request response type.
 
 Pattern matching can be used to operate on the appropriate subtype.
 ```
  switch response {
  case .error(let err):
     print("Error: \(err)")
  case .success(_):
     print("Success")
  }
 ```
 */
public enum TopicPublishResponse {
    case success(TopicPublishSuccess)
    case error(TopicPublishError)
}

/// Indicates a successful topic publish request.
public class TopicPublishSuccess {}

/**
 Indicates that an error occurred during the topic publish request.
 
 The response object includes the following fields you can use to determine how you want to handle the error:
 - `errorCode`: a unique Momento error code indicating the type of error that occurred
 - `message`: a human-readable description of the error
 - `innerException`: the original error that caused the failure; can be re-thrown
 */
public class TopicPublishError: ErrorResponseBase {}
