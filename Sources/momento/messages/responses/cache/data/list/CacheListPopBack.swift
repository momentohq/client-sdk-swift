import Foundation

public protocol CacheListPopBackResponse {}

public class CacheListPopBackHit: CacheListPopBackResponse {
    public let valueString: String
    public let valueData: Data
    
    init(value: Data) {
        self.valueData = value
        self.valueString = String(decoding: value, as: UTF8.self)
    }
}

public class CacheListPopBackMiss: CacheListPopBackResponse {}

public class CacheListPopBackError: ErrorResponseBase, CacheListPopBackResponse {}

