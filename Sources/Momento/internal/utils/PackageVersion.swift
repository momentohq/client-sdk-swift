let packageVersion = "0.5.1" // x-release-please-version

internal func constructHeaders(firstRequest: Bool, cacheName: String? = nil) -> Dictionary<String, String> {
    var headers: [String:String] = [:]
    if let nonNilCacheName = cacheName {
        headers["cache"] = nonNilCacheName
    }
    if firstRequest {
        headers["agent"] = "swift:\(packageVersion)"
    }
    return headers
}
