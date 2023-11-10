import XCTest
@testable import client_sdk_swift

final class configTests: XCTestCase {
    func testCreateClientWithDefaultConfig() throws {
        let creds = try CredentialProvider.fromEnvironmentVariable(envVariableName: "MOMENTO_API_KEY")
        XCTAssertNotNil(creds)
        
        let client = TopicClient(configuration: Default.latest(), credentialProvider: creds)
        XCTAssertNotNil(client)
    }
    
    func testCreateClientWithCustomTimeout() throws {
        let creds = try CredentialProvider.fromEnvironmentVariable(envVariableName: "MOMENTO_API_KEY")
        XCTAssertNotNil(creds)
        
        let config = TopicClientConfiguration(loggerFactory: DefaultMomentoLoggerFactory(), transportStrategy: StaticTransportStrategy(grpcConfig: StaticGrpcConfiguration(deadline: 60)))
        let client = TopicClient(configuration: config, credentialProvider: creds)
        XCTAssertNotNil(client)
    }
}
