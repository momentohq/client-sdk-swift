import XCTest
@testable import momento

final class client_sdk_swiftTests: XCTestCase {
    func testExample() throws {
        // XCTest Documentation
        // https://developer.apple.com/documentation/xctest
        
        // Defining Test Cases and Test Methods
        // https://developer.apple.com/documentation/xctest/defining_test_cases_and_test_methods
    }
    
    func testTopicClientPublishes() async throws {
        let creds = try CredentialProvider.fromEnvironmentVariable(envVariableName: "MOMENTO_API_KEY")
        let client = TopicClient(
            configuration: TopicConfigurations.Default.latest(),
            credentialProvider: creds
        )
        XCTAssertNotNil(client)
        
        let invalidCacheNameResp = await client.publish(
            cacheName: "",
            topicName: "test-topic",
            value: "test-message"
        )
        XCTAssertTrue(
            invalidCacheNameResp is TopicPublishError,
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
            invalidTopicNameResp is TopicPublishError,
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
        let client = TopicClient(configuration: TopicConfigurations.Default.latest(), credentialProvider: creds)
        XCTAssertNotNil(client)
        
        let invalidCacheNameResp = await client.subscribe(
            cacheName: "",
            topicName: "test-topic"
        )
        XCTAssertTrue(
            invalidCacheNameResp is TopicSubscribeError,
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
            invalidTopicNameResp is TopicSubscribeError,
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
        let client = TopicClient(configuration: TopicConfigurations.Default.latest(), credentialProvider: creds)
        XCTAssertNotNil(client)
        
        let subResp = await client.subscribe(
            cacheName: "test-cache",
            topicName: "test-topic"
        )
        XCTAssertTrue(
            subResp is TopicSubscribeSuccess,
            "Unexpected response: \((subResp as! TopicSubscribeError).description)"
        )
        
        try await Task.sleep(nanoseconds: 1000)
        let pubResp = await client.publish(
            cacheName: "test-cache",
            topicName: "test-topic",
            value: "publishing and subscribing!"
        )
        XCTAssertTrue(
            pubResp is TopicPublishSuccess,
            "Unexpected response: \((pubResp as! TopicPublishError).description)"
        )
        
        let subscription = (subResp as! TopicSubscribeSuccess).subscription
        for try await item in subscription {
            print("Received item: \(String(describing: item))")
            XCTAssertTrue(
                item is TopicSubscriptionItemText,
                "received subscription item that was not text: \(String(describing: item))"
            )
            
            let value = (item as! TopicSubscriptionItemText).value
            print("Received value: \(value)")
            XCTAssertEqual(value, "publishing and subscribing!", "unexpected topic subscription item value: \(value)")
            break
        }
    }

    func testTopicClientPublishesAndSubscribesBinary() async throws {
        let creds = try CredentialProvider.fromEnvironmentVariable(envVariableName: "MOMENTO_API_KEY")
        let client = TopicClient(configuration: TopicConfigurations.Default.latest(), credentialProvider: creds)
        XCTAssertNotNil(client)

        let subResp = await client.subscribe(
            cacheName: "test-cache",
            topicName: "test-topic"
        )
        XCTAssertTrue(
            subResp is TopicSubscribeSuccess,
            "Unexpected response: \((subResp as! TopicSubscribeError).description)"
        )

        try await Task.sleep(nanoseconds: 1000)
        let binaryValue = "publishing and subscribing!".data(using: .utf8)!
        let pubResp = await client.publish(
            cacheName: "test-cache",
            topicName: "test-topic",
            value: binaryValue
        )
        XCTAssertTrue(
            pubResp is TopicPublishSuccess,
            "Unexpected response: \((pubResp as! TopicPublishError).description)"
        )

        let subscription = (subResp as! TopicSubscribeSuccess).subscription
        for try await item in subscription {
            print("Received item: \(String(describing: item))")
            XCTAssertTrue(
                item is TopicSubscriptionItemBinary,
                "received subscription item that was not binary: \(String(describing: item))"
            )

            let value = (item as! TopicSubscriptionItemBinary).value
            print("Received value: \(String(decoding: value, as: UTF8.self))")
            XCTAssertEqual(
                value,
                binaryValue,
                "unexpected topic subscription item value: \(value)"
            )
            break
        }

        client.close()
        print("closed subscription")
    }
}
