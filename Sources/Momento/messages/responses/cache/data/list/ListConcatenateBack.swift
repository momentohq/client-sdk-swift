public enum ListConcatenateBackResponse {
    case success(ListConcatenateBackSuccess)
    case error(ListConcatenateBackError)
}

public class ListConcatenateBackSuccess: CustomStringConvertible {
    public let listLength: UInt32

    init(length: UInt32) {
        self.listLength = length
    }
    
    public var description: String {
        return "[\(type(of: self))] List length post-concatenation: \(self.listLength)"
    }
}

public class ListConcatenateBackError: ErrorResponseBase {}
