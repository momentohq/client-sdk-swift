public enum DeleteResponse {
    case success(DeleteSuccess)
    case error(DeleteError)
}

public class DeleteSuccess {}

public class DeleteError: ErrorResponseBase {}
