import XCTest
@testable import Momento

final class listTests: XCTestCase {
    private var integrationTestCacheName: String!
    private var cacheClient: CacheClientProtocol!
    
    override func setUp() async throws {
        let testSetup = await setUpIntegrationTests()
        self.integrationTestCacheName = testSetup.cacheName
        self.cacheClient = testSetup.cacheClient
    }
    
    override func tearDown() async throws {
        await cleanUpIntegrationTests(
            cacheName: self.integrationTestCacheName,
            cacheClient: self.cacheClient
        )
    }
    
    func testConcatBackValidatesParameters() async throws {
        let listName = generateStringWithUuid(prefix: "swift-list-concat-back")
        
        // Checks cache name
        let invalidCacheName = await self.cacheClient.listConcatenateBack(
            cacheName: "   ",
            listName: listName,
            values: ["abc", "xyz"]
        )
        switch invalidCacheName {
        case .success(let success):
            XCTFail("expected error but got \(success)")
        case .error(let err):
            XCTAssertEqual(MomentoErrorCode.INVALID_ARGUMENT_ERROR, err.errorCode)
        }

        // Checks list name
        let invalidListName = await self.cacheClient.listConcatenateBack(
            cacheName: self.integrationTestCacheName,
            listName: "   ",
            values: ["abc", "xyz"]
        )
        switch invalidListName {
        case .success(let success):
            XCTFail("expected error but got \(success)")
        case .error(let err):
            XCTAssertEqual(MomentoErrorCode.INVALID_ARGUMENT_ERROR, err.errorCode)
        }

        // Checks truncateFrontToSize
        let invalidTruncateSize = await self.cacheClient.listConcatenateBack(
            cacheName: self.integrationTestCacheName,
            listName: listName,
            values: ["abc", "xyz"],
            truncateFrontToSize: -5
        )
        switch invalidTruncateSize {
        case .success(let success):
            XCTFail("expected error but got \(success)")
        case .error(let err):
            XCTAssertEqual(MomentoErrorCode.INVALID_ARGUMENT_ERROR, err.errorCode)
        }

        // Checks ttl
        let invalidTtl = await self.cacheClient.listConcatenateBack(
            cacheName: self.integrationTestCacheName,
            listName: listName,
            values: ["abc", "xyz"],
            ttl: CollectionTtl(ttlSeconds: -5)
        )
        switch invalidTtl {
        case .success(let success):
            XCTFail("expected error but gor \(success)")
        case .error(let err):
            XCTAssertEqual(MomentoErrorCode.INVALID_ARGUMENT_ERROR, err.errorCode)
        }
    }
    
    func testConcatBack() async throws {
        // Successfully concatenates string values to the back
        let stringListName = generateStringWithUuid(prefix: "swift-list-concat-back-string")
        let stringValues = ["abc", "lmn", "xyz"]
        let concatStrings = await self.cacheClient.listConcatenateBack(
            cacheName: self.integrationTestCacheName,
            listName: stringListName,
            values: stringValues
        )
        switch concatStrings {
        case .error(let err):
            XCTFail("expected success but got \(err)")
        case .success(let success):
            XCTAssertEqual(Int(stringValues.count), Int(success.listLength))
        }

        let fetchStringList = await self.cacheClient.listFetch(
            cacheName: self.integrationTestCacheName,
            listName: stringListName
        )
        switch fetchStringList {
        case .error(let err):
            XCTFail("expected success but got \(err)")
        case .miss(let miss):
            XCTFail("expected success but got \(miss)")
        case .hit(let hit):
            XCTAssertEqual(stringValues, hit.valueListString)
        }

        // Successfully concatenates data values to the back
        let dataListName = generateStringWithUuid(prefix: "swift-list-concat-back-data")
        let dataValues = [Data("abc".utf8), Data("lmn".utf8), Data("xyz".utf8)]
        let concatData = await self.cacheClient.listConcatenateBack(
            cacheName: self.integrationTestCacheName,
            listName: dataListName,
            values: dataValues
        )
        switch concatData {
        case .error(let err):
            XCTFail("expected success but got \(err)")
        case .success(let success):
            XCTAssertEqual(Int(stringValues.count), Int(success.listLength))
        }

        let fetchDataList = await self.cacheClient.listFetch(
            cacheName: self.integrationTestCacheName,
            listName: dataListName
        )
        switch fetchDataList {
        case .error(let err):
            XCTFail("expected hit but got \(err)")
        case  .miss(let miss):
            XCTFail("expected hit but got \(miss)")
        case .hit(let hit):
            XCTAssertEqual(dataValues, hit.valueListData)
        }

        // Does not concatenate empty list to the back
        let emptyStringList: [String] = []
        let emptyList = await self.cacheClient.listConcatenateBack(
            cacheName: self.integrationTestCacheName,
            listName: stringListName,
            values: emptyStringList
        )
        switch emptyList {
        case .success(let success):
            XCTFail("expected error but got \(success)")
        case .error(let err):
            XCTAssertEqual(MomentoErrorCode.INVALID_ARGUMENT_ERROR, err.errorCode)
        }
    }
    
