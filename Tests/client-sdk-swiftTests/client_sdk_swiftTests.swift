import XCTest
@testable import client_sdk_swift

final class client_sdk_swiftTests: XCTestCase {
    func testExample() throws {
        // XCTest Documentation
        // https://developer.apple.com/documentation/xctest
        
        // Defining Test Cases and Test Methods
        // https://developer.apple.com/documentation/xctest/defining_test_cases_and_test_methods
    }
    
    func testTopicClient() async throws {
        let creds = try CredentialProvider.fromEnvironmentVariable(envVariableName: "MOMENTO_API_KEY")
        XCTAssertNotNil(creds)
        
        let client = TopicClient(configuration: Default.latest(), credentialProvider: creds)
        XCTAssertNotNil(client)
        
        let pubResp = await client.publish()
        XCTAssertTrue(pubResp is PublishSuccess, "Unexpected response: \((pubResp as! PublishError).toString())")
    }    
}
