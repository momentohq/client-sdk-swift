/**
 Enum for a delete cache request response type.
 
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
public enum DeleteCacheResponse {
    case success(DeleteCacheSuccess)
    case error(DeleteCacheError)
}

/// Indicates a successful delete cache request.
public struct DeleteCacheSuccess {}

/// Indicates that an error occurred during the delete cache request.
///
/// The response object includes the following fields you can use to determine how you want to handle the error:
/// - `errorCode`: a unique Momento error code indicating the type of error that occurred
/// - `message`: a human-readable description of the error
/// - `innerException`: the original error that caused the failure; can be re-thrown
public struct DeleteCacheError: ErrorResponseBaseProtocol {
   public let message: String
   public let errorCode: MomentoErrorCode
   public let innerException: Error?

   init(error: SdkError) {
      self.message = error.message
      self.errorCode = error.errorCode
      self.innerException = error.innerException
   }
}
