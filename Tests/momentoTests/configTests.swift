import XCTest
@testable import momento

final class configTests: XCTestCase {

    func testCreateClientWithDefaultConfig() throws {
        let creds = try CredentialProvider.fromEnvironmentVariable(envVariableName: "TEST_AUTH_TOKEN")
        XCTAssertNotNil(creds)
        
        let client = TopicClient(
            configuration: TopicConfigurations.Default.latest(),
            credentialProvider: creds
        )
        XCTAssertNotNil(client)
    }

    func testCreateClientWithCustomTimeout() throws {
        let creds = try CredentialProvider.fromEnvironmentVariable(envVariableName: "TEST_AUTH_TOKEN")
        XCTAssertNotNil(creds)
        
        let config = TopicClientConfiguration(loggerFactory: DefaultMomentoLoggerFactory(), transportStrategy: StaticTransportStrategy(grpcConfig: StaticGrpcConfiguration(deadline: 60)))
        let client = TopicClient(configuration: config, credentialProvider: creds)
        XCTAssertNotNil(client)
    }

    func testTimeoutForImpossibleDeadline() async throws {
        let creds = try CredentialProvider.fromEnvironmentVariable(envVariableName: "TEST_AUTH_TOKEN")
        let configuration = TopicConfigurations.Default.latest().withClientTimeout(timeout: 0.001)
        let client = TopicClient(configuration: configuration, credentialProvider: creds)
        // TODO: use test framework's setup and teardown methods to create and delete caches for use with tests
        let pubResp = await client.publish(
            cacheName: "test-cache",
            topicName: "test-topic",
            value: "test-message"
        )
        XCTAssertTrue(pubResp is TopicPublishError)
        XCTAssertEqual(MomentoErrorCode.TIMEOUT_ERROR, (pubResp as! TopicPublishError).errorCode)
    }
}
