import Foundation

public enum ListFetchResponse {
    case hit(ListFetchHit)
    case miss(ListFetchMiss)
    case error(ListFetchError)
}

public class ListFetchHit {
    public let valueListString: [String]
    public let valueListData: [Data]
    
    init(values: [Data]) {
        self.valueListData = values
        self.valueListString = values.map { String(decoding: $0, as: UTF8.self) }
    }
}

public class ListFetchMiss {}

public class ListFetchError: ErrorResponseBase {}
