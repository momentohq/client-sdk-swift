public protocol CacheListConcatenateBackResponse {}

public class CacheListConcatenateBackSuccess: CacheListConcatenateBackResponse {
    public let listLength: UInt32
    
    init(length: UInt32) {
        self.listLength = length
    }
}

public class CacheListConcatenateBackError: ErrorResponseBase, CacheListConcatenateBackResponse {}
