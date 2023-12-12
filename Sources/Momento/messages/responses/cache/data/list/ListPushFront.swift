public enum ListPushFrontResponse {
    case success(ListPushFrontSuccess)
    case error(ListPushFrontError)
}

public class ListPushFrontSuccess: CustomStringConvertible {
    public let listLength: UInt32
    
    init(length: UInt32) {
        self.listLength = length
    }
    
    public var description: String {
        return "[\(type(of: self))] List length after push: \(self.listLength)"
    }
}

public class ListPushFrontError: ErrorResponseBase {}
