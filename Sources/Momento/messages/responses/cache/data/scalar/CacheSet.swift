public enum CacheSetResponse {
    case success(CacheSetSuccess)
    case error(CacheSetError)
}

public class CacheSetSuccess {}

public class CacheSetError: ErrorResponseBase {}
