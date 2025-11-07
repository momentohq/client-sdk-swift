import Foundation

/**
 Enum for a list length request response type.
 
 Pattern matching can be used to operate on the appropriate subtype.
 ```swift
  switch response {
  case .error(let err):
     print("Error: \(err)")
  case .miss(_):
     print("Miss")
  case .hit(let hit):
     print("Hit: \(hit.length)")
  }
 ```
 */
public enum ListLengthResponse {
    case hit(ListLengthHit)
    case miss(ListLengthMiss)
    case error(ListLengthError)
}

/// Indicates that the length of requested list was successfully retrieved from the cache.
public struct ListLengthHit: CustomStringConvertible {
    public let length: UInt32

    init(length: UInt32) {
        self.length = length
    }

    public var description: String {
        return "[\(type(of: self))] List length: \(self.length)"
    }
}

/// Indicates that the requested list was not available in the cache.
public struct ListLengthMiss {}

/// Indicates that an error occurred during the list length request.
///
/// The response object includes the following fields you can use to determine how you want to handle the error:
/// - `errorCode`: a unique Momento error code indicating the type of error that occurred
/// - `message`: a human-readable description of the error
/// - `innerException`: the original error that caused the failure; can be re-thrown
public struct ListLengthError: ErrorResponseBaseProtocol {
   public let message: String
   public let errorCode: MomentoErrorCode
   public let innerException: Error?

   init(error: SdkError) {
      self.message = error.message
      self.errorCode = error.errorCode
      self.innerException = error.innerException
   }
}
