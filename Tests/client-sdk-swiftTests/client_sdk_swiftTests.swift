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
        let client = TopicClient()
        
        let pubResp = await client.publish()
        XCTAssertEqual(pubResp, "publishing")
        
        let subResp = await client.subscribe()
        XCTAssertEqual(subResp, "subscribing")
    }
    
    func testCredentialProvider() throws {
        var smp = try StringMomentoTokenProvider(authToken: "")
        XCTAssertEqual(smp?.getAuthToken(), "letmein")
    }
    
}
