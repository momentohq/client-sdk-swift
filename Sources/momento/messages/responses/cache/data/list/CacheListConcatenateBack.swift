public protocol CacheListConcatenateBackResponse {}

public class CacheListConcatenateBackSuccess: CacheListConcatenateBackResponse {}

public class CacheListConcatenateBackError: ErrorResponseBase, CacheListConcatenateBackResponse {}
