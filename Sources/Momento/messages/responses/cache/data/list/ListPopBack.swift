import Foundation

public enum ListPopBackResponse {
    case hit(ListPopBackHit)
    case miss(ListPopBackMiss)
    case error(ListPopBackError)
}

public class ListPopBackHit: CustomStringConvertible {
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

public class ListPopBackMiss {}

public class ListPopBackError: ErrorResponseBase {}
