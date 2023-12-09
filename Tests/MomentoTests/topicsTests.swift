import XCTest
@testable import Momento

final class topicsTests: XCTestCase {
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
    
    func testTopicClientPublishes() async throws {
        let topicName = generateStringWithUuid(prefix: "test-topic")
        
        let invalidCacheNameResp = await self.topicClient.publish(
            cacheName: "",
            topicName: topicName,
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
        
        let invalidTopicNameResp = await self.topicClient.publish(
            cacheName: self.integrationTestCacheName,
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
        
        let pubResp = await self.topicClient.publish(
            cacheName: self.integrationTestCacheName,
            topicName: topicName,
            value: "test-message"
        )
        XCTAssertTrue(
            pubResp is TopicPublishSuccess,
            "Unexpected response: \((pubResp as! TopicPublishError).description)"
        )
    }    
    
    func testTopicClientSubscribes() async throws {
        let topicName = generateStringWithUuid(prefix: "test-topic")
        
        let invalidCacheNameResp = await self.topicClient.subscribe(
            cacheName: "",
            topicName: topicName
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
        
        let invalidTopicNameResp = await self.topicClient.subscribe(
            cacheName: self.integrationTestCacheName,
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
        
        let subResp = await self.topicClient.subscribe(
            cacheName: self.integrationTestCacheName,
            topicName: topicName
        )
        XCTAssertTrue(
            subResp is TopicSubscribeSuccess,
            "Unexpected response: \((subResp as! TopicSubscribeError).description)"
        )
    }
    
    func testTopicClientPublishesAndSubscribes() async throws {
        let topicName = generateStringWithUuid(prefix: "test-topic")
        
        let subResp = await self.topicClient.subscribe(
            cacheName: self.integrationTestCacheName,
            topicName: topicName
        )
        XCTAssertTrue(
            subResp is TopicSubscribeSuccess,
            "Unexpected response: \((subResp as! TopicSubscribeError).description)"
        )
        
        try await Task.sleep(nanoseconds: 1_000_000_000)
        let pubResp = await self.topicClient.publish(
            cacheName: self.integrationTestCacheName,
            topicName: topicName,
            value: "publishing and subscribing!"
        )
        XCTAssertTrue(
            pubResp is TopicPublishSuccess,
            "Unexpected response: \((pubResp as! TopicPublishError).description)"
        )
        
        let subscription = (subResp as! TopicSubscribeSuccess).subscription
        for try await item in subscription {
            XCTAssertTrue(
                item is TopicSubscriptionItemText,
                "received subscription item that was not text: \(String(describing: item))"
            )
            
            let value = (item as! TopicSubscriptionItemText).value
            XCTAssertEqual(value, "publishing and subscribing!", "unexpected topic subscription item value: \(value)")
            break
        }
    }

    func testTopicClientPublishesAndSubscribesBinary() async throws {
        let topicName = generateStringWithUuid(prefix: "test-topic")
        
        let subResp = await self.topicClient.subscribe(
            cacheName: self.integrationTestCacheName,
            topicName: topicName
        )
        XCTAssertTrue(
            subResp is TopicSubscribeSuccess,
            "Unexpected response: \((subResp as! TopicSubscribeError).description)"
        )

        try await Task.sleep(nanoseconds: 1_000_000_000)
        let binaryValue = "publishing and subscribing!".data(using: .utf8)!
        let pubResp = await self.topicClient.publish(
            cacheName: self.integrationTestCacheName,
            topicName: topicName,
            value: binaryValue
        )
        XCTAssertTrue(
            pubResp is TopicPublishSuccess,
            "Unexpected response: \((pubResp as! TopicPublishError).description)"
        )

        let subscription = (subResp as! TopicSubscribeSuccess).subscription
        for try await item in subscription {
            XCTAssertTrue(
                item is TopicSubscriptionItemBinary,
                "received subscription item that was not binary: \(String(describing: item))"
            )

            let value = (item as! TopicSubscriptionItemBinary).value
            XCTAssertEqual(
                value,
                binaryValue,
                "unexpected topic subscription item value: \(value)"
            )
            break
        }
    }
}
