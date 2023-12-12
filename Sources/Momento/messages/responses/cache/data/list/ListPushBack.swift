public enum ListPushBackResponse {
    case success(ListPushBackSuccess)
    case error(ListPushBackError)
}

public class ListPushBackSuccess {
    public let listLength: UInt32
    
    init(length: UInt32) {
        self.listLength = length
    }
}

public class ListPushBackError: ErrorResponseBase {}
