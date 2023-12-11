public enum ListRetainResponse {
    case success(ListRetainSuccess)
    case error(ListRetainError)
}

public class ListRetainSuccess {}

public class ListRetainError: ErrorResponseBase {}
