public protocol CacheListRetainResponse {}

public class CacheListRetainSuccess: CacheListRetainResponse {}

public class CacheListRetainError: ErrorResponseBase, CacheListRetainResponse {}


