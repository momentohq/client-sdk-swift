public enum DeleteCacheResponse {
    case success(DeleteCacheSuccess)
    case error(DeleteCacheError)
}

public class DeleteCacheSuccess {}

public class DeleteCacheError: ErrorResponseBase {}
