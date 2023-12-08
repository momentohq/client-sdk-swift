public protocol DeleteCacheResponse {}

public class DeleteCacheSuccess: DeleteCacheResponse {}

public class DeleteCacheError: ErrorResponseBase, DeleteCacheResponse {}
