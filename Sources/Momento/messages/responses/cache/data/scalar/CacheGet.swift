import Foundation

public enum CacheGetResponse {
    case hit(CacheGetHit)
    case miss(CacheGetMiss)
    case error(CacheGetError)
}

public class CacheGetHit: Equatable {
    public let valueString: String
    public let valueData: Data
    
    init(value: Data) {
        self.valueData = value
        self.valueString = String(decoding: value, as: UTF8.self)
    }

    public static func == (lhs: CacheGetHit, rhs: CacheGetHit) -> Bool {
        return lhs.valueData == rhs.valueData
    }
}

public class CacheGetMiss {}

public class CacheGetError: ErrorResponseBase {}
