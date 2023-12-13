/**
 Enum for a list push front request response type.
 
 Pattern matching can be used to operate on the appropriate subtype.
 ```
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
public class ListPushFrontSuccess {
    /// The new length of the list after the push front operation.
    public let listLength: UInt32
    
    init(length: UInt32) {
        self.listLength = length
    }
}

/**
 Indicates that an error occurred during the list push front request.
 
 The response object includes the following fields you can use to determine how you want to handle the error:
 - `errorCode`: a unique Momento error code indicating the type of error that occurred
 - `message`: a human-readable description of the error
 - `innerException`: the original error that caused the failure; can be re-thrown
 */
public class ListPushFrontError: ErrorResponseBase {}
