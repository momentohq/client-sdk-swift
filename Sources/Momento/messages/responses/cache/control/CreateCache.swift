/**
 Enum for a create cache request response type.
 
 Pattern matching can be used to operate on the appropriate subtype.
 ```
  switch response {
  case .error(let err):
     print("Error: \(err)")
  case .alreadyExists(_):
     print("Cache already exists")
  case .success(_):
     print("Success")
  }
 ```
 */
public enum CreateCacheResponse {
    case success(CreateCacheSuccess)
    case alreadyExists(CreateCacheAlreadyExists)
    case error(CreateCacheError)
}

/// Indicates a successful create cache request.
public class CreateCacheSuccess {}

/// Indicates that the cache already exists, so there was nothing to do.
public class CreateCacheAlreadyExists {}

/**
 Indicates that an error occurred during the create cache request.
 
 The response object includes the following fields you can use to determine how you want to handle the error:
 - `errorCode`: a unique Momento error code indicating the type of error that occurred
 - `message`: a human-readable description of the error
 - `innerException`: the original error that caused the failure; can be re-thrown
 */
public class CreateCacheError: ErrorResponseBase {}
