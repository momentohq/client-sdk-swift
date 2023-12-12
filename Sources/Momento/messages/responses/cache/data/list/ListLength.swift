import Foundation

public enum ListLengthResponse {
    case hit(ListLengthHit)
    case miss(ListLengthMiss)
    case error(ListLengthError)
}

public class ListLengthHit: CustomStringConvertible {
    public let length: UInt32
    
    init(length: UInt32) {
        self.length = length
    }
    
    public var description: String {
        return "[\(type(of: self))] List length: \(self.length)"
    }
}

public class ListLengthMiss {}

public class ListLengthError: ErrorResponseBase {}
