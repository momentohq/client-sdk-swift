import Foundation

enum CredentialProviderError: Error {
    case emptyApiKey(message: String = "API key is an empty string")
    case emptyAuthEnvironmentVariable(
        message: String = "API key environment variable name is an empty string"
    )
    case badToken(message: String = "invalid API key")
    case emptyEndpoint(message: String = "Endpoint is an empty string")
}

/// Specifies the fields that are required for a Momento client to connect to and authenticate with the Momento service.
public protocol CredentialProviderProtocol: Sendable {
    /// API key provided by user, required to authenticate with the Momento service
    var apiKey: String { get }

    /// The host which the Momento client will connect to for Momento control plane operations
    var controlEndpoint: String { get }

    /// The host which the Momento client will connect to for Momento data plane operations
    var cacheEndpoint: String { get }
}

public class CredentialProvider {

    /// Reads and parses a global Momento API key stored as an environment variable.
    public static func fromEnvVarV2(
        apiKeyEnvVar: String, endpointEnvVar: String
    ) throws
        -> CredentialProviderProtocol
    {
        return try EnvVarV2TokenProvider(
            apiKeyEnvVar: apiKeyEnvVar, endpointEnvVar: endpointEnvVar)
    }

    /// Reads and parses a global Momento API key stored as a string
    public static func fromApiKeyV2(apiKey: String, endpoint: String) throws
        -> CredentialProviderProtocol
    {
        return try ApiKeyV2TokenProvider(apiKey: apiKey, endpoint: endpoint)
    }

    /// Reads and parses a Momento disposable token stored as a string
    public static func fromDisposableToken(token: String) throws -> CredentialProviderProtocol {
        return try DisposableTokenProvider(token: token)
    }

    /// Reads and parses a Momento API key stored as an environment variable.
    @available(*, deprecated, message: "This function is deprecated, use fromEnvVarV2() instead")
    public static func fromEnvironmentVariable(envVariableName: String) throws
        -> CredentialProviderProtocol
    {
        return try EnvMomentoTokenProvider(envVarName: envVariableName)
    }

    /// Reads and parses a Momento API key stored as a string
    @available(
        *, deprecated,
        message: "This function is deprecated, use fromApiKeyV2() or fromDisposableToken instead"
    )
    public static func fromString(apiKey: String) throws -> CredentialProviderProtocol {
        return try StringMomentoTokenProvider(apiKey: apiKey)
    }

    internal static func parseApiKey(apiKey: String) throws -> (
        cacheEndpoint: String, controlEnpoint: String, apiKey: String
    ) {
        if CredentialProvider.isBase64(apiKey: apiKey) {
            return try CredentialProvider.parseV1Token(apiKey: apiKey)
        } else {
            if CredentialProvider.isV2ApiKey(apiKey: apiKey) {
                throw CredentialProviderError.badToken(
                    message:
                        "Received a v2 API key. Are you using the correct key? Or did you mean to use `fromApiKeyV2()` or `fromEnvVarV2()` instead?"
                )
            }
            return try CredentialProvider.parseJwtToken(apiKey: apiKey)
        }
    }

    internal static func isBase64(apiKey: String) -> Bool {
        return Data(base64Encoded: apiKey) != nil
    }

    internal static func isV2ApiKey(apiKey: String) -> Bool {
        if CredentialProvider.isBase64(apiKey: apiKey) {
            return false
        }
        do {
            let payload = try CredentialProvider.decodeJwt(jwtToken: apiKey)
            return payload["t"] != nil && (payload["t"] as! String) == "g"
        } catch {
            return false
        }
    }

    private static func parseJwtToken(apiKey: String) throws -> (
        cacheEndpoint: String, controlEnpoint: String, apiKey: String
    ) {
        do {
            let payload = try CredentialProvider.decodeJwt(jwtToken: apiKey)
            return (payload["c"] as! String, payload["cp"] as! String, apiKey)
        } catch {
            throw error
        }
    }

    private static func parseV1Token(apiKey: String) throws -> (
        cacheEndpoint: String, controlEnpoint: String, apiKey: String
    ) {
        guard let decoded = Data(base64Encoded: apiKey) else {
            throw CredentialProviderError.badToken()
        }
        do {
            let json = try JSONSerialization.jsonObject(with: decoded, options: [])
            guard let payload = json as? [String: Any] else {
                throw CredentialProviderError.badToken()
            }
            let endpoint = payload["endpoint"] as! String
            return ("cache.\(endpoint)", "control.\(endpoint)", payload["api_key"] as! String)
        } catch {
            throw CredentialProviderError.badToken()
        }
    }

    // adapted from https://stackoverflow.com/questions/40915607/how-can-i-decode-jwt-json-web-token-token-in-swift
    private static func decodeJwt(jwtToken jwt: String) throws -> [String: Any] {
        enum DecodeErrors: Error {
            case badToken
            case other
        }

        func base64Decode(_ base64: String) throws -> Data {
            let base64 =
                base64
                .replacingOccurrences(of: "-", with: "+")
                .replacingOccurrences(of: "_", with: "/")
            let padded = base64.padding(
                toLength: ((base64.count + 3) / 4) * 4, withPad: "=", startingAt: 0)
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
                    throw CredentialProviderError.badToken()
                }
                return payload
            } catch {
                throw CredentialProviderError.badToken()
            }
        }

        let segments = jwt.components(separatedBy: ".")
        if segments.count != 3 {
            throw CredentialProviderError.badToken()
        }
        return try decodeJWTPart(segments[1])
    }
}

