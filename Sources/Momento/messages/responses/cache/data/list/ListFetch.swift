import Foundation

/**
 Enum for a list fetch request response type.
 
 Pattern matching can be used to operate on the appropriate subtype.
 ```swift
  switch response {
  case .error(let err):
     print("Error: \(err)")
  case .miss(_):
     print("Miss")
  case .hit(let hit):
     print("Hit: \(hit.valueListString)")
  }
 ```
 */
public enum ListFetchResponse {
    case hit(ListFetchHit)
    case miss(ListFetchMiss)
    case error(ListFetchError)
}

/// Indicates that the requested list was successfully retrieved from the cache and can be accessed by the fields `valueListString` or `valueListData`.
public struct ListFetchHit: CustomStringConvertible {
    /// List values as type String
    public let valueListString: [String]
    /// List values as type Data
    public let valueListData: [Data]

    init(values: [Data]) {
        self.valueListData = values
        self.valueListString = values.map { String(decoding: $0, as: UTF8.self) }
    }

    public var description: String {
        return "[\(type(of: self))] List length: \(self.valueListData.count)"
    }
}

/// Indicates that the requested data was not available in the cache.
public struct ListFetchMiss {}

/// Indicates that an error occurred during the list fetch request.
///
/// The response object includes the following fields you can use to determine how you want to handle the error:
/// - `errorCode`: a unique Momento error code indicating the type of error that occurred
/// - `message`: a human-readable description of the error
/// - `innerException`: the original error that caused the failure; can be re-thrown
public struct ListFetchError: ErrorResponseBaseProtocol {
   public let message: String
   public let errorCode: MomentoErrorCode
   public let innerException: Error?

   init(error: SdkError) {
      self.message = error.message
      self.errorCode = error.errorCode
      self.innerException = error.innerException
   }
}
