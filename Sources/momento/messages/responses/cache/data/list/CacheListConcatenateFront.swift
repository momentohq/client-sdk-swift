public protocol CacheListConcatenateFrontResponse {}

public class CacheListConcatenateFrontSuccess: CacheListConcatenateFrontResponse {}

public class CacheListConcatenateFrontError: ErrorResponseBase, CacheListConcatenateFrontResponse {}
