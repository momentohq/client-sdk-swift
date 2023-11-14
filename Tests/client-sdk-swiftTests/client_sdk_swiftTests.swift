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
        
        let invalidCacheNameResp = await client.publish(
            cacheName: "",
            topicName: "test-topic",
            value: "test-message"
        )
        XCTAssertTrue(
            invalidCacheNameResp is client_sdk_swift.TopicPublishError,
            "Unexpected response: \(invalidCacheNameResp)"
        )
        let invalidCacheNameErrorCode = (invalidCacheNameResp as! TopicPublishError).errorCode
        XCTAssertEqual(
            invalidCacheNameErrorCode, MomentoErrorCode.INVALID_ARGUMENT_ERROR,
            "Unexpected error code: \(invalidCacheNameErrorCode)"
        )
        
        let invalidTopicNameResp = await client.publish(
            cacheName: "test-cache",
            topicName: "",
            value: "test-message"
        )
        XCTAssertTrue(
            invalidTopicNameResp is client_sdk_swift.TopicPublishError,
            "Unexpected response: \(invalidTopicNameResp)"
        )
        let invalidTopicNameErrorCode = (invalidTopicNameResp as! TopicPublishError).errorCode
        XCTAssertEqual(
            invalidTopicNameErrorCode, MomentoErrorCode.INVALID_ARGUMENT_ERROR,
            "Unexpected error code: \(invalidTopicNameErrorCode)"
        )
        
        let pubResp = await client.publish(
            cacheName: "test-cache",
            topicName: "test-topic",
            value: "test-message"
        )
        XCTAssertTrue(
            pubResp is TopicPublishSuccess,
            "Unexpected response: \((pubResp as! TopicPublishError).description)"
        )
    }    
    
    func testTopicClientSubscribes() async throws {
        let creds = try CredentialProvider.fromEnvironmentVariable(envVariableName: "MOMENTO_API_KEY")
        let client = TopicClient(configuration: Default.latest(), credentialProvider: creds)
        XCTAssertNotNil(client)
        
        let invalidCacheNameResp = await client.subscribe(
            cacheName: "",
            topicName: "test-topic"
        )
        XCTAssertTrue(
            invalidCacheNameResp is client_sdk_swift.TopicSubscribeError,
            "Unexpected response: \(invalidCacheNameResp)"
        )
        let invalidCacheNameErrorCode = (invalidCacheNameResp as! TopicSubscribeError).errorCode
        XCTAssertEqual(
            invalidCacheNameErrorCode, MomentoErrorCode.INVALID_ARGUMENT_ERROR,
            "Unexpected error code: \(invalidCacheNameErrorCode)"
        )
        
        let invalidTopicNameResp = await client.subscribe(
            cacheName: "test-cache",
            topicName: ""
        )
        XCTAssertTrue(
            invalidTopicNameResp is client_sdk_swift.TopicSubscribeError,
            "Unexpected response: \(invalidTopicNameResp)"
        )
        let invalidTopicNameErrorCode = (invalidTopicNameResp as! TopicSubscribeError).errorCode
        XCTAssertEqual(
            invalidTopicNameErrorCode, MomentoErrorCode.INVALID_ARGUMENT_ERROR,
            "Unexpected error code: \(invalidTopicNameErrorCode)"
        )
        
        let subResp = await client.subscribe(
            cacheName: "test-cache",
            topicName: "test-topic"
        )
        XCTAssertTrue(
            subResp is TopicSubscribeSuccess,
            "Unexpected response: \((subResp as! TopicSubscribeError).description)"
        )
    }
    
    func testTopicClientPublishesAndSubscribes() async throws {
        let creds = try CredentialProvider.fromEnvironmentVariable(envVariableName: "MOMENTO_API_KEY")
        let client = TopicClient(configuration: Default.latest(), credentialProvider: creds)
        XCTAssertNotNil(client)
        
        let subResp = await client.subscribe(
            cacheName: "test-cache",
            topicName: "test-topic"
        )
        XCTAssertTrue(
            subResp is TopicSubscribeSuccess,
            "Unexpected response: \((subResp as! TopicSubscribeError).description)"
        )
        
        let pubResp = await client.publish(
            cacheName: "test-cache",
            topicName: "test-topic",
            value: "publishing and subscribing!"
        )
        XCTAssertTrue(
            pubResp is TopicPublishSuccess,
            "Unexpected response: \((pubResp as! TopicPublishError).description)"
        )
        
        let subscription = (subResp as! TopicSubscribeSuccess)
        for await item in subscription {
            print("Received item: \(item)")
            XCTAssertTrue(
                item is TopicSubscriptionItemText,
                "received subscription item that was not text: \(item)"
            )
            
            let value = (item as! TopicSubscriptionItemText).value
            print("Received value: \(value)")
            XCTAssertEqual(value, "publishing and subscribing!", "unexpected topic subscription item value: \(value)")
            
//            return
        }
    }
}
