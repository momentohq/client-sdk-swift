public enum ListConcatenateFrontResponse {
    case success(ListConcatenateFrontSuccess)
    case error(ListConcatenateFrontError)
}

public class ListConcatenateFrontSuccess: CustomStringConvertible {
    public let listLength: UInt32
    
    init(length: UInt32) {
        self.listLength = length
    }
    
    public var description: String {
        return "[\(type(of: self))] List length post-concatenation: \(self.listLength)"
    }
}

public class ListConcatenateFrontError: ErrorResponseBase {}
