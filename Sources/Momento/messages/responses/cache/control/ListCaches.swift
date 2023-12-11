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

public class ListCachesSuccess {
    public let caches: [CacheInfo]
    
    init(caches: [ControlClient__Cache]) {
        self.caches = caches.map({ cache in
            return CacheInfo(name: cache.cacheName)
        })
    }
}

public class ListCachesError: ErrorResponseBase {}
