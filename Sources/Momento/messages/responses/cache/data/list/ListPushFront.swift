/**
 Enum for a list push front request response type.
 
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
public enum ListPushFrontResponse {
    case success(ListPushFrontSuccess)
    case error(ListPushFrontError)
}

/// Indicates a successful list push front request.
public struct ListPushFrontSuccess: CustomStringConvertible {
    /// The new length of the list after the push front operation.
    public let listLength: UInt32

    init(length: UInt32) {
        self.listLength = length
    }

    public var description: String {
        return "[\(type(of: self))] List length after push: \(self.listLength)"
    }
}

/// Indicates that an error occurred during the list push front request.
///
/// The response object includes the following fields you can use to determine how you want to handle the error:
/// - `errorCode`: a unique Momento error code indicating the type of error that occurred
/// - `message`: a human-readable description of the error
/// - `innerException`: the original error that caused the failure; can be re-thrown
public struct ListPushFrontError: ErrorResponseBaseProtocol {
   public let message: String
   public let errorCode: MomentoErrorCode
   public let innerException: Error?

   init(error: SdkError) {
      self.message = error.message
      self.errorCode = error.errorCode
      self.innerException = error.innerException
   }
}
