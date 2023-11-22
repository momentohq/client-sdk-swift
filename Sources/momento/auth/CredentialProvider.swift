import Foundation

enum CredentialProviderError: Error {
    case emptyapiKey
    case emptyAuthEnvironmentVariable
    case badToken
}

/// Specifies the fields that are required for a Momento client to connect to and authenticate with the Momento service.
public protocol CredentialProviderProtocol {
    /// API key provided by user, required to authenticate with the Momento service
    var apiKey: String { get }
    
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
    public static func fromString(apiKey: String) throws -> CredentialProviderProtocol {
        do {
            let provider = try StringMomentoTokenProvider(apiKey: apiKey)
            return provider
        } catch {
            throw error
        }
    }

    internal static func parseapiKey(apiKey: String) throws -> (cacheEndpoint: String, controlEnpoint: String, apiKey: String) {
        let isBase64 = Data(base64Encoded: apiKey) != nil
        if isBase64 {
            return try CredentialProvider.parseV1Token(apiKey: apiKey)
        } else {
            return try CredentialProvider.parseJwtToken(apiKey: apiKey)
        }
    }

    private static func parseJwtToken(apiKey: String) throws -> (cacheEndpoint: String, controlEnpoint: String, apiKey: String) {
        do {
            let payload = try CredentialProvider.decodeJwt(jwtToken: apiKey)
            return (payload["c"] as! String, payload["cp"] as! String, apiKey)
        } catch {
            throw error
        }
    }

    private static func parseV1Token(apiKey: String) throws -> (cacheEndpoint: String, controlEnpoint: String, apiKey: String) {
        guard let decoded = Data(base64Encoded: apiKey) else {
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
    public let apiKey: String
    public let controlEndpoint: String
    public let cacheEndpoint: String

    init(apiKey: String = "", controlEndpoint: String? = nil, cacheEndpoint: String? = nil) throws {
        if apiKey.isEmpty {
            throw CredentialProviderError.emptyapiKey
        }
        let (_cacheEndpoint, _controlEndpoint, _apiKey) = try CredentialProvider.parseapiKey(apiKey: apiKey)
        self.controlEndpoint = controlEndpoint ?? _controlEndpoint
        self.cacheEndpoint = cacheEndpoint ?? _cacheEndpoint
        self.apiKey = _apiKey
    }
}

public class EnvMomentoTokenProvider : StringMomentoTokenProvider {
    init(envVarName: String = "", controlEndpoint: String? = nil, cacheEndpoint: String? = nil) throws {
        if envVarName.isEmpty {
            throw CredentialProviderError.emptyAuthEnvironmentVariable
        }
        let apiKey = ProcessInfo.processInfo.environment[envVarName]
        try super.init(apiKey: apiKey ?? "", controlEndpoint: controlEndpoint, cacheEndpoint: cacheEndpoint)
    }
}
