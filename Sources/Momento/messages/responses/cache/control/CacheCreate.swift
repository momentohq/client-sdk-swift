public protocol CacheCreateResponse {}

public class CacheCreateSuccess: CacheCreateResponse {}

public class CacheCreateCacheAlreadyExists: CacheCreateResponse {}

public class CacheCreateError: ErrorResponseBase, CacheCreateResponse {}
