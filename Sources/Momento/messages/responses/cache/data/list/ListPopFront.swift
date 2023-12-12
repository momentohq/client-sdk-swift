import Foundation

public enum ListPopFrontResponse {
    case hit(ListPopFrontHit)
    case miss(ListPopFrontMiss)
    case error(ListPopFrontError)
}

public class ListPopFrontHit: CustomStringConvertible {
    public let valueString: String
    public let valueData: Data
    
    init(value: Data) {
        self.valueData = value
        self.valueString = String(decoding: value, as: UTF8.self)
    }
    
    public var description: String {
        return "[\(type(of: self))] Popped value: \(self.valueString)"
    }
}

public class ListPopFrontMiss {}

public class ListPopFrontError: ErrorResponseBase {}
