public enum ListPushBackResponse {
    case success(ListPushBackSuccess)
    case error(ListPushBackError)
}

public class ListPushBackSuccess: CustomStringConvertible {
    public let listLength: UInt32
    
    init(length: UInt32) {
        self.listLength = length
    }
    
    public var description: String {
        return "[\(type(of: self))] List length after push: \(self.listLength)"
    }
}

public class ListPushBackError: ErrorResponseBase {}
