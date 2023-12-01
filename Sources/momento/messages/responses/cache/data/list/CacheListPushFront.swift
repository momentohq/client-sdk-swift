public protocol CacheListPushFrontResponse {}

public class CacheListPushFrontSuccess: CacheListPushFrontResponse {
    public let listLength: UInt32
    
    init(length: UInt32) {
        self.listLength = length
    }
}

public class CacheListPushFrontError: ErrorResponseBase, CacheListPushFrontResponse {}

