public protocol DeleteCacheResponse {}

public class CacheDeleteSuccess: DeleteCacheResponse {}

public class CacheDeleteError: ErrorResponseBase, DeleteCacheResponse {}
