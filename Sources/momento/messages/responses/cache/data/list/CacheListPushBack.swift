public protocol CacheListPushBackResponse {}

public class CacheListPushBackSuccess: CacheListPushBackResponse {}

public class CacheListPushBackError: ErrorResponseBase, CacheListPushBackResponse {}
