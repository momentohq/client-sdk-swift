import Foundation

public enum GetResponse {
    case hit(GetHit)
    case miss(GetMiss)
    case error(GetError)
}

public class GetHit: Equatable {
    public let valueString: String
    public let valueData: Data
    
    init(value: Data) {
        self.valueData = value
        self.valueString = String(decoding: value, as: UTF8.self)
    }

    public static func == (lhs: GetHit, rhs: GetHit) -> Bool {
        return lhs.valueData == rhs.valueData
    }
}

public class GetMiss {}

public class GetError: ErrorResponseBase {}
