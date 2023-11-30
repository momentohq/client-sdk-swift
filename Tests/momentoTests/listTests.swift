import XCTest
@testable import momento

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
            values: [ScalarType.string("abc"), ScalarType.string("xyz")]
        )
        XCTAssertTrue(
            invalidCacheName is CacheListConcatenateBackError,
            "Unexpected response: \(invalidCacheName)"
        )
        let invalidCacheNameCode = (invalidCacheName as! CacheListConcatenateBackError).errorCode
        XCTAssertEqual(
            invalidCacheNameCode, MomentoErrorCode.INVALID_ARGUMENT_ERROR,
            "Unexpected error code: \(invalidCacheNameCode)"
        )
        
        // Checks list name
        let invalidListName = await self.cacheClient.listConcatenateBack(
            cacheName: self.integrationTestCacheName,
            listName: "   ",
            values: [ScalarType.string("abc"), ScalarType.string("xyz")]
        )
        XCTAssertTrue(
            invalidListName is CacheListConcatenateBackError,
            "Unexpected response: \(invalidListName)"
        )
        let invalidListNameCode = (invalidListName as! CacheListConcatenateBackError).errorCode
        XCTAssertEqual(
            invalidListNameCode, MomentoErrorCode.INVALID_ARGUMENT_ERROR,
            "Unexpected error code: \(invalidListNameCode)"
        )
        
        // Checks truncateFrontToSize
        let invalidTruncateSize = await self.cacheClient.listConcatenateBack(
            cacheName: self.integrationTestCacheName,
            listName: listName,
            values: [ScalarType.string("abc"), ScalarType.string("xyz")],
            truncateFrontToSize: -5
        )
        XCTAssertTrue(
            invalidTruncateSize is CacheListConcatenateBackError,
            "Unexpected response: \(invalidTruncateSize)"
        )
        let invalidTruncateSizeCode = (invalidTruncateSize as! CacheListConcatenateBackError).errorCode
        XCTAssertEqual(
            invalidTruncateSizeCode, MomentoErrorCode.INVALID_ARGUMENT_ERROR,
            "Unexpected error code: \(invalidTruncateSizeCode)"
        )
        
        // Checks ttl
        let invalidTtl = await self.cacheClient.listConcatenateBack(
            cacheName: self.integrationTestCacheName,
            listName: listName,
            values: [ScalarType.string("abc"), ScalarType.string("xyz")],
            ttl: TimeInterval.infinity
        )
        XCTAssertTrue(
            invalidTtl is CacheListConcatenateBackError,
            "Unexpected response: \(invalidTtl)"
        )
        let invalidTtlCode = (invalidTtl as! CacheListConcatenateBackError).errorCode
        XCTAssertEqual(
            invalidTtlCode, MomentoErrorCode.INVALID_ARGUMENT_ERROR,
            "Unexpected error code: \(invalidTtlCode)"
        )
    }
    
    func testConcatBack() async throws {
        // Successfully concatenates string values to the back
        let stringListName = generateStringWithUuid(prefix: "swift-list-concat-back-string")
        let stringValues = ["abc", "lmn", "xyz"]
        let concatStrings = await self.cacheClient.listConcatenateBack(
            cacheName: self.integrationTestCacheName,
            listName: stringListName,
            values: stringValues.map { ScalarType.string($0) }
        )
        XCTAssertTrue(
            concatStrings is CacheListConcatenateBackSuccess,
            "Unexpected response: \(concatStrings)"
        )
        let fetchStringList = await self.cacheClient.listFetch(
            cacheName: self.integrationTestCacheName,
            listName: stringListName
        )
        XCTAssertTrue(
            fetchStringList is CacheListFetchHit,
            "Unexpected response: \(fetchStringList)"
        )
        let fetchedStringList = (fetchStringList as! CacheListFetchHit).valueListString
        XCTAssertEqual(fetchedStringList, stringValues)
        
        // Successfully concatenates data values to the back
        let dataListName = generateStringWithUuid(prefix: "swift-list-concat-back-data")
        let dataValues = [Data("abc".utf8), Data("lmn".utf8), Data("xyz".utf8)]
        let concatData = await self.cacheClient.listConcatenateBack(
            cacheName: self.integrationTestCacheName,
            listName: dataListName,
            values: dataValues.map { ScalarType.data($0) }
        )
        XCTAssertTrue(
            concatData is CacheListConcatenateBackSuccess,
            "Unexpected response: \(concatData)"
        )
        let fetchDataList = await self.cacheClient.listFetch(
            cacheName: self.integrationTestCacheName,
            listName: dataListName
        )
        XCTAssertTrue(
            fetchDataList is CacheListFetchHit,
            "Unexpected response: \(fetchDataList)"
        )
        let fetchedDataList = (fetchDataList as! CacheListFetchHit).valueListData
        XCTAssertEqual(fetchedDataList, dataValues)
        
        // Does not concatenate empty list to the back
        let emptyList = await self.cacheClient.listConcatenateBack(
            cacheName: self.integrationTestCacheName,
            listName: stringListName,
            values: []
        )
        XCTAssertTrue(
            emptyList is CacheListConcatenateBackError,
            "Unexpected response: \(emptyList)"
        )
        let emptyListCode = (emptyList as! CacheListConcatenateBackError).errorCode
        XCTAssertEqual(
            emptyListCode, MomentoErrorCode.INVALID_ARGUMENT_ERROR,
            "Unexpected error code: \(emptyListCode)"
        )
    }
    
    func testConcatFrontValidatesParameters() async throws {
        let listName = generateStringWithUuid(prefix: "swift-list-concat-front")
        
        // Checks cache name
        let invalidCacheName = await self.cacheClient.listConcatenateFront(
            cacheName: "   ",
            listName: listName,
            values: [ScalarType.string("abc"), ScalarType.string("xyz")]
        )
        XCTAssertTrue(
            invalidCacheName is CacheListConcatenateFrontError,
            "Unexpected response: \(invalidCacheName)"
        )
        let invalidCacheNameCode = (invalidCacheName as! CacheListConcatenateFrontError).errorCode
        XCTAssertEqual(
            invalidCacheNameCode, MomentoErrorCode.INVALID_ARGUMENT_ERROR,
            "Unexpected error code: \(invalidCacheNameCode)"
        )
        
        // Checks list name
        let invalidListName = await self.cacheClient.listConcatenateFront(
            cacheName: self.integrationTestCacheName,
            listName: "   ",
            values: [ScalarType.string("abc"), ScalarType.string("xyz")]
        )
        XCTAssertTrue(
            invalidListName is CacheListConcatenateFrontError,
            "Unexpected response: \(invalidListName)"
        )
        let invalidListNameCode = (invalidListName as! CacheListConcatenateFrontError).errorCode
        XCTAssertEqual(
            invalidListNameCode, MomentoErrorCode.INVALID_ARGUMENT_ERROR,
            "Unexpected error code: \(invalidListNameCode)"
        )
        
        // Checks truncateFrontToSize
        let invalidTruncateSize = await self.cacheClient.listConcatenateFront(
            cacheName: self.integrationTestCacheName,
            listName: listName,
            values: [ScalarType.string("abc"), ScalarType.string("xyz")],
            truncateBackToSize: -5
        )
        XCTAssertTrue(
            invalidTruncateSize is CacheListConcatenateFrontError,
            "Unexpected response: \(invalidTruncateSize)"
        )
        let invalidTruncateSizeCode = (invalidTruncateSize as! CacheListConcatenateFrontError).errorCode
        XCTAssertEqual(
            invalidTruncateSizeCode, MomentoErrorCode.INVALID_ARGUMENT_ERROR,
            "Unexpected error code: \(invalidTruncateSizeCode)"
        )
        
        // Checks ttl
        let invalidTtl = await self.cacheClient.listConcatenateFront(
            cacheName: self.integrationTestCacheName,
            listName: listName,
            values: [ScalarType.string("abc"), ScalarType.string("xyz")],
            ttl: TimeInterval.infinity
        )
        XCTAssertTrue(
            invalidTtl is CacheListConcatenateFrontError,
            "Unexpected response: \(invalidTtl)"
        )
        let invalidTtlCode = (invalidTtl as! CacheListConcatenateFrontError).errorCode
        XCTAssertEqual(
            invalidTtlCode, MomentoErrorCode.INVALID_ARGUMENT_ERROR,
            "Unexpected error code: \(invalidTtlCode)"
        )
    }
    
    func testConcatFront() async throws {
        // Successfully concatenates string values to the back
        let stringListName = generateStringWithUuid(prefix: "swift-list-concat-front-string")
        let stringValues = ["abc", "lmn", "xyz"]
        let concatStrings = await self.cacheClient.listConcatenateFront(
            cacheName: self.integrationTestCacheName,
            listName: stringListName,
            values: stringValues.map { ScalarType.string($0) }
        )
        XCTAssertTrue(
            concatStrings is CacheListConcatenateFrontSuccess,
            "Unexpected response: \(concatStrings)"
        )
        let fetchStringList = await self.cacheClient.listFetch(
            cacheName: self.integrationTestCacheName,
            listName: stringListName
        )
        XCTAssertTrue(
            fetchStringList is CacheListFetchHit,
            "Unexpected response: \(fetchStringList)"
        )
        let fetchedStringList = (fetchStringList as! CacheListFetchHit).valueListString
        XCTAssertEqual(fetchedStringList, stringValues)
        
        // Successfully concatenates data values to the back
        let dataListName = generateStringWithUuid(prefix: "swift-list-concat-back-data")
        let dataValues = [Data("abc".utf8), Data("lmn".utf8), Data("xyz".utf8)]
        let concatData = await self.cacheClient.listConcatenateFront(
            cacheName: self.integrationTestCacheName,
            listName: dataListName,
            values: dataValues.map { ScalarType.data($0) }
        )
        XCTAssertTrue(
            concatData is CacheListConcatenateFrontSuccess,
            "Unexpected response: \(concatData)"
        )
        let fetchDataList = await self.cacheClient.listFetch(
            cacheName: self.integrationTestCacheName,
            listName: dataListName
        )
        XCTAssertTrue(
            fetchDataList is CacheListFetchHit,
            "Unexpected response: \(fetchDataList)"
        )
        let fetchedDataList = (fetchDataList as! CacheListFetchHit).valueListData
        XCTAssertEqual(fetchedDataList, dataValues)
        
        // Does not concatenate empty list to the back
        let emptyList = await self.cacheClient.listConcatenateFront(
            cacheName: self.integrationTestCacheName,
            listName: stringListName,
            values: []
        )
        XCTAssertTrue(
            emptyList is CacheListConcatenateFrontError,
            "Unexpected response: \(emptyList)"
        )
        let emptyListCode = (emptyList as! CacheListConcatenateFrontError).errorCode
        XCTAssertEqual(
            emptyListCode, MomentoErrorCode.INVALID_ARGUMENT_ERROR,
            "Unexpected error code: \(emptyListCode)"
        )
    }
    
    func testFetchValidatesParameters() async throws {
        let listName = generateStringWithUuid(prefix: "swift-list-fetch")
        
        // Checks cache name
        let invalidCacheName = await self.cacheClient.listFetch(
            cacheName: "   ",
            listName: listName
        )
        XCTAssertTrue(
            invalidCacheName is CacheListFetchError,
            "Unexpected response: \(invalidCacheName)"
        )
        let invalidCacheNameCode = (invalidCacheName as! CacheListFetchError).errorCode
        XCTAssertEqual(
            invalidCacheNameCode, MomentoErrorCode.INVALID_ARGUMENT_ERROR,
            "Unexpected error code: \(invalidCacheNameCode)"
        )
        
        // Checks list name
        let invalidListName = await self.cacheClient.listFetch(
            cacheName: self.integrationTestCacheName,
            listName: "   "
        )
        XCTAssertTrue(
            invalidListName is CacheListFetchError,
            "Unexpected response: \(invalidListName)"
        )
        let invalidListNameCode = (invalidListName as! CacheListFetchError).errorCode
        XCTAssertEqual(
            invalidListNameCode, MomentoErrorCode.INVALID_ARGUMENT_ERROR,
            "Unexpected error code: \(invalidListNameCode)"
        )
        
        // Checks start and end index range
        let invalidSlice = await self.cacheClient.listFetch(
            cacheName: self.integrationTestCacheName,
            listName: listName,
            startIndex: 2,
            endIndex: 1
        )
        XCTAssertTrue(
            invalidSlice is CacheListFetchError,
            "Unexpected response: \(invalidSlice)"
        )
        let invalidSliceCode = (invalidSlice as! CacheListFetchError).errorCode
        XCTAssertEqual(
            invalidSliceCode, MomentoErrorCode.INVALID_ARGUMENT_ERROR,
            "Unexpected error code: \(invalidSliceCode)"
        )
    }
    
    func testListFetch() async throws {
        // Insert some values
        let listName = generateStringWithUuid(prefix: "swift-list-fetch")
        let stringValues = ["apple", "banana", "carrot", "durian", "eggplant", "fig", "guava"]
        let concatStrings = await self.cacheClient.listConcatenateBack(
            cacheName: self.integrationTestCacheName,
            listName: listName,
            values: stringValues.map { ScalarType.string($0) }
        )
        XCTAssertTrue(
            concatStrings is CacheListConcatenateBackSuccess,
            "Unexpected response: \(concatStrings)"
        )
        
        // Fetches full list when no slice specified
        let fullList = await self.cacheClient.listFetch(
            cacheName: self.integrationTestCacheName,
            listName: listName
        )
        XCTAssertTrue(
            fullList is CacheListFetchHit,
            "Unexpected response: \(fullList)"
        )
        let fetchedFullList = (fullList as! CacheListFetchHit).valueListString
        XCTAssertEqual(fetchedFullList, stringValues)
        
        // Fetches positive slice range
        let positiveSliceList = await self.cacheClient.listFetch(
            cacheName: self.integrationTestCacheName,
            listName: listName,
            startIndex: 2,
            endIndex: 5
        )
        XCTAssertTrue(
            positiveSliceList is CacheListFetchHit,
            "Unexpected response: \(positiveSliceList)"
        )
        let fetchedPositiveSliceList = (positiveSliceList as! CacheListFetchHit).valueListString
        XCTAssertEqual(fetchedPositiveSliceList, Array(stringValues[2...4]))
        
        // Fetches negative slice range
        let negativeSliceList = await self.cacheClient.listFetch(
            cacheName: self.integrationTestCacheName,
            listName: listName,
            startIndex: 2,
            endIndex: -2
        )
        XCTAssertTrue(
            negativeSliceList is CacheListFetchHit,
            "Unexpected response: \(negativeSliceList)"
        )
        let fetchedNegativeSliceList = (negativeSliceList as! CacheListFetchHit).valueListString
        XCTAssertEqual(fetchedNegativeSliceList, Array(stringValues[2...4]))
        
        // Fetches slice with nil start index
        let nilStart = await self.cacheClient.listFetch(
            cacheName: self.integrationTestCacheName,
            listName: listName,
            startIndex: nil,
            endIndex: 4
        )
        XCTAssertTrue(
            nilStart is CacheListFetchHit,
            "Unexpected response: \(nilStart)"
        )
        let fetchedNilStart = (nilStart as! CacheListFetchHit).valueListString
        XCTAssertEqual(fetchedNilStart, Array(stringValues[0...3]))
        
        // Fetches slice with nil end index
        let nilEnd = await self.cacheClient.listFetch(
            cacheName: self.integrationTestCacheName,
            listName: listName,
            startIndex: 3,
            endIndex: nil
        )
        XCTAssertTrue(
            nilEnd is CacheListFetchHit,
            "Unexpected response: \(nilEnd)"
        )
        let fetchedNilEnd = (nilEnd as! CacheListFetchHit).valueListString
        XCTAssertEqual(fetchedNilEnd, Array(stringValues[3...]))
    }
    
    func testLengthValidatesParameters() async throws {
        let listName = generateStringWithUuid(prefix: "swift-list-length")
        
        // Checks cache name
        let invalidCacheName = await self.cacheClient.listLength(
            cacheName: "   ",
            listName: listName
        )
        XCTAssertTrue(
            invalidCacheName is CacheListLengthError,
            "Unexpected response: \(invalidCacheName)"
        )
        let invalidCacheNameCode = (invalidCacheName as! CacheListLengthError).errorCode
        XCTAssertEqual(
            invalidCacheNameCode, MomentoErrorCode.INVALID_ARGUMENT_ERROR,
            "Unexpected error code: \(invalidCacheNameCode)"
        )
        
        // Checks list name
        let invalidListName = await self.cacheClient.listLength(
            cacheName: self.integrationTestCacheName,
            listName: "   "
        )
        XCTAssertTrue(
            invalidListName is CacheListLengthError,
            "Unexpected response: \(invalidListName)"
        )
        let invalidListNameCode = (invalidListName as! CacheListLengthError).errorCode
        XCTAssertEqual(
            invalidListNameCode, MomentoErrorCode.INVALID_ARGUMENT_ERROR,
            "Unexpected error code: \(invalidListNameCode)"
        )
    }
    
    func testListLength() async throws {
        let listName = generateStringWithUuid(prefix: "swift-list-length")
        let stringValues = ["apple", "banana", "carrot", "durian", "eggplant", "fig", "guava"]
        
        let insert1 = await self.cacheClient.listConcatenateBack(
            cacheName: self.integrationTestCacheName,
            listName: listName,
            values: stringValues[0...3].map { ScalarType.string($0) }
        )
        XCTAssertTrue(
            insert1 is CacheListConcatenateBackSuccess,
            "Unexpected response: \(insert1)"
        )
        
        let fetchLength1 = await self.cacheClient.listLength(
            cacheName: self.integrationTestCacheName,
            listName: listName
        )
        XCTAssertTrue(
            fetchLength1 is CacheListLengthHit,
            "Unexpected response: \(fetchLength1)"
        )
        let length1 = (fetchLength1 as! CacheListLengthHit).length
        XCTAssertEqual(length1, 4)
        
        
        let insert2 = await self.cacheClient.listConcatenateBack(
            cacheName: self.integrationTestCacheName,
            listName: listName,
            values: stringValues[4...].map { ScalarType.string($0) }
        )
        XCTAssertTrue(
            insert2 is CacheListConcatenateBackSuccess,
            "Unexpected response: \(insert2)"
        )
        
        let fetchLength2 = await self.cacheClient.listLength(
            cacheName: self.integrationTestCacheName,
            listName: listName
        )
        XCTAssertTrue(
            fetchLength2 is CacheListLengthHit,
            "Unexpected response: \(fetchLength2)"
        )
        let length2 = (fetchLength2 as! CacheListLengthHit).length
        XCTAssertEqual(length2, 7)
    }
    
    func testPopBackValidatesParameters() async throws {
        let listName = generateStringWithUuid(prefix: "swift-list-pop-back")
        
        // Checks cache name
        let invalidCacheName = await self.cacheClient.listPopBack(
            cacheName: "   ",
            listName: listName
        )
        XCTAssertTrue(
            invalidCacheName is CacheListPopBackError,
            "Unexpected response: \(invalidCacheName)"
        )
        let invalidCacheNameCode = (invalidCacheName as! CacheListPopBackError).errorCode
        XCTAssertEqual(
            invalidCacheNameCode, MomentoErrorCode.INVALID_ARGUMENT_ERROR,
            "Unexpected error code: \(invalidCacheNameCode)"
        )
        
        // Checks list name
        let invalidListName = await self.cacheClient.listPopBack(
            cacheName: self.integrationTestCacheName,
            listName: "   "
        )
        XCTAssertTrue(
            invalidListName is CacheListPopBackError,
            "Unexpected response: \(invalidListName)"
        )
        let invalidListNameCode = (invalidListName as! CacheListPopBackError).errorCode
        XCTAssertEqual(
            invalidListNameCode, MomentoErrorCode.INVALID_ARGUMENT_ERROR,
            "Unexpected error code: \(invalidListNameCode)"
        )
    }
    
    func testPopBack() async throws {
        // Insert some values
        let listName = generateStringWithUuid(prefix: "swift-list-pop-back")
        let stringValues = ["apple", "banana"]
        let concatStrings = await self.cacheClient.listConcatenateBack(
            cacheName: self.integrationTestCacheName,
            listName: listName,
            values: stringValues.map { ScalarType.string($0) }
        )
        XCTAssertTrue(
            concatStrings is CacheListConcatenateBackSuccess,
            "Unexpected response: \(concatStrings)"
        )
        
        // Expecting to receive values in back to front order
        let pop1 = await self.cacheClient.listPopBack(
            cacheName: self.integrationTestCacheName,
            listName: listName
        )
        XCTAssertTrue(
            pop1 is CacheListPopBackHit,
            "Unexpected response: \(pop1)"
        )
        let popValue1 = (pop1 as! CacheListPopBackHit).valueString
        XCTAssertEqual(popValue1, "banana")
        
        let pop2 = await self.cacheClient.listPopBack(
            cacheName: self.integrationTestCacheName,
            listName: listName
        )
        XCTAssertTrue(
            pop2 is CacheListPopBackHit,
            "Unexpected response: \(pop2)"
        )
        let popValue2 = (pop2 as! CacheListPopBackHit).valueString
        XCTAssertEqual(popValue2, "apple")
        
        // Miss when popping from empty list
        let pop3 = await self.cacheClient.listPopBack(
            cacheName: self.integrationTestCacheName,
            listName: listName
        )
        XCTAssertTrue(
            pop3 is CacheListPopBackMiss,
            "Unexpected response: \(pop3)"
        )
    }
    
    func testPopFrontValidatesParameters() async throws {
        let listName = generateStringWithUuid(prefix: "swift-list-pop-front")
        
        // Checks cache name
        let invalidCacheName = await self.cacheClient.listPopFront(
            cacheName: "   ",
            listName: listName
        )
        XCTAssertTrue(
            invalidCacheName is CacheListPopFrontError,
            "Unexpected response: \(invalidCacheName)"
        )
        let invalidCacheNameCode = (invalidCacheName as! CacheListPopFrontError).errorCode
        XCTAssertEqual(
            invalidCacheNameCode, MomentoErrorCode.INVALID_ARGUMENT_ERROR,
            "Unexpected error code: \(invalidCacheNameCode)"
        )
        
        // Checks list name
        let invalidListName = await self.cacheClient.listPopFront(
            cacheName: self.integrationTestCacheName,
            listName: "   "
        )
        XCTAssertTrue(
            invalidListName is CacheListPopFrontError,
            "Unexpected response: \(invalidListName)"
        )
        let invalidListNameCode = (invalidListName as! CacheListPopFrontError).errorCode
        XCTAssertEqual(
            invalidListNameCode, MomentoErrorCode.INVALID_ARGUMENT_ERROR,
            "Unexpected error code: \(invalidListNameCode)"
        )
    }
    
    func testPopFront() async throws {
        // Insert some values
        let listName = generateStringWithUuid(prefix: "swift-list-pop-front")
        let stringValues = ["apple", "banana"]
        let concatStrings = await self.cacheClient.listConcatenateBack(
            cacheName: self.integrationTestCacheName,
            listName: listName,
            values: stringValues.map { ScalarType.string($0) }
        )
        XCTAssertTrue(
            concatStrings is CacheListConcatenateBackSuccess,
            "Unexpected response: \(concatStrings)"
        )
        
        // Expecting to receive values in front to back order
        let pop1 = await self.cacheClient.listPopFront(
            cacheName: self.integrationTestCacheName,
            listName: listName
        )
        XCTAssertTrue(
            pop1 is CacheListPopFrontHit,
            "Unexpected response: \(pop1)"
        )
        let popValue1 = (pop1 as! CacheListPopFrontHit).valueString
        XCTAssertEqual(popValue1, "apple")
        
        let pop2 = await self.cacheClient.listPopFront(
            cacheName: self.integrationTestCacheName,
            listName: listName
        )
        XCTAssertTrue(
            pop2 is CacheListPopFrontHit,
            "Unexpected response: \(pop2)"
        )
        let popValue2 = (pop2 as! CacheListPopFrontHit).valueString
        XCTAssertEqual(popValue2, "banana")
        
        // Miss when popping from empty list
        let pop3 = await self.cacheClient.listPopFront(
            cacheName: self.integrationTestCacheName,
            listName: listName
        )
        XCTAssertTrue(
            pop3 is CacheListPopFrontMiss,
            "Unexpected response: \(pop3)"
        )
    }

    func testPushBackValidatesParameters() async throws {
        let listName = generateStringWithUuid(prefix: "swift-list-push-back")
        
        // Checks cache name
        let invalidCacheName = await self.cacheClient.listPushBack(
            cacheName: "   ",
            listName: listName,
            value: ScalarType.string("abc")
        )
        XCTAssertTrue(
            invalidCacheName is CacheListPushBackError,
            "Unexpected response: \(invalidCacheName)"
        )
        let invalidCacheNameCode = (invalidCacheName as! CacheListPushBackError).errorCode
        XCTAssertEqual(
            invalidCacheNameCode, MomentoErrorCode.INVALID_ARGUMENT_ERROR,
            "Unexpected error code: \(invalidCacheNameCode)"
        )
        
        // Checks list name
        let invalidListName = await self.cacheClient.listPushBack(
            cacheName: self.integrationTestCacheName,
            listName: "   ",
            value: ScalarType.string("abc")
        )
        XCTAssertTrue(
            invalidListName is CacheListPushBackError,
            "Unexpected response: \(invalidListName)"
        )
        let invalidListNameCode = (invalidListName as! CacheListPushBackError).errorCode
        XCTAssertEqual(
            invalidListNameCode, MomentoErrorCode.INVALID_ARGUMENT_ERROR,
            "Unexpected error code: \(invalidListNameCode)"
        )
        
        // Checks truncateFrontToSize
        let invalidTruncateSize = await self.cacheClient.listPushBack(
            cacheName: self.integrationTestCacheName,
            listName: listName,
            value: ScalarType.string("abc"),
            truncateFrontToSize: -5
        )
        XCTAssertTrue(
            invalidTruncateSize is CacheListPushBackError,
            "Unexpected response: \(invalidTruncateSize)"
        )
        let invalidTruncateSizeCode = (invalidTruncateSize as! CacheListPushBackError).errorCode
        XCTAssertEqual(
            invalidTruncateSizeCode, MomentoErrorCode.INVALID_ARGUMENT_ERROR,
            "Unexpected error code: \(invalidTruncateSizeCode)"
        )
        
        // Checks ttl
        let invalidTtl = await self.cacheClient.listPushBack(
            cacheName: self.integrationTestCacheName,
            listName: listName,
            value: ScalarType.string("abc"),
            ttl: TimeInterval.infinity
        )
        XCTAssertTrue(
            invalidTtl is CacheListPushBackError,
            "Unexpected response: \(invalidTtl)"
        )
        let invalidTtlCode = (invalidTtl as! CacheListPushBackError).errorCode
        XCTAssertEqual(
            invalidTtlCode, MomentoErrorCode.INVALID_ARGUMENT_ERROR,
            "Unexpected error code: \(invalidTtlCode)"
        )
    }
    
    func testPushBack() async throws {
        // Pushes string values
        let stringListName = generateStringWithUuid(prefix: "swift-list-push-back-string")
        let stringValues = ["abc", "lmn", "xyz"]
        for value in stringValues {
            let pushBack = await self.cacheClient.listPushBack(
                cacheName: self.integrationTestCacheName,
                listName: stringListName,
                value: ScalarType.string(value),
                truncateFrontToSize: 2
            )
            XCTAssertTrue(
                pushBack is CacheListPushBackSuccess,
                "Unexpected response: \(pushBack)"
            )
        }
        let fetchStringList = await self.cacheClient.listFetch(
            cacheName: self.integrationTestCacheName,
            listName: stringListName
        )
        XCTAssertTrue(
            fetchStringList is CacheListFetchHit,
            "Unexpected response: \(fetchStringList)"
        )
        let fetchedStringList = (fetchStringList as! CacheListFetchHit).valueListString
        XCTAssertEqual(fetchedStringList, Array(stringValues[1...2]))
        
        // Pushes data values
        let dataListName = generateStringWithUuid(prefix: "swift-list-push-back-data")
        let dataValues = [Data("abc".utf8), Data("lmn".utf8), Data("xyz".utf8)]
        for value in dataValues {
            let pushBack = await self.cacheClient.listPushBack(
                cacheName: self.integrationTestCacheName,
                listName: dataListName,
                value: ScalarType.data(value),
                truncateFrontToSize: 2
            )
            XCTAssertTrue(
                pushBack is CacheListPushBackSuccess,
                "Unexpected response: \(pushBack)"
            )
        }
        let fetchDataList = await self.cacheClient.listFetch(
            cacheName: self.integrationTestCacheName,
            listName: dataListName
        )
        XCTAssertTrue(
            fetchDataList is CacheListFetchHit,
            "Unexpected response: \(fetchStringList)"
        )
        let fetchedDataList = (fetchDataList as! CacheListFetchHit).valueListData
        XCTAssertEqual(fetchedDataList, Array(dataValues[1...2]))
    }

    func testPushFrontValidatesParameters() async throws {
        let listName = generateStringWithUuid(prefix: "swift-list-push-front")
        
        // Checks cache name
        let invalidCacheName = await self.cacheClient.listPushFront(
            cacheName: "   ",
            listName: listName,
            value: ScalarType.string("abc")
        )
        XCTAssertTrue(
            invalidCacheName is CacheListPushFrontError,
            "Unexpected response: \(invalidCacheName)"
        )
        let invalidCacheNameCode = (invalidCacheName as! CacheListPushFrontError).errorCode
        XCTAssertEqual(
            invalidCacheNameCode, MomentoErrorCode.INVALID_ARGUMENT_ERROR,
            "Unexpected error code: \(invalidCacheNameCode)"
        )
        
        // Checks list name
        let invalidListName = await self.cacheClient.listPushFront(
            cacheName: self.integrationTestCacheName,
            listName: "   ",
            value: ScalarType.string("abc")
        )
        XCTAssertTrue(
            invalidListName is CacheListPushFrontError,
            "Unexpected response: \(invalidListName)"
        )
        let invalidListNameCode = (invalidListName as! CacheListPushFrontError).errorCode
        XCTAssertEqual(
            invalidListNameCode, MomentoErrorCode.INVALID_ARGUMENT_ERROR,
            "Unexpected error code: \(invalidListNameCode)"
        )
        
        // Checks truncateFrontToSize
        let invalidTruncateSize = await self.cacheClient.listPushFront(
            cacheName: self.integrationTestCacheName,
            listName: listName,
            value: ScalarType.string("abc"),
            truncateBackToSize: -5
        )
        XCTAssertTrue(
            invalidTruncateSize is CacheListPushFrontError,
            "Unexpected response: \(invalidTruncateSize)"
        )
        let invalidTruncateSizeCode = (invalidTruncateSize as! CacheListPushFrontError).errorCode
        XCTAssertEqual(
            invalidTruncateSizeCode, MomentoErrorCode.INVALID_ARGUMENT_ERROR,
            "Unexpected error code: \(invalidTruncateSizeCode)"
        )
        
        // Checks ttl
        let invalidTtl = await self.cacheClient.listPushFront(
            cacheName: self.integrationTestCacheName,
            listName: listName,
            value: ScalarType.string("abc"),
            ttl: TimeInterval.infinity
        )
        XCTAssertTrue(
            invalidTtl is CacheListPushFrontError,
            "Unexpected response: \(invalidTtl)"
        )
        let invalidTtlCode = (invalidTtl as! CacheListPushFrontError).errorCode
        XCTAssertEqual(
            invalidTtlCode, MomentoErrorCode.INVALID_ARGUMENT_ERROR,
            "Unexpected error code: \(invalidTtlCode)"
        )
    }
    
    func testPushFront() async throws {
        // Pushes string values
        let stringListName = generateStringWithUuid(prefix: "swift-list-push-front-string")
        let stringValues = ["abc", "lmn", "xyz"]
        for value in stringValues {
            let pushFront = await self.cacheClient.listPushFront(
                cacheName: self.integrationTestCacheName,
                listName: stringListName,
                value: ScalarType.string(value),
                truncateBackToSize: 2
            )
            XCTAssertTrue(
                pushFront is CacheListPushFrontSuccess,
                "Unexpected response: \(pushFront)"
            )
        }
        let fetchStringList = await self.cacheClient.listFetch(
            cacheName: self.integrationTestCacheName,
            listName: stringListName
        )
        XCTAssertTrue(
            fetchStringList is CacheListFetchHit,
            "Unexpected response: \(fetchStringList)"
        )
        let fetchedStringList = (fetchStringList as! CacheListFetchHit).valueListString
        XCTAssertEqual(fetchedStringList, Array(stringValues[1...2]).reversed())
        
        // Pushes data values
        let dataListName = generateStringWithUuid(prefix: "swift-list-push-front-data")
        let dataValues = [Data("abc".utf8), Data("lmn".utf8), Data("xyz".utf8)]
        for value in dataValues {
            let pushFront = await self.cacheClient.listPushFront(
                cacheName: self.integrationTestCacheName,
                listName: dataListName,
                value: ScalarType.data(value),
                truncateBackToSize: 2
            )
            XCTAssertTrue(
                pushFront is CacheListPushFrontSuccess,
                "Unexpected response: \(pushFront)"
            )
        }
        let fetchDataList = await self.cacheClient.listFetch(
            cacheName: self.integrationTestCacheName,
            listName: dataListName
        )
        XCTAssertTrue(
            fetchDataList is CacheListFetchHit,
            "Unexpected response: \(fetchStringList)"
        )
        let fetchedDataList = (fetchDataList as! CacheListFetchHit).valueListData
        XCTAssertEqual(fetchedDataList, Array(dataValues[1...2]).reversed())
    }
    
    func testRemoveValueValidatesParameters() async throws {
        let listName = generateStringWithUuid(prefix: "swift-list-remove-value")
        
        // Checks cache name
        let invalidCacheName = await self.cacheClient.listRemoveValue(
            cacheName: "   ",
            listName: listName,
            value: ScalarType.string("abc")
        )
        XCTAssertTrue(
            invalidCacheName is CacheListRemoveValueError,
            "Unexpected response: \(invalidCacheName)"
        )
        let invalidCacheNameCode = (invalidCacheName as! CacheListRemoveValueError).errorCode
        XCTAssertEqual(
            invalidCacheNameCode, MomentoErrorCode.INVALID_ARGUMENT_ERROR,
            "Unexpected error code: \(invalidCacheNameCode)"
        )
        
        // Checks list name
        let invalidListName = await self.cacheClient.listRemoveValue(
            cacheName: self.integrationTestCacheName,
            listName: "   ",
            value: ScalarType.string("abc")
        )
        XCTAssertTrue(
            invalidListName is CacheListRemoveValueError,
            "Unexpected response: \(invalidListName)"
        )
        let invalidListNameCode = (invalidListName as! CacheListRemoveValueError).errorCode
        XCTAssertEqual(
            invalidListNameCode, MomentoErrorCode.INVALID_ARGUMENT_ERROR,
            "Unexpected error code: \(invalidListNameCode)"
        )
    }
    
    func testRemoveValue() async throws {
        // Insert some string values
        let stringListName = generateStringWithUuid(prefix: "swift-list-remove-value-string")
        let stringValues = ["apple", "banana", "apple", "apple", "carrot"]
        let concatStrings = await self.cacheClient.listConcatenateBack(
            cacheName: self.integrationTestCacheName,
            listName: stringListName,
            values: stringValues.map { ScalarType.string($0) }
        )
        XCTAssertTrue(
            concatStrings is CacheListConcatenateBackSuccess,
            "Unexpected response: \(concatStrings)"
        )
        
        // Removes all instances of given string
        let remove1 = await self.cacheClient.listRemoveValue(
            cacheName: self.integrationTestCacheName,
            listName: stringListName,
            value: ScalarType.string("apple")
        )
        XCTAssertTrue(
            remove1 is CacheListRemoveValueSuccess,
            "Unexpected response: \(remove1)"
        )
        
        let fetchStringList = await self.cacheClient.listFetch(
            cacheName: self.integrationTestCacheName,
            listName: stringListName
        )
        XCTAssertTrue(
            fetchStringList is CacheListFetchHit,
            "Unexpected response: \(fetchStringList)"
        )
        let fetchedStringList = (fetchStringList as! CacheListFetchHit).valueListString
        let noAppleStrings = stringValues.filter { $0 != "apple"}
        XCTAssertEqual(fetchedStringList, noAppleStrings)
        
        // Removes no elements if given string not found
        let remove2 = await self.cacheClient.listRemoveValue(
            cacheName: self.integrationTestCacheName,
            listName: stringListName,
            value: ScalarType.string("apple")
        )
        XCTAssertTrue(
            remove2 is CacheListRemoveValueSuccess,
            "Unexpected response: \(remove2)"
        )
        
        let fetchStringList2 = await self.cacheClient.listFetch(
            cacheName: self.integrationTestCacheName,
            listName: stringListName
        )
        XCTAssertTrue(
            fetchStringList2 is CacheListFetchHit,
            "Unexpected response: \(fetchStringList2)"
        )
        let fetchedStringList2 = (fetchStringList2 as! CacheListFetchHit).valueListString
        XCTAssertEqual(fetchedStringList2, noAppleStrings)
        
        // Insert some data values
        let dataListName = generateStringWithUuid(prefix: "swift-list-remove-value-data")
        let dataValues = [Data("abc".utf8), Data("lmn".utf8), Data("xyz".utf8), Data("abc".utf8), Data("abc".utf8)]
        let concatData = await self.cacheClient.listConcatenateBack(
            cacheName: self.integrationTestCacheName,
            listName: dataListName,
            values: dataValues.map { ScalarType.data($0) }
        )
        XCTAssertTrue(
            concatData is CacheListConcatenateBackSuccess,
            "Unexpected response: \(concatData)"
        )
        
        // Removes all instances of given data
        let removeData1 = await self.cacheClient.listRemoveValue(
            cacheName: self.integrationTestCacheName,
            listName: dataListName,
            value: ScalarType.data(Data("abc".utf8))
        )
        XCTAssertTrue(
            removeData1 is CacheListRemoveValueSuccess,
            "Unexpected response: \(removeData1)"
        )
        
        let fetchDataList = await self.cacheClient.listFetch(
            cacheName: self.integrationTestCacheName,
            listName: dataListName
        )
        XCTAssertTrue(
            fetchDataList is CacheListFetchHit,
            "Unexpected response: \(fetchDataList)"
        )
        let fetchedDataList = (fetchDataList as! CacheListFetchHit).valueListData
        let noAbcData = dataValues.filter { $0 != Data("abc".utf8)}
        XCTAssertEqual(fetchedDataList, noAbcData)
        
        // Removes no elements if given string not found
        let removeData2 = await self.cacheClient.listRemoveValue(
            cacheName: self.integrationTestCacheName,
            listName: dataListName,
            value: ScalarType.data(Data("abc".utf8))
        )
        XCTAssertTrue(
            removeData2 is CacheListRemoveValueSuccess,
            "Unexpected response: \(removeData2)"
        )
        
        let fetchDataList2 = await self.cacheClient.listFetch(
            cacheName: self.integrationTestCacheName,
            listName: dataListName
        )
        XCTAssertTrue(
            fetchDataList2 is CacheListFetchHit,
            "Unexpected response: \(fetchDataList2)"
        )
        let fetchedDataList2 = (fetchDataList2 as! CacheListFetchHit).valueListData
        XCTAssertEqual(fetchedDataList2, noAbcData)
    }

    func testRetainValidatesParameters() async throws {
        let listName = generateStringWithUuid(prefix: "swift-list-retain")
        
        // Checks cache name
        let invalidCacheName = await self.cacheClient.listRetain(
            cacheName: "   ",
            listName: listName
        )
        XCTAssertTrue(
            invalidCacheName is CacheListRetainError,
            "Unexpected response: \(invalidCacheName)"
        )
        let invalidCacheNameCode = (invalidCacheName as! CacheListRetainError).errorCode
        XCTAssertEqual(
            invalidCacheNameCode, MomentoErrorCode.INVALID_ARGUMENT_ERROR,
            "Unexpected error code: \(invalidCacheNameCode)"
        )
        
        // Checks list name
        let invalidListName = await self.cacheClient.listRetain(
            cacheName: self.integrationTestCacheName,
            listName: "   "
        )
        XCTAssertTrue(
            invalidListName is CacheListRetainError,
            "Unexpected response: \(invalidListName)"
        )
        let invalidListNameCode = (invalidListName as! CacheListRetainError).errorCode
        XCTAssertEqual(
            invalidListNameCode, MomentoErrorCode.INVALID_ARGUMENT_ERROR,
            "Unexpected error code: \(invalidListNameCode)"
        )
        
        // Checks start and end index range
        let invalidSlice = await self.cacheClient.listRetain(
            cacheName: self.integrationTestCacheName,
            listName: listName,
            startIndex: 2,
            endIndex: 1
        )
        XCTAssertTrue(
            invalidSlice is CacheListRetainError,
            "Unexpected response: \(invalidSlice)"
        )
        let invalidSliceCode = (invalidSlice as! CacheListRetainError).errorCode
        XCTAssertEqual(
            invalidSliceCode, MomentoErrorCode.INVALID_ARGUMENT_ERROR,
            "Unexpected error code: \(invalidSliceCode)"
        )
        
        // Checks ttl
        let invalidTtl = await self.cacheClient.listRetain(
            cacheName: self.integrationTestCacheName,
            listName: listName,
            ttl: TimeInterval.infinity
        )
        XCTAssertTrue(
            invalidTtl is CacheListRetainError,
            "Unexpected response: \(invalidTtl)"
        )
        let invalidTtlCode = (invalidTtl as! CacheListRetainError).errorCode
        XCTAssertEqual(
            invalidTtlCode, MomentoErrorCode.INVALID_ARGUMENT_ERROR,
            "Unexpected error code: \(invalidTtlCode)"
        )
    }
    
    func testRetainFullList() async throws {
        // Insert some values
        let listName = generateStringWithUuid(prefix: "swift-list-retain")
        let stringValues = ["apple", "banana", "carrot", "durian", "eggplant", "fig", "guava"]
        let concatStrings = await self.cacheClient.listConcatenateBack(
            cacheName: self.integrationTestCacheName,
            listName: listName,
            values: stringValues.map { ScalarType.string($0) }
        )
        XCTAssertTrue(
            concatStrings is CacheListConcatenateBackSuccess,
            "Unexpected response: \(concatStrings)"
        )
        
        // Retains full list when no slice specified
        let retainFullList = await self.cacheClient.listRetain(
            cacheName: self.integrationTestCacheName,
            listName: listName
        )
        XCTAssertTrue(
            retainFullList is CacheListRetainSuccess,
            "Unexpected response: \(retainFullList)"
        )
        let fetch = await self.cacheClient.listFetch(
            cacheName: self.integrationTestCacheName,
            listName: listName
        )
        XCTAssertTrue(
            fetch is CacheListFetchHit,
            "Unexpected response: \(fetch)"
        )
        let fetchedList = (fetch as! CacheListFetchHit).valueListString
        XCTAssertEqual(fetchedList, stringValues)
    }
    
    func testRetainPositiveSlice() async throws {
        // Insert some values
        let listName = generateStringWithUuid(prefix: "swift-list-retain")
        let stringValues = ["apple", "banana", "carrot", "durian", "eggplant", "fig", "guava"]
        let concatStrings = await self.cacheClient.listConcatenateBack(
            cacheName: self.integrationTestCacheName,
            listName: listName,
            values: stringValues.map { ScalarType.string($0) }
        )
        XCTAssertTrue(
            concatStrings is CacheListConcatenateBackSuccess,
            "Unexpected response: \(concatStrings)"
        )
        
        // Retains positive slice range
        let retainPositiveSlice = await self.cacheClient.listRetain(
            cacheName: self.integrationTestCacheName,
            listName: listName,
            startIndex: 2,
            endIndex: 5
        )
        XCTAssertTrue(
            retainPositiveSlice is CacheListRetainSuccess,
            "Unexpected response: \(retainPositiveSlice)"
        )
        let fetch = await self.cacheClient.listFetch(
            cacheName: self.integrationTestCacheName,
            listName: listName
        )
        XCTAssertTrue(
            fetch is CacheListFetchHit,
            "Unexpected response: \(fetch)"
        )
        let fetchedList = (fetch as! CacheListFetchHit).valueListString
        XCTAssertEqual(fetchedList, Array(stringValues[2...4]))
    }
     
    func testRetainNegativeSlice() async throws {
        // Insert some values
        let listName = generateStringWithUuid(prefix: "swift-list-retain")
        let stringValues = ["apple", "banana", "carrot", "durian", "eggplant", "fig", "guava"]
        let concatStrings = await self.cacheClient.listConcatenateBack(
            cacheName: self.integrationTestCacheName,
            listName: listName,
            values: stringValues.map { ScalarType.string($0) }
        )
        XCTAssertTrue(
            concatStrings is CacheListConcatenateBackSuccess,
            "Unexpected response: \(concatStrings)"
        )
        
        // Retains negative slice range
        let retainsNegativeSlice = await self.cacheClient.listRetain(
            cacheName: self.integrationTestCacheName,
            listName: listName,
            startIndex: 2,
            endIndex: -2
        )
        XCTAssertTrue(
            retainsNegativeSlice is CacheListRetainSuccess,
            "Unexpected response: \(retainsNegativeSlice)"
        )
        let fetch = await self.cacheClient.listFetch(
            cacheName: self.integrationTestCacheName,
            listName: listName
        )
        XCTAssertTrue(
            fetch is CacheListFetchHit,
            "Unexpected response: \(fetch)"
        )
        let fetchedList = (fetch as! CacheListFetchHit).valueListString
        XCTAssertEqual(fetchedList, Array(stringValues[2...4]))
    }
      
    func testRetainSliceWithNilStart() async throws {
        // Insert some values
        let listName = generateStringWithUuid(prefix: "swift-list-retain")
        let stringValues = ["apple", "banana", "carrot", "durian", "eggplant", "fig", "guava"]
        let concatStrings = await self.cacheClient.listConcatenateBack(
            cacheName: self.integrationTestCacheName,
            listName: listName,
            values: stringValues.map { ScalarType.string($0) }
        )
        XCTAssertTrue(
            concatStrings is CacheListConcatenateBackSuccess,
            "Unexpected response: \(concatStrings)"
        )
        
        // Retains slice with nil start index
        let retainsNilStart = await self.cacheClient.listRetain(
            cacheName: self.integrationTestCacheName,
            listName: listName,
            startIndex: nil,
            endIndex: 4
        )
        XCTAssertTrue(
            retainsNilStart is CacheListRetainSuccess,
            "Unexpected response: \(retainsNilStart)"
        )
        let fetch = await self.cacheClient.listFetch(
            cacheName: self.integrationTestCacheName,
            listName: listName
        )
        XCTAssertTrue(
            fetch is CacheListFetchHit,
            "Unexpected response: \(fetch)"
        )
        let fetchedList = (fetch as! CacheListFetchHit).valueListString
        XCTAssertEqual(fetchedList, Array(stringValues[0...3]))
    }
    
    func testRetainSliceWithNilEnd() async throws {
        // Insert some values
        let listName = generateStringWithUuid(prefix: "swift-list-retain")
        let stringValues = ["apple", "banana", "carrot", "durian", "eggplant", "fig", "guava"]
        let concatStrings = await self.cacheClient.listConcatenateBack(
            cacheName: self.integrationTestCacheName,
            listName: listName,
            values: stringValues.map { ScalarType.string($0) }
        )
        XCTAssertTrue(
            concatStrings is CacheListConcatenateBackSuccess,
            "Unexpected response: \(concatStrings)"
        )
        // Retains slice with nil end index
        let retainsNilEnd = await self.cacheClient.listRetain(
            cacheName: self.integrationTestCacheName,
            listName: listName,
            startIndex: 3,
            endIndex: nil
        )
        XCTAssertTrue(
            retainsNilEnd is CacheListRetainSuccess,
            "Unexpected response: \(retainsNilEnd)"
        )
        let fetch = await self.cacheClient.listFetch(
            cacheName: self.integrationTestCacheName,
            listName: listName
        )
        XCTAssertTrue(
            fetch is CacheListFetchHit,
            "Unexpected response: \(fetch)"
        )
        let fetchedList = (fetch as! CacheListFetchHit).valueListString
        XCTAssertEqual(fetchedList, Array(stringValues[3...]))
    }
}
