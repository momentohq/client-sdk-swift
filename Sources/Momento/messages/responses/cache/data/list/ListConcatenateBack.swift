/**
 Enum for a list concatenate back request response type.
 
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
public enum ListConcatenateBackResponse {
    case success(ListConcatenateBackSuccess)
    case error(ListConcatenateBackError)
}

/// Indicates a successful list concatenate back request.
public class ListConcatenateBackSuccess {
    /// The new length of the list after the concatenate operation.
    public let listLength: UInt32

    init(length: UInt32) {
        self.listLength = length
    }
}

/**
 Indicates that an error occurred during the list concatenate back request.
 
 The response object includes the following fields you can use to determine how you want to handle the error:
 - `errorCode`: a unique Momento error code indicating the type of error that occurred
 - `message`: a human-readable description of the error
 - `innerException`: the original error that caused the failure; can be re-thrown
 */
public class ListConcatenateBackError: ErrorResponseBase {}