    func testConcatFrontValidatesParameters() async throws {
        let listName = generateStringWithUuid(prefix: "swift-list-concat-front")
        
        // Checks cache name
        let invalidCacheName = await self.cacheClient.listConcatenateFront(
            cacheName: "   ",
            listName: listName,
            values: ["abc", "xyz"]
        )
        switch invalidCacheName {
        case .success(let success):
            XCTFail("expected error but got \(success)")
        case .error(let err):
            XCTAssertEqual(MomentoErrorCode.INVALID_ARGUMENT_ERROR, err.errorCode)
        }

        // Checks list name
        let invalidListName = await self.cacheClient.listConcatenateFront(
            cacheName: self.integrationTestCacheName,
            listName: "   ",
            values: ["abc", "xyz"]
        )
        switch invalidListName {
        case .success(let success):
            XCTFail("expected error but got \(success)")
        case .error(let err):
            XCTAssertEqual(MomentoErrorCode.INVALID_ARGUMENT_ERROR, err.errorCode)
        }

        // Checks truncateFrontToSize
        let invalidTruncateSize = await self.cacheClient.listConcatenateFront(
            cacheName: self.integrationTestCacheName,
            listName: listName,
            values: ["abc", "xyz"],
            truncateBackToSize: -5
        )
        switch invalidTruncateSize {
        case .success(let success):
            XCTFail("expected error but got \(success)")
        case .error(let err):
            XCTAssertEqual(MomentoErrorCode.INVALID_ARGUMENT_ERROR, err.errorCode)
        }

        // Checks ttl
        let invalidTtl = await self.cacheClient.listConcatenateFront(
            cacheName: self.integrationTestCacheName,
            listName: listName,
            values: ["abc", "xyz"],
            ttl: CollectionTtl(ttlSeconds: -5)
        )
        switch invalidTtl {
        case .success(let success):
            XCTFail("expected error but got \(success)")
        case .error(let err):
            XCTAssertEqual(MomentoErrorCode.INVALID_ARGUMENT_ERROR, err.errorCode)
        }
    }
    
    func testConcatFront() async throws {
        // Successfully concatenates string values to the front
        let stringListName = generateStringWithUuid(prefix: "swift-list-concat-front-string")
        let stringValues = ["abc", "lmn", "xyz"]
        let concatStrings = await self.cacheClient.listConcatenateFront(
            cacheName: self.integrationTestCacheName,
            listName: stringListName,
            values: stringValues
        )
        switch concatStrings {
        case .error(let err):
            XCTFail("expected success but got \(err)")
        case .success(let success):
            XCTAssertEqual(Int(stringValues.count), Int(success.listLength))
        }

        let fetchStringList = await self.cacheClient.listFetch(
            cacheName: self.integrationTestCacheName,
            listName: stringListName
        )
        switch fetchStringList {
        case .error(let err):
            XCTFail("expected hit but got \(err)")
        case .miss(let miss):
            XCTFail("expected hit but got \(miss)")
        case .hit(let hit):
            XCTAssertEqual(stringValues, hit.valueListString)
        }

        // Successfully concatenates data values to the back
        let dataListName = generateStringWithUuid(prefix: "swift-list-concat-back-data")
        let dataValues = [Data("abc".utf8), Data("lmn".utf8), Data("xyz".utf8)]
        let concatData = await self.cacheClient.listConcatenateFront(
            cacheName: self.integrationTestCacheName,
            listName: dataListName,
            values: dataValues
        )
        switch concatData {
        case .error(let err):
            XCTFail("expected success but got \(err)")
        case .success(let success):
            XCTAssertEqual(Int(dataValues.count), Int(success.listLength))
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
            XCTAssertEqual(dataValues, hit.valueListData)
        }

        // Does not concatenate empty list to the back
        let emptyStringList: [String] = []
        let emptyList = await self.cacheClient.listConcatenateFront(
            cacheName: self.integrationTestCacheName,
            listName: stringListName,
            values: emptyStringList
        )
        switch emptyList {
        case .success(let success):
            XCTFail("expected error but got \(success)")
        case .error(let err):
            XCTAssertEqual(MomentoErrorCode.INVALID_ARGUMENT_ERROR, err.errorCode)
        }
    }
    
