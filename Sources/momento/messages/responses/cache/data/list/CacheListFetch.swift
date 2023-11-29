import Foundation

public protocol CacheListFetchResponse {}

public class CacheListFetchHit: CacheListFetchResponse {
    public let valueListString: [String]
    public let valueListData: [Data]
    
    init(values: [Data]) {
        self.valueListData = values
        self.valueListString = values.map { String(decoding: $0, as: UTF8.self) }
    }
}

public class CacheListFetchMiss: CacheListFetchResponse {}

public class CacheListFetchError: ErrorResponseBase, CacheListFetchResponse {}
