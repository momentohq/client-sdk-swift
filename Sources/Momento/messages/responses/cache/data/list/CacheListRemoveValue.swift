public protocol CacheListRemoveValueResponse {}

public class CacheListRemoveValueSuccess: CacheListRemoveValueResponse {}

public class CacheListRemoveValueError: ErrorResponseBase, CacheListRemoveValueResponse {}


