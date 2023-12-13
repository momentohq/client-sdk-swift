import Foundation

/**
 Enum for a list length request response type.
 
 Pattern matching can be used to operate on the appropriate subtype.
 ```
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
public class ListLengthHit {
    public let length: UInt32
    
    init(length: UInt32) {
        self.length = length
    }
}

/// Indicates that the requested list was not available in the cache.
public class ListLengthMiss {}

/**
 Indicates that an error occurred during the list length request.
 
 The response object includes the following fields you can use to determine how you want to handle the error:
 - `errorCode`: a unique Momento error code indicating the type of error that occurred
 - `message`: a human-readable description of the error
 - `innerException`: the original error that caused the failure; can be re-thrown
 */
public class ListLengthError: ErrorResponseBase {}
