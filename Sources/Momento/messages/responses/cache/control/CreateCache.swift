/// Enum for a create cache request response type.
///
/// Pattern matching can be used to operate on the appropriate subtype.
/// ```swift
///  switch response {
///  case .error(let err):
///     print("Error: \(err)")
///  case .alreadyExists(_):
///     print("Cache already exists")
///  case .success(_):
///     print("Success")
///  }
/// ```
public enum CreateCacheResponse {
   case success(CreateCacheSuccess)
   case alreadyExists(CreateCacheAlreadyExists)
   case error(CreateCacheError)
}

/// Indicates a successful create cache request.
public struct CreateCacheSuccess {}

/// Indicates that the cache already exists, so there was nothing to do.
public struct CreateCacheAlreadyExists {}

/// Indicates that an error occurred during the create cache request.
///
/// The response object includes the following fields you can use to determine how you want to handle the error:
/// - `errorCode`: a unique Momento error code indicating the type of error that occurred
/// - `message`: a human-readable description of the error
/// - `innerException`: the original error that caused the failure; can be re-thrown
public struct CreateCacheError: ErrorResponseBaseProtocol {
   public let message: String
   public let errorCode: MomentoErrorCode
   public let innerException: Error?

   init(error: SdkError) {
      self.message = error.message
      self.errorCode = error.errorCode
      self.innerException = error.innerException
   }
}
