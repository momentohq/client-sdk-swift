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

internal func validateCacheKey(key: ScalarType) throws {
    switch key {
    case .string(let s):
        try validateString(str: s, errorMessage: "Invalid cache key")
    case .data(let d):
        try validateData(data: d, errorMessage: "Invalid cache key")
    }
}

internal func validateCacheValue(value: ScalarType) throws {
    switch value {
    case .string(let s):
        try validateString(str: s, errorMessage: "Invalid cache value")
    case .data(let d):
        try validateData(data: d, errorMessage: "Invalid cache value")
    }
}

internal func validateTtl(ttl: TimeInterval?) throws {
    if (ttl != nil) {
        if (ttl!.isLessThanOrEqualTo(0) || ttl!.isInfinite) {
            throw InvalidArgumentError(message: "TTL must be a positive number of milliseconds")
        }
    }
}
