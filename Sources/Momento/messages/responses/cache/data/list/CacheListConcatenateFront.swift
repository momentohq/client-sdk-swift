public protocol CacheListConcatenateFrontResponse {}

public class CacheListConcatenateFrontSuccess: CacheListConcatenateFrontResponse {
    public let listLength: UInt32
    
    init(length: UInt32) {
        self.listLength = length
    }
}

public class CacheListConcatenateFrontError: ErrorResponseBase, CacheListConcatenateFrontResponse {}
