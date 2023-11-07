enum CredentialProviderError: Error {
    case emptyAuthToken
}

public protocol CredentialProviderProtocol {
    var originalAuthToken: String { get }
    var authToken: String { get }
    var controlEndpoint: String { get }
    var cacheEndpoint: String { get }
}

class CredentialProvider {
    
    static func fromEnvironmentVariable(envVariableName: String) throws -> CredentialProviderProtocol {
        do {
            let provider = try EnvMomentoTokenProvider(authToken: envVariableName)
            return provider
        } catch {
            throw error
        }
    }
    
    static func fromString(authToken: String) throws -> CredentialProviderProtocol {
        do {
            let provider = try StringMomentoTokenProvider(authToken: authToken)
            return provider
        } catch {
            throw error
        }
    }
    
}
