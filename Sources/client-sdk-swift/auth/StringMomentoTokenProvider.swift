class StringMomentoTokenProvider : CredentialProviderProtocol {
    let originalAuthToken: String
    let authToken: String
    let controlEndpoint: String
    let cacheEndpoint: String

    init(authToken: String = "", controlEndpoint: String? = nil, cacheEndpoint: String? = nil) throws {
        if authToken.isEmpty {
            throw CredentialProviderError.emptyAuthToken
        }
        self.originalAuthToken = authToken
        self.authToken = "computed from \(originalAuthToken)"
        self.controlEndpoint = "ctrl"
        self.cacheEndpoint = "cache"
    }
}
