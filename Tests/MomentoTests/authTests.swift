import XCTest

@testable import Momento

// All of the below are fake mock data and are unusable to access Momento services
let testLegacyToken =
    "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiJ1c2VyQHRlc3QuY29tIiwiY3AiOiJjb250cm9sLnRlc3QuY29tIiwiYyI6ImNhY2hlLnRlc3QuY29tIn0.c0Z8Ipetl6raCNHSHs7Mpq3qtWkFy4aLvGhIFR4CoR0OnBdGbdjN-4E58bAabrSGhRA8-B2PHzgDd4JF4clAzg"
let testV1Token =
    "eyJhcGlfa2V5IjogImV5SjBlWEFpT2lKS1YxUWlMQ0poYkdjaU9pSklVekkxTmlKOS5leUpwYzNNaU9pSlBibXhwYm1VZ1NsZFVJRUoxYVd4a1pYSWlMQ0pwWVhRaU9qRTJOemd6TURVNE1USXNJbVY0Y0NJNk5EZzJOVFV4TlRReE1pd2lZWFZrSWpvaUlpd2ljM1ZpSWpvaWFuSnZZMnRsZEVCbGVHRnRjR3hsTG1OdmJTSjkuOEl5OHE4NExzci1EM1lDb19IUDRkLXhqSGRUOFVDSXV2QVljeGhGTXl6OCIsICJlbmRwb2ludCI6ICJ0ZXN0Lm1vbWVudG9ocS5jb20ifQ=="
let testLegacyControlEndpoint = "control.test.com"
let testLegacyCacheEndpoint = "cache.test.com"
let testV1ControlEndpoint = "control.test.momentohq.com"
let testV1CacheEndpoint = "cache.test.momentohq.com"
let testV2ApiKey =
    "eyJhbGciOiJIUzUxMiIsInR5cCI6IkpXVCJ9.eyJ0IjoiZyIsImp0aSI6InNvbWUtaWQifQ.GMr9nA6HE0ttB6llXct_2Sg5-fOKGFbJCdACZFgNbN1fhT6OPg_hVc8ThGzBrWC_RlsBpLA1nzqK3SOJDXYxAw"
let v2ApiKeyEnvVar = "MOMENTO_API_KEY"
let endpointEnvVar = "MOMENTO_ENDPOINT"

final class authTests: XCTestCase {
    override class func setUp() {
        setenv("MOMENTO_AUTH_TOKEN_JWT", testLegacyToken, 1)
        setenv("MOMENTO_AUTH_TOKEN_V1", testV1Token, 1)
        setenv(v2ApiKeyEnvVar, testV2ApiKey, 1)
        setenv(endpointEnvVar, "testEndpoint", 1)
    }

    func testStringCredentialProviderJwt() throws {
        let credentialProvider = try StringMomentoTokenProvider(apiKey: testLegacyToken)
        XCTAssertEqual(credentialProvider.controlEndpoint, testLegacyControlEndpoint)
        XCTAssertEqual(credentialProvider.cacheEndpoint, testLegacyCacheEndpoint)
    }

    func testEnvCredentialProviderJwt() throws {
        let credentialProvider = try EnvMomentoTokenProvider(envVarName: "MOMENTO_AUTH_TOKEN_JWT")
        XCTAssertEqual(credentialProvider.controlEndpoint, testLegacyControlEndpoint)
        XCTAssertEqual(credentialProvider.cacheEndpoint, testLegacyCacheEndpoint)
    }

    func testStringCredentialProviderV1() throws {
        let credentialProvider = try StringMomentoTokenProvider(apiKey: testV1Token)
        XCTAssertEqual(credentialProvider.controlEndpoint, testV1ControlEndpoint)
        XCTAssertEqual(credentialProvider.cacheEndpoint, testV1CacheEndpoint)
    }

    func testStringCredentialProviderV1BadKey() throws {
        // strip off a couple characters from the token
        let truncatedV1Token = String(
            testV1Token[
                testV1Token
                    .startIndex...testV1Token.index(
                        testV1Token.startIndex, offsetBy: testV1Token.count - 2)
            ])
        do {
            let _ = try CredentialProvider.fromString(apiKey: truncatedV1Token)
        } catch CredentialProviderError.badToken {
            XCTAssertTrue(true)
            return
        } catch {
            XCTFail("didn't get expected CredentialProviderError.badToken error")
        }
        XCTFail("didn't get expected CredentialProviderError.badToken error")
    }

