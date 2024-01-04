import Foundation

/**
 Enum for a get cache item request response type.
 
 Pattern matching can be used to operate on the appropriate subtype.
 ```swift
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
public enum GetResponse {
    case hit(GetHit)
    case miss(GetMiss)
    case error(GetError)
}

/// Indicates that the requested data was successfully retrieved from the cache and can be accessed by the fields `valueString` or `valueData`.
public class GetHit: Equatable, CustomStringConvertible {
    /// Cache item value as type String
    public let valueString: String
    /// Cache item value as type Data
    public let valueData: Data
    
    init(value: Data) {
        self.valueData = value
        self.valueString = String(decoding: value, as: UTF8.self)
    }

    public static func == (lhs: GetHit, rhs: GetHit) -> Bool {
        return lhs.valueData == rhs.valueData
    }
    
    public var description: String {
        return "[\(type(of: self))] Value: \(self.valueString)"
    }
}

/// Indicates that the requested data was not available in the cache.
public class GetMiss {}

/**
 Indicates that an error occurred during the get cache item request.
 
 The response object includes the following fields you can use to determine how you want to handle the error:
 - `errorCode`: a unique Momento error code indicating the type of error that occurred
 - `message`: a human-readable description of the error
 - `innerException`: the original error that caused the failure; can be re-thrown
 */
public class GetError: ErrorResponseBase {}
