public protocol CacheListPushFrontResponse {}

public class CacheListPushFrontSuccess: CacheListPushFrontResponse {}

public class CacheListPushFrontError: ErrorResponseBase, CacheListPushFrontResponse {}