    func testEnvCredentialProviderV1() throws {
        let credentialProvider = try EnvMomentoTokenProvider(envVarName: "MOMENTO_AUTH_TOKEN_V1")
        XCTAssertEqual(credentialProvider.controlEndpoint, testV1ControlEndpoint)
        XCTAssertEqual(credentialProvider.cacheEndpoint, testV1CacheEndpoint)
    }

    func testStaticStringCredentialProviderJwt() throws {
        let credentialProvider = try CredentialProvider.fromString(apiKey: testLegacyToken)
        XCTAssertEqual(credentialProvider.controlEndpoint, testLegacyControlEndpoint)
        XCTAssertEqual(credentialProvider.cacheEndpoint, testLegacyCacheEndpoint)
    }

    func testStaticStringCredentialProviderV1() throws {
        let credentialProvider = try CredentialProvider.fromString(apiKey: testV1Token)
        XCTAssertEqual(credentialProvider.controlEndpoint, testV1ControlEndpoint)
        XCTAssertEqual(credentialProvider.cacheEndpoint, testV1CacheEndpoint)
    }

    func testStaticEnvCredentialProviderJwt() throws {
        let credentialProvider = try CredentialProvider.fromEnvironmentVariable(
            envVariableName: "MOMENTO_AUTH_TOKEN_JWT")
        XCTAssertEqual(credentialProvider.controlEndpoint, testLegacyControlEndpoint)
        XCTAssertEqual(credentialProvider.cacheEndpoint, testLegacyCacheEndpoint)
    }

    func testStaticEnvCredentialProviderV1() throws {
        let credentialProvider = try CredentialProvider.fromEnvironmentVariable(
            envVariableName: "MOMENTO_AUTH_TOKEN_V1")
        XCTAssertEqual(credentialProvider.controlEndpoint, testV1ControlEndpoint)
        XCTAssertEqual(credentialProvider.cacheEndpoint, testV1CacheEndpoint)
    }

    func testStringEndpointOverrides() throws {
        let credentialProvider = try StringMomentoTokenProvider(
            apiKey: testLegacyToken, controlEndpoint: "ctrl", cacheEndpoint: "cache")
        XCTAssertEqual(credentialProvider.cacheEndpoint, "cache")
        XCTAssertEqual(credentialProvider.controlEndpoint, "ctrl")
    }

    func testEnvEndpointOverrides() throws {
        let credentialProvider = try EnvMomentoTokenProvider(
            envVarName: "MOMENTO_AUTH_TOKEN_JWT", controlEndpoint: "ctrl", cacheEndpoint: "cache")
        XCTAssertEqual(credentialProvider.cacheEndpoint, "cache")
        XCTAssertEqual(credentialProvider.controlEndpoint, "ctrl")
    }

    func testEmptyToken() throws {
        do {
            let _ = try CredentialProvider.fromString(apiKey: "")
        } catch CredentialProviderError.emptyApiKey {
            XCTAssert(true)
            return
        } catch {
            XCTFail("didn't get expected CredentialProviderError.emptyapiKey error")
        }
        XCTFail("didn't get expected CredentialProviderError.emptyapiKey error")
    }

    func testBadToken() throws {
        do {
            let _ = try CredentialProvider.fromString(apiKey: "this.isaninvalidtoken.yo")
        } catch CredentialProviderError.badToken {
            XCTAssert(true)
            return
        } catch {
            XCTFail("didn't get expected CredentialProviderError.badToken error")
        }
        XCTFail("didn't get expected CredentialProviderError.badToken error")
    }

    func testFromStringV2ApiKey() throws {
        do {
            let _ = try CredentialProvider.fromString(apiKey: testV2ApiKey)
        } catch CredentialProviderError.badToken {
            XCTAssert(true)
            return
        } catch {
            XCTFail("didn't get expected CredentialProviderError.badToken error: \(error)")
        }
        XCTFail("didn't get expected CredentialProviderError.badToken error")
    }

    func testFromEnvironmentVariableV2ApiKey() throws {
        do {
            let _ = try CredentialProvider.fromEnvironmentVariable(
                envVariableName: v2ApiKeyEnvVar)
        } catch CredentialProviderError.badToken {
            XCTAssert(true)
            return
        } catch {
            XCTFail("didn't get expected CredentialProviderError.badToken error: \(error)")
        }
        XCTFail("didn't get expected CredentialProviderError.badToken error")
    }

