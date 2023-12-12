import Foundation

public enum ListFetchResponse {
    case hit(ListFetchHit)
    case miss(ListFetchMiss)
    case error(ListFetchError)
}

public class ListFetchHit: CustomStringConvertible {
    public let valueListString: [String]
    public let valueListData: [Data]
    
    init(values: [Data]) {
        self.valueListData = values
        self.valueListString = values.map { String(decoding: $0, as: UTF8.self) }
    }
    
    public var description: String {
        return "[\(type(of: self))] List length: \(self.valueListData.count)"
    }
}

public class ListFetchMiss {}

public class ListFetchError: ErrorResponseBase {}
