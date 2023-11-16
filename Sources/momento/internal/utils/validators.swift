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

internal func validateCacheName(cacheName: String) throws {
    try validateString(str: cacheName, errorMessage: "Invalid cache name")
}

internal func validateTopicName(topicName: String) throws {
    try validateString(str: topicName, errorMessage: "Invalid topic name")
}
