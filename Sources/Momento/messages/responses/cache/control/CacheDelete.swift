public protocol CacheDeleteResponse {}

public class CacheDeleteSuccess: CacheDeleteResponse {}

public class CacheDeleteError: ErrorResponseBase, CacheDeleteResponse {}