    func testFetchValidatesParameters() async throws {
        let listName = generateStringWithUuid(prefix: "swift-list-fetch")
        
        // Checks cache name
        let invalidCacheName = await self.cacheClient.listFetch(
            cacheName: "   ",
            listName: listName
        )
        switch invalidCacheName {
        case .hit(let hit):
            XCTFail("expected error but got \(hit)")
        case .miss(let miss):
            XCTFail("expected error but got \(miss)")
        case .error(let err):
            XCTAssertEqual(MomentoErrorCode.INVALID_ARGUMENT_ERROR, err.errorCode)
        }

        // Checks list name
        let invalidListName = await self.cacheClient.listFetch(
            cacheName: self.integrationTestCacheName,
            listName: "   "
        )
        switch invalidListName {
        case .hit(let hit):
            XCTFail("expected error but got \(hit)")
        case .miss(let miss):
            XCTFail("expected error but got \(miss)")
        case .error(let err):
            XCTAssertEqual(MomentoErrorCode.INVALID_ARGUMENT_ERROR, err.errorCode)
        }

        // Checks start and end index range
        let invalidSlice = await self.cacheClient.listFetch(
            cacheName: self.integrationTestCacheName,
            listName: listName,
            startIndex: 2,
            endIndex: 1
        )
        switch invalidSlice {
        case .hit(let hit):
            XCTFail("expected error but got \(hit)")
        case .miss(let miss):
            XCTFail("expected error but got \(miss)")
        case .error(let err):
            XCTAssertEqual(MomentoErrorCode.INVALID_ARGUMENT_ERROR, err.errorCode)
        }
    }
    
    func testListFetch() async throws {
        // Insert some values
        let listName = generateStringWithUuid(prefix: "swift-list-fetch")
        let stringValues = ["apple", "banana", "carrot", "durian", "eggplant", "fig", "guava"]
        let concatStrings = await self.cacheClient.listConcatenateBack(
            cacheName: self.integrationTestCacheName,
            listName: listName,
            values: stringValues
        )
        switch concatStrings {
        case .error(let err):
            XCTFail("expected success but got \(err)")
        default:
            break
        }

        // Fetches full list when no slice specified
        let fullList = await self.cacheClient.listFetch(
            cacheName: self.integrationTestCacheName,
            listName: listName
        )
        switch fullList {
        case .error(let err):
            XCTFail("expected hit but got \(err)")
        case .miss(let miss):
            XCTFail("expected hit but got \(miss)")
        case .hit(let hit):
            XCTAssertEqual(stringValues, hit.valueListString)
        }

        // Fetches positive slice range
        let positiveSliceList = await self.cacheClient.listFetch(
            cacheName: self.integrationTestCacheName,
            listName: listName,
            startIndex: 2,
            endIndex: 5
        )
        switch positiveSliceList {
        case .error(let err):
            XCTFail("expected hit but got \(err)")
        case .miss(let miss):
            XCTFail("expected hit but got \(miss)")
        case .hit(let hit):
            XCTAssertEqual(Array(stringValues[2...4]), hit.valueListString)
        }

        // Fetches negative slice range
        let negativeSliceList = await self.cacheClient.listFetch(
            cacheName: self.integrationTestCacheName,
            listName: listName,
            startIndex: 2,
            endIndex: -2
        )
        switch negativeSliceList {
        case .error(let err):
            XCTFail("expected hit but got \(err)")
        case .miss(let miss):
            XCTFail("expected hit but got \(miss)")
        case .hit(let hit):
            XCTAssertEqual(Array(stringValues[2...4]), hit.valueListString)
        }

        // Fetches slice with nil start index
        let nilStart = await self.cacheClient.listFetch(
            cacheName: self.integrationTestCacheName,
            listName: listName,
            startIndex: nil,
            endIndex: 4
        )
        switch nilStart {
        case .error(let err):
            XCTFail("expected hit but got \(err)")
        case .miss(let miss):
            XCTFail("expected hit but got \(miss)")
        case .hit(let hit):
            XCTAssertEqual(Array(stringValues[0...3]), hit.valueListString)
        }

        // Fetches slice with nil end index
        let nilEnd = await self.cacheClient.listFetch(
            cacheName: self.integrationTestCacheName,
            listName: listName,
            startIndex: 3,
            endIndex: nil
        )
        switch nilEnd {
        case .error(let err):
            XCTFail("expected hit but got \(err)")
        case .miss(let miss):
            XCTFail("expected hit but got \(miss)")
        case .hit(let hit):
            XCTAssertEqual(Array(stringValues[3...]), hit.valueListString)
        }
    }
    
