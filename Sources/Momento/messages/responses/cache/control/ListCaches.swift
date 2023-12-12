public class CacheInfo {
    public let name: String
    
    init(name: String) {
        self.name = name
    }
}

public enum ListCachesResponse {
    case success(ListCachesSuccess)
    case error(ListCachesError)
}

public class ListCachesSuccess: CustomStringConvertible {
    public let caches: [CacheInfo]
    
    init(caches: [ControlClient__Cache]) {
        self.caches = caches.map({ cache in
            return CacheInfo(name: cache.cacheName)
        })
    }
    
    public var description: String {
        return "[\(type(of: self))] Length of caches list: \(self.caches.count)"
    }
}

public class ListCachesError: ErrorResponseBase {}
