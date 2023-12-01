import Foundation

public protocol CacheListPopFrontResponse {}

public class CacheListPopFrontHit: CacheListPopFrontResponse {
    public let valueString: String
    public let valueData: Data
    
    init(value: Data) {
        self.valueData = value
        self.valueString = String(decoding: value, as: UTF8.self)
    }
}

public class CacheListPopFrontMiss: CacheListPopFrontResponse {}

public class CacheListPopFrontError: ErrorResponseBase, CacheListPopFrontResponse {}


