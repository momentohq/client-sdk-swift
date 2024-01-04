/**
 Enum for a list retain request response type.
 
 Pattern matching can be used to operate on the appropriate subtype.
 ```swift
  switch response {
  case .error(let err):
     print("Error: \(err)")
  case .success(_):
     print("Success")
  }
 ```
 */
public enum ListRetainResponse {
    case success(ListRetainSuccess)
    case error(ListRetainError)
}

/// Indicates a successful list retain request.
public class ListRetainSuccess {}

/**
 Indicates that an error occurred during the list retain request.
 
 The response object includes the following fields you can use to determine how you want to handle the error:
 - `errorCode`: a unique Momento error code indicating the type of error that occurred
 - `message`: a human-readable description of the error
 - `innerException`: the original error that caused the failure; can be re-thrown
 */
public class ListRetainError: ErrorResponseBase {}