    func testFromApiKeyV2() throws {
        let credentialProvider = try CredentialProvider.fromApiKeyV2(
            apiKey: testV2ApiKey,
            endpoint: "testEndpoint"
        )
        XCTAssertEqual(credentialProvider.controlEndpoint, "control.testEndpoint")
        XCTAssertEqual(credentialProvider.cacheEndpoint, "cache.testEndpoint")
        XCTAssertEqual(credentialProvider.apiKey, testV2ApiKey)
    }

    func testfromEnvironmentVariablesV2_DefaultEnvVars() throws {
        let credentialProvider = try CredentialProvider.fromEnvironmentVariablesV2()
        XCTAssertEqual(credentialProvider.controlEndpoint, "control.testEndpoint")
        XCTAssertEqual(credentialProvider.cacheEndpoint, "cache.testEndpoint")
        XCTAssertEqual(credentialProvider.apiKey, testV2ApiKey)
    }

    func testfromEnvironmentVariablesV2_AlternateEnvVars() throws {
        setenv("MOMENTO_ALTERNATE_API_KEY", testV2ApiKey, 1)
        setenv("MOMENTO_ALTERNATE_ENDPOINT", "testEndpoint", 1)
        let credentialProvider = try CredentialProvider.fromEnvironmentVariablesV2(
            apiKeyEnvVar: "MOMENTO_ALTERNATE_API_KEY",
            endpointEnvVar: "MOMENTO_ALTERNATE_ENDPOINT"
        )
        XCTAssertEqual(credentialProvider.controlEndpoint, "control.testEndpoint")
        XCTAssertEqual(credentialProvider.cacheEndpoint, "cache.testEndpoint")
        XCTAssertEqual(credentialProvider.apiKey, testV2ApiKey)
    }

    func testFromApiKeyV2EmptyKey() throws {
        do {
            let _ = try CredentialProvider.fromApiKeyV2(
                apiKey: "",
                endpoint: "testEndpoint"
            )
        } catch CredentialProviderError.emptyApiKey {
            XCTAssert(true)
            return
        } catch {
            XCTFail("didn't get expected CredentialProviderError.emptyapiKey error")
        }
        XCTFail("didn't get expected CredentialProviderError.emptyapiKey error")
    }

    func testFromApiKeyV2EmptyEndpoint() throws {
        do {
            let _ = try CredentialProvider.fromApiKeyV2(
                apiKey: testV2ApiKey,
                endpoint: ""
            )
        } catch CredentialProviderError.emptyEndpoint {
            XCTAssert(true)
            return
        } catch {
            XCTFail("didn't get expected CredentialProviderError.emptyEndpoint error")
        }
        XCTFail("didn't get expected CredentialProviderError.emptyEndpoint error")
    }

    func testFromApiKeyV2GivenV1ApiKey() throws {
        do {
            let _ = try CredentialProvider.fromApiKeyV2(
                apiKey: testV1Token,
                endpoint: "testEndpoint"
            )
        } catch CredentialProviderError.badToken {
            XCTAssert(true)
            return
        } catch {
            XCTFail("didn't get expected CredentialProviderError.badToken error: \(error)")
        }
        XCTFail("didn't get expected CredentialProviderError.badToken error")
    }

    func testFromApiKeyV2GivenPreV1ApiKey() throws {
        do {
            let _ = try CredentialProvider.fromApiKeyV2(
                apiKey: testLegacyToken,
                endpoint: "testEndpoint"
            )
        } catch CredentialProviderError.badToken {
            XCTAssert(true)
            return
        } catch {
            XCTFail("didn't get expected CredentialProviderError.badToken error: \(error)")
        }
        XCTFail("didn't get expected CredentialProviderError.badToken error")
    }

    func testfromEnvironmentVariablesV2EmptyKey() throws {
        setenv("MOMENTO_API_KEY_EMPTY", "", 1)
        do {
            let _ = try CredentialProvider.fromEnvironmentVariablesV2(
                apiKeyEnvVar: "MOMENTO_API_KEY_EMPTY",
            )
        } catch CredentialProviderError.emptyApiKey {
            XCTAssert(true)
            return
        } catch {
            XCTFail(
                "didn't get expected CredentialProviderError.emptyApiKey error: \(error)"
            )
        }
        XCTFail("didn't get expected CredentialProviderError.emptyApiKey error")
    }

