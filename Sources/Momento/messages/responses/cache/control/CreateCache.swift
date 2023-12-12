public enum CreateCacheResponse {
    case success(CreateCacheSuccess)
    case alreadyExists(CreateCacheAlreadyExists)
    case error(CreateCacheError)
}

public class CreateCacheSuccess {}

public class CreateCacheAlreadyExists {}

public class CreateCacheError: ErrorResponseBase {}