    func testLengthValidatesParameters() async throws {
        let listName = generateStringWithUuid(prefix: "swift-list-length")
        
        // Checks cache name
        let invalidCacheName = await self.cacheClient.listLength(
            cacheName: "   ",
            listName: listName
        )
        switch invalidCacheName {
        case .hit(let hit):
            XCTFail("expected error but got \(hit)")
        case .miss(let miss):
            XCTFail("expected error but got \(miss)")
        case .error(let err):
            XCTAssertEqual(MomentoErrorCode.INVALID_ARGUMENT_ERROR, err.errorCode)
        }

        // Checks list name
        let invalidListName = await self.cacheClient.listLength(
            cacheName: self.integrationTestCacheName,
            listName: "   "
        )
        switch invalidListName {
        case .hit(let hit):
            XCTFail("expected error but got \(hit)")
        case .miss(let miss):
            XCTFail("expected error but got \(miss)")
        case .error(let err):
            XCTAssertEqual(MomentoErrorCode.INVALID_ARGUMENT_ERROR, err.errorCode)
        }
    }
    
    func testListLength() async throws {
        let listName = generateStringWithUuid(prefix: "swift-list-length")
        let stringValues = ["apple", "banana", "carrot", "durian", "eggplant", "fig", "guava"]
        let frontSlice = Array(stringValues[0...3])
        let backSlice = Array(stringValues[4...])

        let insert1 = await self.cacheClient.listConcatenateBack(
            cacheName: self.integrationTestCacheName,
            listName: listName,
            values: frontSlice
        )
        switch insert1 {
        case .error(let err):
            XCTFail("expected succes but got \(err)")
        default:
            break
        }

        let fetchLength1 = await self.cacheClient.listLength(
            cacheName: self.integrationTestCacheName,
            listName: listName
        )
        switch fetchLength1 {
        case .error(let err):
            XCTFail("expected hit but got \(err)")
        case .miss(let miss):
            XCTFail("expected hit but got \(miss)")
        case .hit(let hit):
            XCTAssertEqual(Int(frontSlice.count), Int(hit.length))
        }
        
        let insert2 = await self.cacheClient.listConcatenateBack(
            cacheName: self.integrationTestCacheName,
            listName: listName,
            values: backSlice
        )
        switch insert2 {
        case .error(let err):
            XCTFail("expected succes but got \(err)")
        default:
            break
        }

        let fetchLength2 = await self.cacheClient.listLength(
            cacheName: self.integrationTestCacheName,
            listName: listName
        )
        switch fetchLength2 {
        case .error(let err):
            XCTFail("expected hit but got \(err)")
        case .miss(let miss):
            XCTFail("expected hit but got \(miss)")
        case .hit(let hit):
            XCTAssertEqual(Int(stringValues.count), Int(hit.length))
        }
    }
    
    func testPopBackValidatesParameters() async throws {
        let listName = generateStringWithUuid(prefix: "swift-list-pop-back")
        
        // Checks cache name
        let invalidCacheName = await self.cacheClient.listPopBack(
            cacheName: "   ",
            listName: listName
        )
        switch invalidCacheName {
        case .hit(let hit):
            XCTFail("expected error but got \(hit)")
        case .miss(let miss):
            XCTFail("expected error but got \(miss)")
        case .error(let err):
            XCTAssertEqual(MomentoErrorCode.INVALID_ARGUMENT_ERROR, err.errorCode)
        }

        // Checks list name
        let invalidListName = await self.cacheClient.listPopBack(
            cacheName: self.integrationTestCacheName,
            listName: "   "
        )
        switch invalidListName {
        case .hit(let hit):
            XCTFail("expected error but got \(hit)")
        case .miss(let miss):
            XCTFail("expected error but got \(miss)")
        case .error(let err):
            XCTAssertEqual(MomentoErrorCode.INVALID_ARGUMENT_ERROR, err.errorCode)
        }
    }
    
