/**
 Enum for a delete cache item request response type.
 
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
public enum DeleteResponse {
    case success(DeleteSuccess)
    case error(DeleteError)
}

/// Indicates a successful delete cache item request.
public class DeleteSuccess {}

/**
 Indicates that an error occurred during the delete cache item request.
 
 The response object includes the following fields you can use to determine how you want to handle the error:
 - `errorCode`: a unique Momento error code indicating the type of error that occurred
 - `message`: a human-readable description of the error
 - `innerException`: the original error that caused the failure; can be re-thrown
 */
public class DeleteError: ErrorResponseBase {}
