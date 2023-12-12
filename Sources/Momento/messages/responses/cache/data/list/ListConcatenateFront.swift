public enum ListConcatenateFrontResponse {
    case success(ListConcatenateFrontSuccess)
    case error(ListConcatenateFrontError)
}

public class ListConcatenateFrontSuccess {
    public let listLength: UInt32
    
    init(length: UInt32) {
        self.listLength = length
    }
}

public class ListConcatenateFrontError: ErrorResponseBase {}
