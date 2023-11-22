import Foundation

enum CredentialProviderError: Error {
    case emptyAuthToken
    case emptyAuthEnvironmentVariable
    case badToken
}

/// Specifies the fields that are required for a Momento client to connect to and authenticate with the Momento service.
public protocol CredentialProviderProtocol {
    /// API key provided by user, required to authenticate with the Momento service
    var authToken: String { get }
    
    /// The host which the Momento client will connect to for Momento control plane operations
    var controlEndpoint: String { get }
    
    /// The host which the Momento client will connect to for Momento data plane operations
    var cacheEndpoint: String { get }
}

public class CredentialProvider {
    
    /// Reads and parses a Momento API key stored as an environment variable.
    public static func fromEnvironmentVariable(envVariableName: String) throws -> CredentialProviderProtocol {
        do {
            let provider = try EnvMomentoTokenProvider(envVarName: envVariableName)
            return provider
        } catch {
            throw error
        }
    }
    
    /// Reads and parses a Momento API key stored as a string
    public static func fromString(authToken: String) throws -> CredentialProviderProtocol {
        do {
            let provider = try StringMomentoTokenProvider(authToken: authToken)
            return provider
        } catch {
            throw error
        }
    }

    internal static func parseAuthToken(authToken: String) throws -> (cacheEndpoint: String, controlEnpoint: String, authToken: String) {
        let isBase64 = Data(base64Encoded: authToken) != nil
        if isBase64 {
            return try CredentialProvider.parseV1Token(authToken: authToken)
        } else {
            return try CredentialProvider.parseJwtToken(authToken: authToken)
        }
    }

    private static func parseJwtToken(authToken: String) throws -> (cacheEndpoint: String, controlEnpoint: String, authToken: String) {
        do {
            let payload = try CredentialProvider.decodeJwt(jwtToken: authToken)
            return (payload["c"] as! String, payload["cp"] as! String, authToken)
        } catch {
            throw error
        }
    }

    private static func parseV1Token(authToken: String) throws -> (cacheEndpoint: String, controlEnpoint: String, authToken: String) {
        guard let decoded = Data(base64Encoded: authToken) else {
            throw CredentialProviderError.badToken
        }
        do {
            let json = try JSONSerialization.jsonObject(with: decoded, options: [])
            guard let payload = json as? [String:Any] else {
                throw CredentialProviderError.badToken
            }
            let endpoint = payload["endpoint"] as! String
            return ("cache.\(endpoint)", "control.\(endpoint)", payload["api_key"] as! String)
        } catch {
            throw CredentialProviderError.badToken
        }
    }
    
    // adapted from https://stackoverflow.com/questions/40915607/how-can-i-decode-jwt-json-web-token-token-in-swift
    private static func decodeJwt(jwtToken jwt: String) throws -> [String: Any] {
        enum DecodeErrors: Error {
            case badToken
            case other
        }

        func base64Decode(_ base64: String) throws -> Data {
            let base64 = base64
                .replacingOccurrences(of: "-", with: "+")
                .replacingOccurrences(of: "_", with: "/")
            let padded = base64.padding(toLength: ((base64.count + 3) / 4) * 4, withPad: "=", startingAt: 0)
            guard let decoded = Data(base64Encoded: padded) else {
                throw DecodeErrors.badToken
            }
            return decoded
        }

        func decodeJWTPart(_ value: String) throws -> [String: Any] {
            let bodyData = try base64Decode(value)
            do {
                let json = try JSONSerialization.jsonObject(with: bodyData, options: [])
                guard let payload = json as? [String: Any] else {
                    throw CredentialProviderError.badToken
                }
                return payload
            } catch {
                throw CredentialProviderError.badToken
            }
        }

        let segments = jwt.components(separatedBy: ".")
        return try decodeJWTPart(segments[1])
    }
}

public class StringMomentoTokenProvider : CredentialProviderProtocol {
    public let authToken: String
    public let controlEndpoint: String
    public let cacheEndpoint: String

    init(authToken: String = "", controlEndpoint: String? = nil, cacheEndpoint: String? = nil) throws {
        if authToken.isEmpty {
            throw CredentialProviderError.emptyAuthToken
        }
        let (_cacheEndpoint, _controlEndpoint, _authToken) = try CredentialProvider.parseAuthToken(authToken: authToken)
        self.controlEndpoint = controlEndpoint ?? _controlEndpoint
        self.cacheEndpoint = cacheEndpoint ?? _cacheEndpoint
        self.authToken = _authToken
    }
}

public class EnvMomentoTokenProvider : StringMomentoTokenProvider {
    init(envVarName: String = "", controlEndpoint: String? = nil, cacheEndpoint: String? = nil) throws {
        if envVarName.isEmpty {
            throw CredentialProviderError.emptyAuthEnvironmentVariable
        }
        let authToken = ProcessInfo.processInfo.environment[envVarName]
        try super.init(authToken: authToken ?? "", controlEndpoint: controlEndpoint, cacheEndpoint: cacheEndpoint)
    }
}
