import Foundation

public enum ListLengthResponse {
    case hit(ListLengthHit)
    case miss(ListLengthMiss)
    case error(ListLengthError)
}

public class ListLengthHit {
    public let length: UInt32
    
    init(length: UInt32) {
        self.length = length
    }
}

public class ListLengthMiss {}

public class ListLengthError: ErrorResponseBase {}
