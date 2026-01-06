import XCTest

@testable import Momento

final class apiKeyV2Tests: XCTestCase {
    private var integrationTestCacheName: String!
    private var cacheClient: CacheClientProtocol!
    private var topicClient: TopicClientProtocol!

    override func setUp() async throws {
        let testSetup = await setUpIntegrationTests(apiKeyV2: true)
        self.integrationTestCacheName = testSetup.cacheName
        self.cacheClient = testSetup.cacheClient
        self.topicClient = testSetup.topicClient
    }

    override func tearDown() async throws {
        await cleanUpIntegrationTests(
            cacheName: self.integrationTestCacheName,
            cacheClient: self.cacheClient
        )
    }

    // Control plane

    func testCacheClientCreatesAndDeletesCache() async throws {
        let cacheName = generateStringWithUuid(prefix: "a-totally-new-cache")
        let createResult = await self.cacheClient.createCache(cacheName: cacheName)
        switch createResult {
        case .alreadyExists(let exists):
            XCTFail("expected success but got \(exists)")
        case .error(let err):
            XCTFail("expected success but got \(err)")
        case .success(_):
            XCTAssertTrue(true)
        }

        let deleteResult = await self.cacheClient.deleteCache(cacheName: cacheName)
        switch deleteResult {
        case .error(let err):
            XCTFail("expected success but got \(err)")
        case .success(_):
            XCTAssertTrue(true)
        }
    }

    func testListCaches() async throws {
        let listResult = await self.cacheClient.listCaches()

        switch listResult {
        case .error(let err):
            XCTFail("expected success but got \(err)")
        case .success(let cacheList):
            XCTAssertTrue(
                cacheList.caches.contains(where: { item in
                    item.name == self.integrationTestCacheName
                }),
                "Integration test cache not found in list caches result: \(cacheList)"
            )
        }

        // Create new cache
        let newCacheName = generateStringWithUuid(prefix: "a-totally-different-cache")
        let createResult = await self.cacheClient.createCache(cacheName: newCacheName)
        switch createResult {
        case .alreadyExists(let exists):
            XCTFail("expected success but got \(exists)")
        case .error(let err):
            XCTFail("expected success but got \(err)")
        case .success(_):
            XCTAssertTrue(true)
        }

        // Expect list to include newly created cache
        let listResult2 = await self.cacheClient.listCaches()
        switch listResult2 {
        case .error(let err):
            XCTFail("expected success but got \(err)")
        case .success(let cacheList):
            XCTAssertTrue(
                cacheList.caches.contains(where: { item in
                    item.name == newCacheName
                })
            )
        }

        // Clean up additional created cache
        let deleteResult = await self.cacheClient.deleteCache(cacheName: newCacheName)
        switch deleteResult {
        case .error(let err):
            XCTFail("error deleting test cache: \(err)")
        default:
            XCTAssertTrue(true)
        }
    }

    // Scalar methods

    func testSetGetDelete() async throws {
        let key = "foo"
        let value = "fooaswell"
        let setResponse = await self.cacheClient.set(
            cacheName: self.integrationTestCacheName,
            key: ScalarType.string(key),
            value: ScalarType.string(value),
            ttl: TimeInterval(30)
        )
        switch setResponse {
        case .error(let err):
            XCTFail("expected success but got \(err))")
        case .success(_):
            XCTAssertTrue(true)
        }

        var getResponse = await self.cacheClient.get(
            cacheName: self.integrationTestCacheName, key: ScalarType.string(key)
        )
        switch getResponse {
        case .error(let err):
            XCTFail("expected hit but got \(err)")
        case .miss(let miss):
            XCTFail("expected hit but got \(miss)")
        case .hit(let hit):
            XCTAssertEqual(value, hit.valueString)
        }

        let deleteResponse = await self.cacheClient.delete(
            cacheName: self.integrationTestCacheName, key: ScalarType.string(key)
        )
        switch deleteResponse {
        case .error(let err):
            XCTFail("expected success but got \(err)")
        case .success(_):
            XCTAssertTrue(true)
        }

        getResponse = await self.cacheClient.get(
            cacheName: self.integrationTestCacheName, key: ScalarType.string(key)
        )
        switch getResponse {
        case .error(let err):
            XCTFail("expected miss but got \(err)")
        case .miss(_):
            XCTAssertTrue(true)
        case .hit(let hit):
            XCTFail("expected miss but got \(hit)")
        }
    }

