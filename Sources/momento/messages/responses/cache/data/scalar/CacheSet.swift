public protocol CacheSetResponse {}

public class CacheSetSuccess: CacheSetResponse {}

public class CacheSetError: ErrorResponseBase, CacheSetResponse {}