    func testPopBack() async throws {
        // Insert some values
        let listName = generateStringWithUuid(prefix: "swift-list-pop-back")
        let stringValues = ["apple", "banana"]
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

        // Expecting to receive values in back to front order
        let pop1 = await self.cacheClient.listPopBack(
            cacheName: self.integrationTestCacheName,
            listName: listName
        )
        switch pop1 {
        case .error(let err):
            XCTFail("expected hit but got \(err)")
        case .miss(let miss):
            XCTFail("expected hit but got \(miss)")
        case .hit(let hit):
            XCTAssertEqual(stringValues[1], hit.valueString)
        }

        let pop2 = await self.cacheClient.listPopBack(
            cacheName: self.integrationTestCacheName,
            listName: listName
        )
        switch pop2 {
        case .error(let err):
            XCTFail("expected hit but got \(err)")
        case .miss(let miss):
            XCTFail("expected hit but got \(miss)")
        case .hit(let hit):
            XCTAssertEqual(stringValues[0], hit.valueString)
        }

        // Miss when popping from empty list
        let pop3 = await self.cacheClient.listPopBack(
            cacheName: self.integrationTestCacheName,
            listName: listName
        )
        switch pop3 {
        case .error(let err):
            XCTFail("expected miss but got \(err)")
        case .hit(let hit):
            XCTFail("expected miss but got \(hit)")
        case .miss(_):
            XCTAssertTrue(true)
        }
    }
    
    func testPopFrontValidatesParameters() async throws {
        let listName = generateStringWithUuid(prefix: "swift-list-pop-front")
        
        // Checks cache name
        let invalidCacheName = await self.cacheClient.listPopFront(
            cacheName: "   ",
            listName: listName
        )
        switch invalidCacheName {
        case .hit(let hit):
            XCTFail("expected error but got \(hit)")
        case .miss(let miss):
            XCTFail("expected error but got \(miss)")
        case .error(let err):
            XCTAssertEqual(MomentoErrorCode.INVALID_ARGUMENT_ERROR, err.errorCode)
        }

        // Checks list name
        let invalidListName = await self.cacheClient.listPopFront(
            cacheName: self.integrationTestCacheName,
            listName: "   "
        )
        switch invalidListName {
        case .hit(let hit):
            XCTFail("expected error but got \(hit)")
        case .miss(let miss):
            XCTFail("expected error but got \(miss)")
        case .error(let err):
            XCTAssertEqual(MomentoErrorCode.INVALID_ARGUMENT_ERROR, err.errorCode)
        }
    }
    
    func testPopFront() async throws {
        // Insert some values
        let listName = generateStringWithUuid(prefix: "swift-list-pop-front")
        let stringValues = ["apple", "banana"]
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

        // Expecting to receive values in front to back order
        let pop1 = await self.cacheClient.listPopFront(
            cacheName: self.integrationTestCacheName,
            listName: listName
        )
        switch pop1 {
        case .error(let err):
            XCTFail("expected hit but got \(err)")
        case .miss(let miss):
            XCTFail("expected hit but got \(miss)")
        case .hit(let hit):
            XCTAssertEqual(stringValues[0], hit.valueString)
        }

        let pop2 = await self.cacheClient.listPopFront(
            cacheName: self.integrationTestCacheName,
            listName: listName
        )
        switch pop2 {
        case .error(let err):
            XCTFail("expected hit but got \(err)")
        case .miss(let miss):
            XCTFail("expected hit but got \(miss)")
        case .hit(let hit):
            XCTAssertEqual(stringValues[1], hit.valueString)
        }

        // Miss when popping from empty list
        let pop3 = await self.cacheClient.listPopFront(
            cacheName: self.integrationTestCacheName,
            listName: listName
        )
        switch pop3 {
        case .error(let err):
            XCTFail("expected miss but got \(err)")
        case .miss(_):
            XCTAssertTrue(true)
        case .hit(let hit):
            XCTFail("expected miss but got \(hit)")
        }
    }

