/// Represents information about a listed cache, such as its name. May include additional information in the future.
public class CacheInfo {
    public let name: String
    
    init(name: String) {
        self.name = name
    }
}

/**
 Enum for a list caches request response type.
 
 Pattern matching can be used to operate on the appropriate subtype.
 ```
  switch response {
  case .error(let err):
     print("Error: \(err)")
  case .success(let s):
     print("Success: \(s.caches.map{ $0.name })")
  }
 ```
 */
public enum ListCachesResponse {
    case success(ListCachesSuccess)
    case error(ListCachesError)
}

/// Indicates a successful list caches request.
public class ListCachesSuccess {
    /// An array of `CacheInfo` objects, containing information about each cache.
    public let caches: [CacheInfo]
    
    init(caches: [ControlClient__Cache]) {
        self.caches = caches.map({ cache in
            return CacheInfo(name: cache.cacheName)
        })
    }
}

/**
 Indicates that an error occurred during the list caches request.
 
 The response object includes the following fields you can use to determine how you want to handle the error:
 - `errorCode`: a unique Momento error code indicating the type of error that occurred
 - `message`: a human-readable description of the error
 - `innerException`: the original error that caused the failure; can be re-thrown
 */
public class ListCachesError: ErrorResponseBase {}
