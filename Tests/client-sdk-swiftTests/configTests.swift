import XCTest
@testable import client_sdk_swift

final class configTests: XCTestCase {
    func testCreateClientWithDefaultConfig() {
        let client = TopicClient(configuration: Default.latest())
        XCTAssertNotNil(client)
    }
    
    func testCreateClientWithCustomTimeout() {
        let config = TopicClientConfiguration(loggerFactory: DefaultMomentoLoggerFactory(), transportStrategy: StaticTransportStrategy(grpcConfig: StaticGrpcConfiguration(deadline: 60)))
        let client = TopicClient(configuration: config)
        XCTAssertNotNil(client)
    }
}
