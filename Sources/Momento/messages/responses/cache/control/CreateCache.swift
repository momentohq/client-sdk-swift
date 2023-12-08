public protocol CreateCacheResponse {}

public class CreateCacheSuccess: CreateCacheResponse {}

public class CreateCacheAlreadyExists: CreateCacheResponse {}

public class CreateCacheError: ErrorResponseBase, CreateCacheResponse {}
