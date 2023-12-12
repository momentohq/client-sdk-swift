public enum ListPushFrontResponse {
    case success(ListPushFrontSuccess)
    case error(ListPushFrontError)
}

public class ListPushFrontSuccess {
    public let listLength: UInt32
    
    init(length: UInt32) {
        self.listLength = length
    }
}

public class ListPushFrontError: ErrorResponseBase {}