    func testV2KeyFromEmptyEnvironmentVariable() throws {
        do {
            let _ = try CredentialProvider.fromEnvironmentVariablesV2(
                apiKeyEnvVar: "",
            )
        } catch CredentialProviderError.emptyAuthEnvironmentVariable {
            XCTAssert(true)
            return
        } catch {
            XCTFail(
                "didn't get expected CredentialProviderError.emptyAuthEnvironmentVariable error: \(error)"
            )
        }
        XCTFail("didn't get expected CredentialProviderError.emptyAuthEnvironmentVariable error")
    }

    func testfromEnvironmentVariablesV2EmptyEndpoint() throws {
        do {
            let _ = try CredentialProvider.fromEnvironmentVariablesV2(
                endpointEnvVar: ""
            )
        } catch CredentialProviderError.emptyAuthEnvironmentVariable {
            XCTAssert(true)
            return
        } catch {
            XCTFail("didn't get expected CredentialProviderError.emptyEndpoint error: \(error)")
        }
        XCTFail("didn't get expected CredentialProviderError.emptyEndpoint error")
    }

    func testfromEnvironmentVariablesV2EmptyEndpointEnvVar() throws {
        setenv("MOMENTO_ENDPOINT_EMPTY", "", 1)
        do {
            let _ = try CredentialProvider.fromEnvironmentVariablesV2(
                endpointEnvVar: "MOMENTO_ENDPOINT_EMPTY"
            )
        } catch CredentialProviderError.emptyEndpoint {
            XCTAssert(true)
            return
        } catch {
            XCTFail("didn't get expected CredentialProviderError.emptyEndpoint error: \(error)")
        }
        XCTFail("didn't get expected CredentialProviderError.emptyEndpoint error")
    }

    func testfromEnvironmentVariablesV2GivenV1ApiKey() throws {
        do {
            let _ = try CredentialProvider.fromEnvironmentVariablesV2(
                apiKeyEnvVar: "MOMENTO_AUTH_TOKEN_V1",
            )
        } catch CredentialProviderError.badToken {
            XCTAssert(true)
            return
        } catch {
            XCTFail("didn't get expected CredentialProviderError.badToken error: \(error)")
        }
        XCTFail("didn't get expected CredentialProviderError.badToken error")
    }

    func testfromEnvironmentVariablesV2GivenPreV1ApiKey() throws {
        do {
            let _ = try CredentialProvider.fromEnvironmentVariablesV2(
                apiKeyEnvVar: "MOMENTO_AUTH_TOKEN_JWT",
            )
        } catch CredentialProviderError.badToken {
            XCTAssert(true)
            return
        } catch {
            XCTFail("didn't get expected CredentialProviderError.badToken error: \(error)")
        }
        XCTFail("didn't get expected CredentialProviderError.badToken error")
    }

    func testFromDisposableTokenGivenV2ApiKey() throws {
        do {
            let _ = try CredentialProvider.fromDisposableToken(token: testV2ApiKey)
        } catch CredentialProviderError.badToken {
            XCTAssert(true)
            return
        } catch {
            XCTFail("didn't get expected CredentialProviderError.badToken error: \(error)")
        }
        XCTFail("didn't get expected CredentialProviderError.badToken error")
    }

    func testFromDisposableTokenGivenV1ApiKey() throws {
        let credentialProvider = try CredentialProvider.fromDisposableToken(token: testV1Token)
        XCTAssertEqual(credentialProvider.controlEndpoint, testV1ControlEndpoint)
        XCTAssertEqual(credentialProvider.cacheEndpoint, testV1CacheEndpoint)
    }

    func testFromDisposableTokenGivenPreV1ApiKey() throws {
        let credentialProvider = try DisposableTokenProvider(token: testLegacyToken)
        XCTAssertEqual(credentialProvider.controlEndpoint, testLegacyControlEndpoint)
        XCTAssertEqual(credentialProvider.cacheEndpoint, testLegacyCacheEndpoint)
        XCTAssertEqual(credentialProvider.apiKey, testLegacyToken)
    }

    func testDisposableTokenProvider() throws {
        let credentialProvider = try DisposableTokenProvider(token: testV1Token)
        XCTAssertEqual(credentialProvider.controlEndpoint, testV1ControlEndpoint)
        XCTAssertEqual(credentialProvider.cacheEndpoint, testV1CacheEndpoint)
    }
}
