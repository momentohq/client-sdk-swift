public enum ListConcatenateBackResponse {
    case success(ListConcatenateBackSuccess)
    case error(ListConcatenateBackError)
}

public class ListConcatenateBackSuccess {
    public let listLength: UInt32

    init(length: UInt32) {
        self.listLength = length
    }
}

public class ListConcatenateBackError: ErrorResponseBase {}
