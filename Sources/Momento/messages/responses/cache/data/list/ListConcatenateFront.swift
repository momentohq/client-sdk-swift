/**
 Enum for a list concatenate front request response type.
 
 Pattern matching can be used to operate on the appropriate subtype.
 ```swift
  switch response {
  case .error(let err):
     print("Error: \(err)")
  case .success(let s):
     print("Success: \(s.listLength)")
  }
 ```
 */
public enum ListConcatenateFrontResponse {
    case success(ListConcatenateFrontSuccess)
    case error(ListConcatenateFrontError)
}

/// Indicates a successful list concatenate front request.
public struct ListConcatenateFrontSuccess: CustomStringConvertible {
    /// The new length of the list after the concatenate operation.
    public let listLength: UInt32

    init(length: UInt32) {
        self.listLength = length
    }

    public var description: String {
        return "[\(type(of: self))] List length post-concatenation: \(self.listLength)"
    }
}

/// Indicates that an error occurred during the list concatenate front request.
///
/// The response object includes the following fields you can use to determine how you want to handle the error:
/// - `errorCode`: a unique Momento error code indicating the type of error that occurred
/// - `message`: a human-readable description of the error
/// - `innerException`: the original error that caused the failure; can be re-thrown
public struct ListConcatenateFrontError: ErrorResponseBaseProtocol {
   public let message: String
   public let errorCode: MomentoErrorCode
   public let innerException: Error?

   init(error: SdkError) {
      self.message = error.message
      self.errorCode = error.errorCode
      self.innerException = error.innerException
   }
}
