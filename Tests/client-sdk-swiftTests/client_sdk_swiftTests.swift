import XCTest
@testable import client_sdk_swift

final class client_sdk_swiftTests: XCTestCase {
    func testExample() throws {
        // XCTest Documentation
        // https://developer.apple.com/documentation/xctest
        
        // Defining Test Cases and Test Methods
        // https://developer.apple.com/documentation/xctest/defining_test_cases_and_test_methods
    }
    
    func testTopicClientPublishes() async throws {
        let creds = try CredentialProvider.fromEnvironmentVariable(envVariableName: "MOMENTO_API_KEY")
        let client = TopicClient(configuration: Default.latest(), credentialProvider: creds)
        XCTAssertNotNil(client)
        
        let pubResp = try await client.publish(
            cacheName: "test-cache",
            topicName: "test-topic",
            value: "test-message"
        )
        XCTAssertTrue(
            pubResp is TopicPublishSuccess,
            "Unexpected response: \((pubResp as! TopicPublishError).toString())"
        )
    }    
}
