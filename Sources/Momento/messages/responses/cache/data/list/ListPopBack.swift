import Foundation

/**
 Enum for a list pop back request response type.
 
 Pattern matching can be used to operate on the appropriate subtype.
 ```
  switch response {
  case .error(let err):
     print("Error: \(err)")
  case .miss(_):
     print("Miss")
  case .hit(let hit):
     print("Hit: \(hit.valueString)")
  }
 ```
 */
public enum ListPopBackResponse {
    case hit(ListPopBackHit)
    case miss(ListPopBackMiss)
    case error(ListPopBackError)
}

/// Indicates that the requested data was successfully retrieved from the cache and can be accessed by the fields `valueString` or `valueData`.
public class ListPopBackHit {
    /// Popped value as String
    public let valueString: String
    /// Popped value as Data
    public let valueData: Data
    
    init(value: Data) {
        self.valueData = value
        self.valueString = String(decoding: value, as: UTF8.self)
    }
}

/// Indicates that the requested data was not available in the cache.
public class ListPopBackMiss {}

/**
 Indicates that an error occurred during the list pop back request.
 
 The response object includes the following fields you can use to determine how you want to handle the error:
 - `errorCode`: a unique Momento error code indicating the type of error that occurred
 - `message`: a human-readable description of the error
 - `innerException`: the original error that caused the failure; can be re-thrown
 */
public class ListPopBackError: ErrorResponseBase {}
