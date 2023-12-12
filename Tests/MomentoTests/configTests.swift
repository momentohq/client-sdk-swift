import XCTest
@testable import Momento

final class configTests: XCTestCase {
    private var integrationTestCacheName: String!
    private var topicClient: TopicClientProtocol!
    private var cacheClient: CacheClientProtocol!
    
    override func setUp() async throws {
        let testSetup = await setUpIntegrationTests()
        self.integrationTestCacheName = testSetup.cacheName
        self.topicClient = testSetup.topicClient
        self.cacheClient = testSetup.cacheClient
    }
    
    override func tearDown() async throws {
        await cleanUpIntegrationTests(
            cacheName: self.integrationTestCacheName,
            cacheClient: self.cacheClient
        )
    }

    func testCreateClientWithDefaultConfig() throws {
        let creds = try CredentialProvider.fromEnvironmentVariable(envVariableName: apiKeyEnvVarName)
        XCTAssertNotNil(creds)
        
        let client = TopicClient(
            configuration: TopicConfigurations.Default.latest(),
            credentialProvider: creds
        )
        XCTAssertNotNil(client)
    }

    func testCreateClientWithCustomTimeout() throws {
        let creds = try CredentialProvider.fromEnvironmentVariable(envVariableName: apiKeyEnvVarName)
        XCTAssertNotNil(creds)
        
        let config = TopicClientConfiguration(
            transportStrategy: StaticTransportStrategy(grpcConfig: StaticGrpcConfiguration(deadline: 60))
        )
        let client = TopicClient(configuration: config, credentialProvider: creds)
        XCTAssertNotNil(client)
    }

    func testTimeoutForImpossibleDeadline() async throws {
        let creds = try CredentialProvider.fromEnvironmentVariable(envVariableName: apiKeyEnvVarName)
        let configuration = TopicConfigurations.Default.latest().withClientTimeout(timeout: 0.001)
        let topicClient = TopicClient(configuration: configuration, credentialProvider: creds)
        
        let pubResp = await topicClient.publish(
            cacheName: self.integrationTestCacheName,
            topicName: generateStringWithUuid(prefix: "test-topic"),
            value: "test-message"
        )
        switch pubResp {
        case .success(let success):
            XCTFail("expected error but got \(success)")
        case .error(let err):
            XCTAssertEqual(MomentoErrorCode.TIMEOUT_ERROR, err.errorCode)
        }
    }
}
