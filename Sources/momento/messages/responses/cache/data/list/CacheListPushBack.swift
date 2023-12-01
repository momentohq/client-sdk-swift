public protocol CacheListPushBackResponse {}

public class CacheListPushBackSuccess: CacheListPushBackResponse {
    public let listLength: UInt32
    
    init(length: UInt32) {
        self.listLength = length
    }
}

public class CacheListPushBackError: ErrorResponseBase, CacheListPushBackResponse {}
