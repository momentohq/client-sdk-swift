import Foundation

public enum ListPopFrontResponse {
    case hit(ListPopFrontHit)
    case miss(ListPopFrontMiss)
    case error(ListPopFrontError)
}

public class ListPopFrontHit {
    public let valueString: String
    public let valueData: Data
    
    init(value: Data) {
        self.valueData = value
        self.valueString = String(decoding: value, as: UTF8.self)
    }
}

public class ListPopFrontMiss {}

public class ListPopFrontError: ErrorResponseBase {}