    // Lists

    func testConcatAndFetch() async throws {
        let listName = generateStringWithUuid(prefix: "swift-list-concat-fetch-v2")

        // Successfully concatenates string values to the back
        let stringValues = ["abc", "lmn", "xyz"]
        let concatStringsBack = await self.cacheClient.listConcatenateBack(
            cacheName: self.integrationTestCacheName,
            listName: listName,
            values: stringValues
        )
        switch concatStringsBack {
        case .error(let err):
            XCTFail("expected success but got \(err)")
        case .success(let success):
            XCTAssertEqual(Int(stringValues.count), Int(success.listLength))
        }

        let fetchStringList = await self.cacheClient.listFetch(
            cacheName: self.integrationTestCacheName,
            listName: listName
        )
        switch fetchStringList {
        case .error(let err):
            XCTFail("expected success but got \(err)")
        case .miss(let miss):
            XCTFail("expected success but got \(miss)")
        case .hit(let hit):
            XCTAssertEqual(stringValues, hit.valueListString)
        }

        // Successfully concatenates values to the front
        let stringValues2 = ["123", "456", "789"]
        let concatStringsFront = await self.cacheClient.listConcatenateFront(
            cacheName: self.integrationTestCacheName,
            listName: listName,
            values: stringValues2
        )
        switch concatStringsFront {
        case .error(let err):
            XCTFail("expected success but got \(err)")
        case .success(let success):
            XCTAssertEqual(6, Int(success.listLength))
        }

        let fetchStringList2 = await self.cacheClient.listFetch(
            cacheName: self.integrationTestCacheName,
            listName: listName
        )
        let expectedList = stringValues2 + stringValues
        switch fetchStringList2 {
        case .error(let err):
            XCTFail("expected hit but got \(err)")
        case .miss(let miss):
            XCTFail("expected hit but got \(miss)")
        case .hit(let hit):
            XCTAssertEqual(expectedList, hit.valueListString)
        }
    }

    func testPushPopLength() async throws {
        let listName = generateStringWithUuid(prefix: "swift-list-push-pop-length-v2")

        // Successfully pushes string values to the back and truncates from front
        let stringValues = ["abc", "lmn", "xyz"]
        for value in stringValues {
            let pushBack: ListPushBackResponse = await self.cacheClient.listPushBack(
                cacheName: self.integrationTestCacheName,
                listName: listName,
                value: value,
                truncateFrontToSize: 2
            )
            switch pushBack {
            case .error(let err):
                XCTFail("expected success but got \(err)")
            case .success(_):
                XCTAssertTrue(true)
            }
        }

        // Length should be 2 due to truncation
        let lengthResult = await self.cacheClient.listLength(
            cacheName: self.integrationTestCacheName,
            listName: listName
        )
        switch lengthResult {
        case .error(let err):
            XCTFail("expected success but got \(err)")
        case .hit(let hit):
            XCTAssertEqual(2, Int(hit.length))
        case .miss(let miss):
            XCTFail("expected hit but got \(miss)")
        }

        // Pushes value to the front
        let pushFront = await self.cacheClient.listPushFront(
            cacheName: self.integrationTestCacheName,
            listName: listName,
            value: "123"
        )
        switch pushFront {
        case .error(let err):
            XCTFail("expected success but got \(err)")
        case .success(let success):
            XCTAssertEqual(success.listLength, 3)
        }

        // Pops value from the back
        let popBack = await self.cacheClient.listPopBack(
            cacheName: self.integrationTestCacheName,
            listName: listName
        )
        switch popBack {
        case .error(let err):
            XCTFail("expected success but got \(err)")
        case .miss(let miss):
            XCTFail("expected hit but got \(miss)")
        case .hit(let hit):
            XCTAssertEqual("xyz", hit.valueString)
        }

        // Pops value from the front
        let popFront = await self.cacheClient.listPopFront(
            cacheName: self.integrationTestCacheName,
            listName: listName
        )
        switch popFront {
        case .error(let err):
            XCTFail("expected success but got \(err)")
        case .miss(let miss):
            XCTFail("expected hit but got \(miss)")
        case .hit(let hit):
            XCTAssertEqual("123", hit.valueString)
        }

        // Length should be 1 due to pops
        let lengthResult2 = await self.cacheClient.listLength(
            cacheName: self.integrationTestCacheName,
            listName: listName
        )
        switch lengthResult2 {
        case .error(let err):
            XCTFail("expected success but got \(err)")
        case .hit(let hit):
            XCTAssertEqual(1, Int(hit.length))
        case .miss(let miss):
            XCTFail("expected hit but got \(miss)")
        }
    }

