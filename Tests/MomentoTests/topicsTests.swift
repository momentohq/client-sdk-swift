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
        switch invalidCacheNameResp {
        case .success(let success):
            XCTFail("expected error but got \(success)")
        case .error(let err):
            XCTAssertEqual(MomentoErrorCode.INVALID_ARGUMENT_ERROR, err.errorCode)
        }

        let invalidTopicNameResp = await self.topicClient.publish(
            cacheName: self.integrationTestCacheName,
            topicName: "",
            value: "test-message"
        )
        switch invalidTopicNameResp {
        case .success(let success):
            XCTFail("expected error but got \(success)")
        case .error(let err):
            XCTAssertEqual(MomentoErrorCode.INVALID_ARGUMENT_ERROR, err.errorCode)
        }

        let pubResp = await self.topicClient.publish(
            cacheName: self.integrationTestCacheName,
            topicName: topicName,
            value: "test-message"
        )
        switch pubResp {
        case .error(let err):
            XCTFail("expected success but got \(err)")
        case .success(_):
            XCTAssertTrue(true)
        }
    }

    func testTopicClientSubscribes() async throws {
        let topicName = generateStringWithUuid(prefix: "test-topic")

        let invalidCacheNameResp = await self.topicClient.subscribe(
            cacheName: "",
            topicName: topicName
        )
        switch invalidCacheNameResp {
        case .subscription(let sub):
            XCTFail("expected error but got \(sub)")
        case .error(let err):
            XCTAssertEqual(MomentoErrorCode.INVALID_ARGUMENT_ERROR, err.errorCode)
        }

        let invalidTopicNameResp = await self.topicClient.subscribe(
            cacheName: self.integrationTestCacheName,
            topicName: ""
        )
        switch invalidTopicNameResp {
        case .subscription(let sub):
            XCTFail("expected error but got \(sub)")
        case .error(let err):
            XCTAssertEqual(MomentoErrorCode.INVALID_ARGUMENT_ERROR, err.errorCode)
        }

        let subResp = await self.topicClient.subscribe(
            cacheName: self.integrationTestCacheName,
            topicName: topicName
        )
        switch subResp {
        case .error(let err):
            XCTFail("expected subscription but got \(err)")
        case .subscription:
            XCTAssertTrue(true)
        }
    }

    func testTopicClientPublishesAndSubscribes() async throws {
        let topicName = generateStringWithUuid(prefix: "test-topic")
        let topicValue = "publishing and subscribing!"
        let subResp = await self.topicClient.subscribe(
            cacheName: self.integrationTestCacheName,
            topicName: topicName
        )
        var subscription: TopicSubscription! = nil
        switch subResp {
        case .error(let err):
            XCTFail("expected subscription but got \(err)")
        case .subscription(let sub):
            subscription = sub
        }

        try await Task.sleep(nanoseconds: 1_000_000_000)
        let pubResp = await self.topicClient.publish(
            cacheName: self.integrationTestCacheName,
            topicName: topicName,
            value: topicValue
        )
        switch pubResp {
        case .error(let err):
            XCTFail("expected success but got \(err)")
        case .success(_):
            XCTAssertTrue(true)
        }

        for try await item in await subscription.stream {
            switch item {
            case .error(let err):
                XCTFail("expected itemText but got \(err)")
            case .itemBinary(let bin):
                XCTFail("expected itemText but got \(bin)")
            case .itemText(let itemText):
                XCTAssertEqual(itemText.value, topicValue)
            }
            break
        }
    }

    func testTopicClientPublishesAndSubscribesResumeAtSequence() async throws {
        let topicName = generateStringWithUuid(prefix: "test-topic")
        let topicValue = "publishing and subscribing!"
        let values = ["1", topicValue, "3"]

        for (value) in values {
            let pubResp = await self.topicClient.publish(
                cacheName: self.integrationTestCacheName,
                topicName: topicName,
                value: value
            )
            switch pubResp {
            case .error(let err):
                XCTFail("expected success but got \(err)")
            case .success(_):
                XCTAssertTrue(true)
            }
        }

        let subResp = await self.topicClient.subscribe(
            cacheName: self.integrationTestCacheName,
            topicName: topicName,
            resumeAtTopicSequenceNumber: 2,
            resumeAtTopicSequencePage: nil
        )
        var subscription: TopicSubscription! = nil
        switch subResp {
        case .error(let err):
            XCTFail("expected subscription but got \(err)")
        case .subscription(let sub):
            subscription = sub
        }

        for try await item in await subscription.stream {
            switch item {
            case .error(let err):
                XCTFail("expected itemText but got \(err)")
            case .itemBinary(let bin):
                XCTFail("expected itemText but got \(bin)")
            case .itemText(let itemText):
                XCTAssertEqual(itemText.value, topicValue)
            }
            break
        }
    }

    func testTopicClientPublishesAndSubscribesResumeAtInvalidSequence() async throws {
        let topicName = generateStringWithUuid(prefix: "test-topic")
        let topicValue = "publishing and subscribing!"

        let pubResp = await self.topicClient.publish(
            cacheName: self.integrationTestCacheName,
            topicName: topicName,
            value: topicValue
        )
        switch pubResp {
        case .error(let err):
            XCTFail("expected success but got \(err)")
        case .success(_):
            XCTAssertTrue(true)
        }

        let subResp = await self.topicClient.subscribe(
            cacheName: self.integrationTestCacheName,
            topicName: topicName,
            resumeAtTopicSequenceNumber: 5434,
            resumeAtTopicSequencePage: 95764
        )
        var subscription: TopicSubscription! = nil
        switch subResp {
        case .error(let err):
            XCTFail("expected subscription but got \(err)")
        case .subscription(let sub):
            subscription = sub
        }

        for try await item in await subscription.stream {
            switch item {
            case .error(let err):
                XCTFail("expected itemText but got \(err)")
            case .itemBinary(let bin):
                XCTFail("expected itemText but got \(bin)")
            case .itemText(let itemText):
                XCTAssertEqual(itemText.value, topicValue)
            }
            break
        }
    }

    func testTopicClientPublishesAndSubscribesBinary() async throws {
        let topicName = generateStringWithUuid(prefix: "test-topic")
        let subResp = await self.topicClient.subscribe(
            cacheName: self.integrationTestCacheName,
            topicName: topicName
        )
        var subscription: TopicSubscription! = nil
        switch subResp {
        case .error(let err):
            XCTFail("expected subscription but got \(err)")
        case .subscription(let sub):
            subscription = sub
        }

        try await Task.sleep(nanoseconds: 1_000_000_000)
        let binaryValue = "publishing and subscribing!".data(using: .utf8)!
        let pubResp = await self.topicClient.publish(
            cacheName: self.integrationTestCacheName,
            topicName: topicName,
            value: binaryValue
        )
        switch pubResp {
        case .error(let err):
            XCTFail("expected success but got \(err)")
        case .success(_):
            XCTAssertTrue(true)
        }

        for try await item in await subscription.stream {
            switch item {
            case .error(let err):
                XCTFail("expected itemBinary but got \(err)")
            case .itemText(let text):
                XCTFail("expected itemBinary but got \(text)")
            case .itemBinary(let itemBinary):
                XCTAssertEqual(binaryValue, itemBinary.value)
            }
            break
        }
    }
}
