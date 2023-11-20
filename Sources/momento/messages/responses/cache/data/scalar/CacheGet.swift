import Foundation

public protocol CacheGetResponse {}

public class CacheGetHit: CacheGetResponse {
    public let valueString: String
    public let valueBytes: Data
    
    init(value: Data) {
        self.valueBytes = value
        self.valueString = String(decoding: value, as: UTF8.self)
    }
}

public class CacheGetMiss: CacheGetResponse {}

public class CacheGetError: ErrorResponseBase, CacheGetResponse {}
