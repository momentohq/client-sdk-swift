import Foundation

public enum ListPopBackResponse {
    case hit(ListPopBackHit)
    case miss(ListPopBackMiss)
    case error(ListPopBackError)
}

public class ListPopBackHit {
    public let valueString: String
    public let valueData: Data
    
    init(value: Data) {
        self.valueData = value
        self.valueString = String(decoding: value, as: UTF8.self)
    }
}

public class ListPopBackMiss {}

public class ListPopBackError: ErrorResponseBase {}
