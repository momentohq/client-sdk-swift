import Foundation

extension String {
  var isBlank: Bool {
    return allSatisfy({ $0.isWhitespace })
  }
}

private func validateString(str: String, errorMessage: String) throws {
    if str.isBlank || str.isEmpty {
        throw InvalidArgumentError(message: errorMessage)
    }
}

private func validateData(data: Data, errorMessage: String) throws {
    if data.isEmpty {
        throw InvalidArgumentError(message: errorMessage)
    }
}

internal func validateCacheName(cacheName: String) throws {
    try validateString(str: cacheName, errorMessage: "Invalid cache name")
}

internal func validateTopicName(topicName: String) throws {
    try validateString(str: topicName, errorMessage: "Invalid topic name")
}

internal func validateListName(listName: String) throws {
    try validateString(str: listName, errorMessage: "Invalid list name")
}

internal func validateCacheKey(key: ScalarType) throws {
    switch key {
    case .string(let s):
        try validateString(str: s, errorMessage: "Invalid cache key")
    case .data(let d):
        try validateData(data: d, errorMessage: "Invalid cache key")
    }
}

internal func validateTtl(ttl: TimeInterval?) throws {
    if (ttl != nil) {
        if (ttl!.isLessThanOrEqualTo(0) || ttl!.isInfinite) {
            throw InvalidArgumentError(message: "TTL must be a non-zero positive number")
        }
    }
}

internal func validateTruncateSize(size: Int?) throws {
    if (size != nil && size! < 0) {
        throw InvalidArgumentError(message: "size to truncate to must be a positive number")
    }
}

internal func validateListSliceStartEnd(startIndex: Int?, endIndex: Int?) throws {
    if startIndex == nil || endIndex == nil {
        return
    }
    if startIndex! > 0 && endIndex! < 0 {
        return
    }
    if endIndex! <= startIndex! {
        throw InvalidArgumentError(message: "endIndex (exclusive) must be larger than startIndex (inclusive)")
    }
}
