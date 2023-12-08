public class CacheInfo {
    public let name: String
    
    init(name: String) {
        self.name = name
    }
}

public protocol ListCachesResponse {}

public class ListCachesSuccess: ListCachesResponse {
    public let caches: [CacheInfo]
    
    init(caches: [ControlClient__Cache]) {
        self.caches = caches.map({ cache in
            return CacheInfo(name: cache.cacheName)
        })
    }
}

public class ListCachesError: ErrorResponseBase, ListCachesResponse {}