    func testPushBackValidatesParameters() async throws {
        let listName = generateStringWithUuid(prefix: "swift-list-push-back")
        
        // Checks cache name
        let invalidCacheName = await self.cacheClient.listPushBack(
            cacheName: "   ",
            listName: listName,
            value: "abc"
        )
        switch invalidCacheName {
        case .success(let success):
            XCTFail("expecgted error but got \(success)")
        case .error(let err):
            XCTAssertEqual(MomentoErrorCode.INVALID_ARGUMENT_ERROR, err.errorCode)
        }

        // Checks list name
        let invalidListName = await self.cacheClient.listPushBack(
            cacheName: self.integrationTestCacheName,
            listName: "   ",
            value: "abc"
        )
        switch invalidListName {
        case .success(let success):
            XCTFail("expecgted error but got \(success)")
        case .error(let err):
            XCTAssertEqual(MomentoErrorCode.INVALID_ARGUMENT_ERROR, err.errorCode)
        }

        // Checks truncateFrontToSize
        let invalidTruncateSize = await self.cacheClient.listPushBack(
            cacheName: self.integrationTestCacheName,
            listName: listName,
            value: "abc",
            truncateFrontToSize: -5
        )
        switch invalidTruncateSize {
        case .success(let success):
            XCTFail("expecgted error but got \(success)")
        case .error(let err):
            XCTAssertEqual(MomentoErrorCode.INVALID_ARGUMENT_ERROR, err.errorCode)
        }

        // Checks ttl
        let invalidTtl = await self.cacheClient.listPushBack(
            cacheName: self.integrationTestCacheName,
            listName: listName,
            value: "abc",
            ttl: CollectionTtl(ttlSeconds: -5)
        )
        switch invalidTtl {
        case .success(let success):
            XCTFail("expecgted error but got \(success)")
        case .error(let err):
            XCTAssertEqual(MomentoErrorCode.INVALID_ARGUMENT_ERROR, err.errorCode)
        }
    }
    