public struct ApiKeyV2TokenProvider: CredentialProviderProtocol {
    public let apiKey: String
    public let controlEndpoint: String
    public let cacheEndpoint: String

    init(apiKey: String, endpoint: String) throws {
        if endpoint.isEmpty {
            throw CredentialProviderError.emptyEndpoint(
                message: "Endpoint is an empty string")
        }
        if apiKey.isEmpty {
            throw CredentialProviderError.emptyApiKey()
        }
        if !CredentialProvider.isV2ApiKey(apiKey: apiKey) {
            throw CredentialProviderError.badToken(
                message:
                    "Received an invalid v2 API key. Are you using the correct key? Or did you mean to use `fromString()` with a legacy key instead?"
            )
        }

        self.apiKey = apiKey
        self.controlEndpoint = "control.\(endpoint)"
        self.cacheEndpoint = "cache.\(endpoint)"
    }
}

public struct EnvVarV2TokenProvider: CredentialProviderProtocol {
    public let apiKey: String
    public let controlEndpoint: String
    public let cacheEndpoint: String

    init(apiKeyEnvVar: String, endpointEnvVar: String) throws {
        if endpointEnvVar.isEmpty {
            throw CredentialProviderError.emptyAuthEnvironmentVariable(
                message:
                    "Could not find environment variable \(endpointEnvVar) or the variable was an empty string"
            )
        }
        let endpointVar = ProcessInfo.processInfo.environment[endpointEnvVar]
        if endpointVar?.isEmpty ?? true {
            throw CredentialProviderError.emptyEndpoint()
        }
        let endpoint = endpointVar!

        if apiKeyEnvVar.isEmpty {
            throw CredentialProviderError.emptyAuthEnvironmentVariable(
                message:
                    "Could not find environment variable \(apiKeyEnvVar) or the variable was an empty string"
            )
        }
        let apiKeyVar = ProcessInfo.processInfo.environment[apiKeyEnvVar]
        if apiKeyVar?.isEmpty ?? true {
            throw CredentialProviderError.emptyApiKey()
        }
        self.apiKey = apiKeyVar!

        if !CredentialProvider.isV2ApiKey(apiKey: self.apiKey) {
            throw CredentialProviderError.badToken(
                message:
                    "Received an invalid v2 API key. Are you using the correct key? Or did you mean to use `fromEnvironmentVariable()` with a legacy key instead?"
            )
        }

        self.controlEndpoint = "control.\(endpoint)"
        self.cacheEndpoint = "cache.\(endpoint)"
    }
}

public struct DisposableTokenProvider: CredentialProviderProtocol {
    public let apiKey: String
    public let controlEndpoint: String
    public let cacheEndpoint: String

    init(token: String = "") throws {
        if token.isEmpty {
            throw CredentialProviderError.emptyApiKey()
        }
        let (_cacheEndpoint, _controlEndpoint, _apiKey) = try CredentialProvider.parseApiKey(
            apiKey: token)
        self.controlEndpoint = _controlEndpoint
        self.cacheEndpoint = _cacheEndpoint
        self.apiKey = _apiKey
    }
}

@available(
    *, deprecated,
    message: "This struct is deprecated, use fromApiKeyV2() or ApiKeyV2TokenProvider instead"
)
public struct StringMomentoTokenProvider: CredentialProviderProtocol {
    public let apiKey: String
    public let controlEndpoint: String
    public let cacheEndpoint: String

    init(apiKey: String = "", controlEndpoint: String? = nil, cacheEndpoint: String? = nil) throws {
        if apiKey.isEmpty {
            throw CredentialProviderError.emptyApiKey()
        }
        let (_cacheEndpoint, _controlEndpoint, _apiKey) = try CredentialProvider.parseApiKey(
            apiKey: apiKey)
        self.controlEndpoint = controlEndpoint ?? _controlEndpoint
        self.cacheEndpoint = cacheEndpoint ?? _cacheEndpoint
        self.apiKey = _apiKey
    }
}

@available(
    *, deprecated,
    message: "This struct is deprecated, use fromEnvVarV2() or EnvVarV2TokenProvider instead"
)
public struct EnvMomentoTokenProvider: CredentialProviderProtocol {
    public let apiKey: String
    public let controlEndpoint: String
    public let cacheEndpoint: String

    init(envVarName: String = "", controlEndpoint: String? = nil, cacheEndpoint: String? = nil)
        throws
    {
        if envVarName.isEmpty {
            throw CredentialProviderError.emptyAuthEnvironmentVariable(
                message:
                    "Could not find environment variable \(envVarName) or the variable was an empty string"
            )
        }
        let apiKey = ProcessInfo.processInfo.environment[envVarName]
        if apiKey?.isEmpty ?? true {
            throw CredentialProviderError.emptyApiKey()
        }
        let (_cacheEndpoint, _controlEndpoint, _apiKey) = try CredentialProvider.parseApiKey(
            apiKey: apiKey!)
        self.controlEndpoint = controlEndpoint ?? _controlEndpoint
        self.cacheEndpoint = cacheEndpoint ?? _cacheEndpoint
        self.apiKey = _apiKey
    }
}