    func testRemoveValue() async throws {
        // Insert some data values
        let dataListName = generateStringWithUuid(prefix: "swift-list-remove-value-data-v2")
        let dataValues = [
            Data("abc".utf8), Data("lmn".utf8), Data("xyz".utf8), Data("abc".utf8),
            Data("abc".utf8),
        ]
        let noAbcData = dataValues.filter { $0 != Data("abc".utf8) }
        let concatData = await self.cacheClient.listConcatenateBack(
            cacheName: self.integrationTestCacheName,
            listName: dataListName,
            values: dataValues
        )
        switch concatData {
        case .error(let err):
            XCTFail("expected succes but got \(err)")
        default:
            break
        }

        // Removes all instances of given data
        let removeData1 = await self.cacheClient.listRemoveValue(
            cacheName: self.integrationTestCacheName,
            listName: dataListName,
            value: Data("abc".utf8)
        )
        switch removeData1 {
        case .error(let err):
            XCTFail("expected success but got \(err)")
        default:
            break
        }

        let fetchDataList = await self.cacheClient.listFetch(
            cacheName: self.integrationTestCacheName,
            listName: dataListName
        )
        switch fetchDataList {
        case .error(let err):
            XCTFail("expected hit but got \(err)")
        case .miss(let miss):
            XCTFail("expected hit but got \(miss)")
        case .hit(let hit):
            XCTAssertEqual(noAbcData, hit.valueListData)
        }

        // Removes no elements if given string not found
        let removeData2 = await self.cacheClient.listRemoveValue(
            cacheName: self.integrationTestCacheName,
            listName: dataListName,
            value: Data("abc".utf8)
        )
        switch removeData2 {
        case .error(let err):
            XCTFail("expected success but got \(err)")
        default:
            break
        }

        let fetchDataList2 = await self.cacheClient.listFetch(
            cacheName: self.integrationTestCacheName,
            listName: dataListName
        )
        switch fetchDataList2 {
        case .error(let err):
            XCTFail("expected hit but got \(err)")
        case .miss(let miss):
            XCTFail("expected hit but goit \(miss)")
        case .hit(let hit):
            XCTAssertEqual(noAbcData, hit.valueListData)
        }
    }

    func testRetainSliceWithNilEnd() async throws {
        // Insert some values
        let listName = generateStringWithUuid(prefix: "swift-list-retain-v2")
        let stringValues = ["apple", "banana", "carrot", "durian", "eggplant", "fig", "guava"]
        let concatStrings = await self.cacheClient.listConcatenateBack(
            cacheName: self.integrationTestCacheName,
            listName: listName,
            values: stringValues
        )
        switch concatStrings {
        case .error(let err):
            XCTFail("expected succes but got \(err)")
        default:
            break
        }

        // Retains slice with nil end index
        let retainsNilEnd = await self.cacheClient.listRetain(
            cacheName: self.integrationTestCacheName,
            listName: listName,
            startIndex: 3,
            endIndex: nil
        )
        switch retainsNilEnd {
        case .error(let err):
            XCTFail("expected success but got \(err)")
        default:
            break
        }
        let fetch = await self.cacheClient.listFetch(
            cacheName: self.integrationTestCacheName,
            listName: listName
        )
        switch fetch {
        case .error(let err):
            XCTFail("expected hit but got \(err)")
        case .miss(let miss):
            XCTFail("expected hit but got \(miss)")
        case .hit(let hit):
            XCTAssertEqual(Array(stringValues[3...]), hit.valueListString)
        }
    }

    // Topics

    func testTopicClientPublishesAndSubscribes() async throws {
        let topicName = generateStringWithUuid(prefix: "test-topic-v2")
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
        await subscription.unsubscribe()
    }
}