    func testPushBack() async throws {
        // Pushes string values
        let stringListName = generateStringWithUuid(prefix: "swift-list-push-back-string")
        let stringValues = ["abc", "lmn", "xyz"]
        for value in stringValues {
            let pushBack = await self.cacheClient.listPushBack(
                cacheName: self.integrationTestCacheName,
                listName: stringListName,
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

        let fetchStringList = await self.cacheClient.listFetch(
            cacheName: self.integrationTestCacheName,
            listName: stringListName
        )
        switch fetchStringList {
        case .error(let err):
            XCTFail("expected hit but got \(err)")
        case .miss(let miss):
            XCTFail("expected hit but got \(miss)")
        case .hit(let hit):
            XCTAssertEqual(Array(stringValues[1...2]), hit.valueListString)
        }

        // Pushes data values
        let dataListName = generateStringWithUuid(prefix: "swift-list-push-back-data")
        let dataValues = [Data("abc".utf8), Data("lmn".utf8), Data("xyz".utf8)]
        for value in dataValues {
            let pushBack = await self.cacheClient.listPushBack(
                cacheName: self.integrationTestCacheName,
                listName: dataListName,
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
            XCTAssertEqual(Array(dataValues[1...2]), hit.valueListData)
        }
    }

    func testPushFrontValidatesParameters() async throws {
        let listName = generateStringWithUuid(prefix: "swift-list-push-front")
        
        // Checks cache name
        let invalidCacheName = await self.cacheClient.listPushFront(
            cacheName: "   ",
            listName: listName,
            value: "abc"
        )
        switch invalidCacheName {
        case .success(let success):
            XCTFail("expected error but got \(success)")
        case .error(let err):
            XCTAssertEqual(MomentoErrorCode.INVALID_ARGUMENT_ERROR, err.errorCode)
        }

        // Checks list name
        let invalidListName = await self.cacheClient.listPushFront(
            cacheName: self.integrationTestCacheName,
            listName: "   ",
            value: "abc"
        )
        switch invalidListName {
        case .success(let success):
            XCTFail("expected error but got \(success)")
        case .error(let err):
            XCTAssertEqual(MomentoErrorCode.INVALID_ARGUMENT_ERROR, err.errorCode)
        }

        // Checks truncateFrontToSize
        let invalidTruncateSize = await self.cacheClient.listPushFront(
            cacheName: self.integrationTestCacheName,
            listName: listName,
            value: "abc",
            truncateBackToSize: -5
        )
        switch invalidTruncateSize {
        case .success(let success):
            XCTFail("expected error but got \(success)")
        case .error(let err):
            XCTAssertEqual(MomentoErrorCode.INVALID_ARGUMENT_ERROR, err.errorCode)
        }

        // Checks ttl
        let invalidTtl = await self.cacheClient.listPushFront(
            cacheName: self.integrationTestCacheName,
            listName: listName,
            value: "abc",
            ttl: CollectionTtl(ttlSeconds: -5)
        )
        switch invalidTtl {
        case .success(let success):
            XCTFail("expected error but got \(success)")
        case .error(let err):
            XCTAssertEqual(MomentoErrorCode.INVALID_ARGUMENT_ERROR, err.errorCode)
        }
    }
    
    func testPushFront() async throws {
        // Pushes string values
        let stringListName = generateStringWithUuid(prefix: "swift-list-push-front-string")
        let stringValues = ["abc", "lmn", "xyz"]
        for value in stringValues {
            let pushFront = await self.cacheClient.listPushFront(
                cacheName: self.integrationTestCacheName,
                listName: stringListName,
                value: value,
                truncateBackToSize: 2
            )
            switch pushFront {
            case .success(_):
                break
            case .error(let err):
                XCTFail("expected success but got \(err)")
            }
        }
        let fetchStringList = await self.cacheClient.listFetch(
            cacheName: self.integrationTestCacheName,
            listName: stringListName
        )
        switch fetchStringList {
        case .error(let err):
            XCTFail("expected hit but got \(err)")
        case .miss(let miss):
            XCTFail("expected hit but got \(miss)")
        case .hit(let hit):
            XCTAssertEqual(Array(stringValues[1...2]).reversed(), hit.valueListString)
        }

        // Pushes data values
        let dataListName = generateStringWithUuid(prefix: "swift-list-push-front-data")
        let dataValues = [Data("abc".utf8), Data("lmn".utf8), Data("xyz".utf8)]
        for value in dataValues {
            let pushFront = await self.cacheClient.listPushFront(
                cacheName: self.integrationTestCacheName,
                listName: dataListName,
                value: value,
                truncateBackToSize: 2
            )
            switch pushFront {
            case .success(_):
                break
            case .error(let err):
                XCTFail("expected success but got \(err)")
            }
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
            XCTAssertEqual(Array(dataValues[1...2]).reversed(), hit.valueListData)
        }
    }
    
    func testRemoveValueValidatesParameters() async throws {
        let listName = generateStringWithUuid(prefix: "swift-list-remove-value")
        
        // Checks cache name
        let invalidCacheName = await self.cacheClient.listRemoveValue(
            cacheName: "   ",
            listName: listName,
            value: "abc"
        )
        switch invalidCacheName {
        case .success(let success):
            XCTFail("expected error but got \(success)")
        case .error(let err):
            XCTAssertEqual(MomentoErrorCode.INVALID_ARGUMENT_ERROR, err.errorCode)
        }

        // Checks list name
        let invalidListName = await self.cacheClient.listRemoveValue(
            cacheName: self.integrationTestCacheName,
            listName: "   ",
            value: "abc"
        )
        switch invalidListName {
        case .success(let success):
            XCTFail("expected error but got \(success)")
        case .error(let err):
            XCTAssertEqual(MomentoErrorCode.INVALID_ARGUMENT_ERROR, err.errorCode)
        }
    }
    
    func testRemoveValue() async throws {
        // Insert some string values
        let stringListName = generateStringWithUuid(prefix: "swift-list-remove-value-string")
        let stringValues = ["apple", "banana", "apple", "apple", "carrot"]
        let noAppleStrings = stringValues.filter { $0 != "apple"}
        let concatStrings = await self.cacheClient.listConcatenateBack(
            cacheName: self.integrationTestCacheName,
            listName: stringListName,
            values: stringValues
        )
        switch concatStrings {
        case .error(let err):
            XCTFail("expected succes but got \(err)")
        default:
            break
        }

        // Removes all instances of given string
        let remove1 = await self.cacheClient.listRemoveValue(
            cacheName: self.integrationTestCacheName,
            listName: stringListName,
            value: "apple"
        )
        switch remove1 {
        case .error(let err):
            XCTFail("expected success but got \(err)")
        default:
            break
        }

        let fetchStringList = await self.cacheClient.listFetch(
            cacheName: self.integrationTestCacheName,
            listName: stringListName
        )
        switch fetchStringList {
        case .error(let err):
            XCTFail("expected hit but got \(err)")
        case .miss(let miss):
            XCTFail("expected hit but got \(miss)")
        case .hit(let hit):
            XCTAssertEqual(noAppleStrings, hit.valueListString)
        }

        // Removes no elements if given string not found
        let remove2 = await self.cacheClient.listRemoveValue(
            cacheName: self.integrationTestCacheName,
            listName: stringListName,
            value: "apple"
        )
        switch remove2 {
        case .error(let err):
            XCTFail("expected success but got \(err)")
        default:
            break
        }

        let fetchStringList2 = await self.cacheClient.listFetch(
            cacheName: self.integrationTestCacheName,
            listName: stringListName
        )
        switch fetchStringList2 {
        case .error(let err):
            XCTFail("expected hit but got \(err)")
        case .miss(let miss):
            XCTFail("expected hit but got \(miss)")
        case .hit(let hit):
            XCTAssertEqual(noAppleStrings, hit.valueListString)
        }

        // Insert some data values
        let dataListName = generateStringWithUuid(prefix: "swift-list-remove-value-data")
        let dataValues = [Data("abc".utf8), Data("lmn".utf8), Data("xyz".utf8), Data("abc".utf8), Data("abc".utf8)]
        let noAbcData = dataValues.filter { $0 != Data("abc".utf8)}
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

    func testRetainValidatesParameters() async throws {
        let listName = generateStringWithUuid(prefix: "swift-list-retain")
        
        // Checks cache name
        let invalidCacheName = await self.cacheClient.listRetain(
            cacheName: "   ",
            listName: listName
        )
        switch invalidCacheName {
        case .success(let success):
            XCTFail("expected error but got \(success)")
        case .error(let err):
            XCTAssertEqual(MomentoErrorCode.INVALID_ARGUMENT_ERROR, err.errorCode)
        }

        // Checks list name
        let invalidListName = await self.cacheClient.listRetain(
            cacheName: self.integrationTestCacheName,
            listName: "   "
        )
        switch invalidListName {
        case .success(let success):
            XCTFail("expected error but got \(success)")
        case .error(let err):
            XCTAssertEqual(MomentoErrorCode.INVALID_ARGUMENT_ERROR, err.errorCode)
        }

        // Checks start and end index range
        let invalidSlice = await self.cacheClient.listRetain(
            cacheName: self.integrationTestCacheName,
            listName: listName,
            startIndex: 2,
            endIndex: 1
        )
        switch invalidSlice {
        case .success(let success):
            XCTFail("expected error but got \(success)")
        case .error(let err):
            XCTAssertEqual(MomentoErrorCode.INVALID_ARGUMENT_ERROR, err.errorCode)
        }

        // Checks ttl
        let invalidTtl = await self.cacheClient.listRetain(
            cacheName: self.integrationTestCacheName,
            listName: listName,
            ttl: CollectionTtl(ttlSeconds: -5)
        )
        switch invalidTtl {
        case .success(let success):
            XCTFail("expected error but got \(success)")
        case .error(let err):
            XCTAssertEqual(MomentoErrorCode.INVALID_ARGUMENT_ERROR, err.errorCode)
        }
    }
    
    func testRetainFullList() async throws {
        // Insert some values
        let listName = generateStringWithUuid(prefix: "swift-list-retain")
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

        // Retains full list when no slice specified
        let retainFullList = await self.cacheClient.listRetain(
            cacheName: self.integrationTestCacheName,
            listName: listName
        )
        switch retainFullList {
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
            XCTAssertEqual(stringValues, hit.valueListString)
        }
    }
    
    func testRetainPositiveSlice() async throws {
        // Insert some values
        let listName = generateStringWithUuid(prefix: "swift-list-retain")
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

        // Retains positive slice range
        let retainPositiveSlice = await self.cacheClient.listRetain(
            cacheName: self.integrationTestCacheName,
            listName: listName,
            startIndex: 2,
            endIndex: 5
        )
        switch retainPositiveSlice {
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
            XCTAssertEqual(Array(stringValues[2...4]), hit.valueListString)
        }
    }
     
    func testRetainNegativeSlice() async throws {
        // Insert some values
        let listName = generateStringWithUuid(prefix: "swift-list-retain")
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

        // Retains negative slice range
        let retainsNegativeSlice = await self.cacheClient.listRetain(
            cacheName: self.integrationTestCacheName,
            listName: listName,
            startIndex: 2,
            endIndex: -2
        )
        switch retainsNegativeSlice {
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
            XCTAssertEqual(Array(stringValues[2...4]), hit.valueListString)
        }
    }
      
    func testRetainSliceWithNilStart() async throws {
        // Insert some values
        let listName = generateStringWithUuid(prefix: "swift-list-retain")
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

        // Retains slice with nil start index
        let retainsNilStart = await self.cacheClient.listRetain(
            cacheName: self.integrationTestCacheName,
            listName: listName,
            startIndex: nil,
            endIndex: 4
        )
        switch retainsNilStart {
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
            XCTAssertEqual(Array(stringValues[0...3]), hit.valueListString)
        }
    }
    
    func testRetainSliceWithNilEnd() async throws {
        // Insert some values
        let listName = generateStringWithUuid(prefix: "swift-list-retain")
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
}
