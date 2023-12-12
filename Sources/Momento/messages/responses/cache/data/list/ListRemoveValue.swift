public enum ListRemoveValueResponse {
    case success(ListRemoveValueSuccess)
    case error(ListRemoveValueError)
}

public class ListRemoveValueSuccess {}

public class ListRemoveValueError: ErrorResponseBase {}
