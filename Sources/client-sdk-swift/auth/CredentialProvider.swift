import Foundation

class CredentialProvider: Credentialing {
    internal var authToken: String
    internal var controlEndpoint: String?
    internal var cacheEndpoint: String?

    init?(authToken: String = "", controlEndpoint: String? = nil, cacheEndpoint: String? = nil) throws {
        if authToken.isEmpty {
            throw fatalError("API token is empty or null")
        }
        self.authToken = authToken
        self.controlEndpoint = controlEndpoint
        self.cacheEndpoint = cacheEndpoint
    }
    
    func getAuthToken() -> String {
        return authToken
    }
    
    func getControlEndpoint() -> String {
        return controlEndpoint!
    }
    
    func getCacheEndpoint() -> String {
        return cacheEndpoint!
    }
        
    static func fromEnvironmentVariable(envVariableName: String) -> Credentialing {
        var provider: Credentialing? = nil
        do {
            provider = try EnvMomentoTokenProvider(authToken: envVariableName)
        } catch let error as NSError {
            print("Got error \(error)")
        }
        return provider!
    }
    
    static func fromString(authToken: String) -> Credentialing {
        var provider: Credentialing? = nil
        do {
            provider = try StringMomentoTokenProvider(authToken: authToken)
        } catch let error as NSError {
            print("Got error \(error)")
        }
        return provider!
    }
}

