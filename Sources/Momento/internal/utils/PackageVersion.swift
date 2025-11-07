import Foundation

let packageVersion = "0.8.0" // x-release-please-version
let osVersion = ProcessInfo.processInfo.operatingSystemVersion

internal func constructHeaders(firstRequest: Bool, clientType: String, cacheName: String? = nil) -> Dictionary<String, String> {
    var headers: [String:String] = [:]
    if let nonNilCacheName = cacheName {
        headers["cache"] = nonNilCacheName
    }
    if firstRequest {
        headers["agent"] = "swift:\(clientType):\(packageVersion)"
        headers["runtime-version"] = "\(osVersion.majorVersion).\(osVersion.minorVersion).\(osVersion.patchVersion)"
    }
    return headers
}
