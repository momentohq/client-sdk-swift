import XCTest
@testable import client_sdk_swift

final class authTests: XCTestCase {
    func testStringCredentialProviderJwt() throws {
        let token = ProcessInfo.processInfo.environment["MOMENTO_AUTH_TOKEN_JWT"]
        let smp = try StringMomentoTokenProvider(authToken: token!)
        XCTAssertEqual(smp.controlEndpoint, "control.cell-alpha-dev.preprod.a.momentohq.com")
    }
    
    func testEnvCredentialProviderJwt() throws {
        let smp = try EnvMomentoTokenProvider(envVarName: "MOMENTO_AUTH_TOKEN_JWT")
        XCTAssertEqual(smp.controlEndpoint, "control.cell-alpha-dev.preprod.a.momentohq.com")
    }
    
    func testStaticStringCredentialProviderJwt() throws {
        let token = ProcessInfo.processInfo.environment["MOMENTO_AUTH_TOKEN_JWT"]
        let smp = try CredentialProvider.fromString(authToken: token!)
        XCTAssertEqual(smp.controlEndpoint, "control.cell-alpha-dev.preprod.a.momentohq.com")
    }
    
    func testStaticStringCredentialProviderV1() throws {
        let smp = try CredentialProvider.fromEnvironmentVariable(envVariableName: "MOMENTO_AUTH_TOKEN_V1")
        XCTAssertEqual(smp.controlEndpoint, "control.cell-4-us-west-2-1.prod.a.momentohq.com")
    }

    func testStringEndpointOverrides() throws {
        let token = ProcessInfo.processInfo.environment["MOMENTO_AUTH_TOKEN_JWT"]
        let smp = try StringMomentoTokenProvider(authToken: token!, controlEndpoint: "ctrl", cacheEndpoint: "cache")
        XCTAssertEqual(smp.cacheEndpoint, "cache")
        XCTAssertEqual(smp.controlEndpoint, "ctrl")
    }
    
    func testEnvEndpointOverrides() throws {
        let smp = try EnvMomentoTokenProvider(envVarName: "MOMENTO_AUTH_TOKEN_JWT", controlEndpoint: "ctrl", cacheEndpoint: "cache")
        XCTAssertEqual(smp.cacheEndpoint, "cache")
        XCTAssertEqual(smp.controlEndpoint, "ctrl")
    }
    
    func testEmptyAuthToken() throws {
        do {
            let _ = try CredentialProvider.fromString(authToken: "")
        } catch {
            XCTAssertTrue(error is CredentialProviderError)
        }
    }
    
    func testBadAuthToken() throws {
        do {
            let _ = try CredentialProvider.fromString(authToken: "this.isaninvalidtoken.yo")
        } catch {
            XCTAssertTrue(error is CredentialProviderError)
        }
    }
}
