public enum SetResponse {
    case success(SetSuccess)
    case error(SetError)
}

public class SetSuccess {}

public class SetError: ErrorResponseBase {}
