public class CacheInfo {
    public let name: String
    
    init(name: String) {
        self.name = name
    }
}

public protocol CacheListResponse {}

public class CacheListSuccess: CacheListResponse {
    public let caches: [CacheInfo]
    
    init(caches: [ControlClient__Cache]) {
        self.caches = caches.map({ cache in
            return CacheInfo(name: cache.cacheName)
        })
    }
}

public class CacheListError: ErrorResponseBase, CacheListResponse {}
