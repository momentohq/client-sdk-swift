/**
 Enum for a set cache item request response type.
 
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
public enum SetResponse {
    case success(SetSuccess)
    case error(SetError)
}

/// Indicates a successful set cache item request.
public class SetSuccess {}

/**
 Indicates that an error occurred during the set cache item request.
 
 The response object includes the following fields you can use to determine how you want to handle the error:
 - `errorCode`: a unique Momento error code indicating the type of error that occurred
 - `message`: a human-readable description of the error
 - `innerException`: the original error that caused the failure; can be re-thrown
 */
public class SetError: ErrorResponseBase {}
