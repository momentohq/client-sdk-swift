import Foundation

public protocol CacheListLengthResponse {}

public class CacheListLengthHit: CacheListLengthResponse {
    public let length: UInt32
    
    init(length: UInt32) {
        self.length = length
    }
}

public class CacheListLengthMiss: CacheListLengthResponse {}

public class CacheListLengthError: ErrorResponseBase, CacheListLengthResponse {}

