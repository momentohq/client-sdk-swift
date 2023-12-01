import XCTest
@testable import Momento

final class cacheTests: XCTestCase {
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
    
    func testCacheClientValidatesCacheName() async throws {
        let createInvalidName = await self.cacheClient.createCache(cacheName: "   ")
        XCTAssertTrue(
            createInvalidName is CacheCreateError,
            "Unexpected response: \(createInvalidName)"
        )
        let createErrorCode = (createInvalidName as! CacheCreateError).errorCode
        XCTAssertEqual(
            createErrorCode, MomentoErrorCode.INVALID_ARGUMENT_ERROR,
            "Unexpected error code: \(createErrorCode)"
        )
        
        let deleteInvalidName = await self.cacheClient.deleteCache(cacheName: "   ")
        XCTAssertTrue(
            deleteInvalidName is CacheDeleteError,
            "Unexpected response: \(deleteInvalidName)"
        )
        let deleteErrorCode = (deleteInvalidName as! CacheDeleteError).errorCode
        XCTAssertEqual(
            deleteErrorCode, MomentoErrorCode.INVALID_ARGUMENT_ERROR,
            "Unexpected error code: \(deleteErrorCode)"
        )
    }
    
    func testCacheClientCreatesAndDeletesCache() async throws {
        let cacheName = generateStringWithUuid(prefix: "a-totally-new-cache")
        let createResult = await self.cacheClient.createCache(cacheName: cacheName)
        XCTAssertTrue(
            createResult is CacheCreateSuccess,
            "Unexpected response: \(createResult)"
        )
        
        let deleteResult = await self.cacheClient.deleteCache(cacheName: cacheName)
        XCTAssertTrue(
            deleteResult is CacheDeleteSuccess,
            "Unexpected response: \(deleteResult)"
        )
    }
    
    func testListCaches() async throws {
        let listResult = await self.cacheClient.listCaches()
        
        // Expect list to include integration test cache
        switch listResult {
        case let listResult as CacheListSuccess:
            let caches = listResult.caches
            XCTAssertTrue(
                caches.contains(where: {item in
                    item.name == self.integrationTestCacheName
                }),
                "Integration test cache not found in list caches result: \(caches)"
            )
        default:
            XCTAssertTrue(
                listResult is CacheListSuccess,
                "Unexpected response: \(listResult)"
            )
        }
        
        // Create new cache
        let newCacheName = generateStringWithUuid(prefix: "a-totally-different-cache")
        let createResult = await self.cacheClient.createCache(cacheName: newCacheName)
        XCTAssertTrue(
            createResult is CacheCreateSuccess,
            "Unexpected response: \(createResult)"
        )
        
        // Expect list to include both new cache and integration test cache
        let listResult2 = await self.cacheClient.listCaches()
        switch listResult2 {
        case let listResult2 as CacheListSuccess:
            let caches = listResult2.caches
            XCTAssertTrue(
                caches.contains(where: {item in
                    item.name == self.integrationTestCacheName
                }),
                "Integration test cache not found in list caches result: \(caches)"
            )
            XCTAssertTrue(
                caches.contains(where: {item in
                    item.name == newCacheName
                }),
                "Test cache not found in list caches result: \(caches)"
            )
        default:
            XCTAssertTrue(
                listResult is CacheListSuccess,
                "Unexpected response: \(listResult)"
            )
        }
        
        // Clean up additional created cache
        let deleteResult = await self.cacheClient.deleteCache(cacheName: newCacheName)
        XCTAssertTrue(
            deleteResult is CacheDeleteSuccess,
            "Unexpected response: \(deleteResult)"
        )
    }
    
    func testScalarGet() async throws {
        let invalidCacheName = await self.cacheClient.get(
            cacheName: "   ",
            key: ScalarType.string(generateStringWithUuid(prefix: "hello"))
        )
        XCTAssertTrue(
            invalidCacheName is CacheGetError,
            "Unexpected response: \(invalidCacheName)"
        )
        let invalidCacheNameErrorCode = (invalidCacheName as! CacheGetError).errorCode
        XCTAssertEqual(
            invalidCacheNameErrorCode, MomentoErrorCode.INVALID_ARGUMENT_ERROR,
            "Unexpected error code: \(invalidCacheNameErrorCode)"
        )
        
        let invalidKey = await self.cacheClient.get(
            cacheName: self.integrationTestCacheName,
            key: ScalarType.string("   ")
        )
        XCTAssertTrue(
            invalidKey is CacheGetError,
            "Unexpected response: \(invalidKey)"
        )
        let invalidKeyErrorCode = (invalidKey as! CacheGetError).errorCode
        XCTAssertEqual(
            invalidKeyErrorCode, MomentoErrorCode.INVALID_ARGUMENT_ERROR,
            "Unexpected error code: \(invalidKeyErrorCode)"
        )
        
        let testKey = generateStringWithUuid(prefix: "hello")
        
        let stringKey = await self.cacheClient.get(
            cacheName: self.integrationTestCacheName,
            key: ScalarType.string(testKey)
        )
        XCTAssertTrue(stringKey is CacheGetMiss, "Unexpected response: \(stringKey)")
        
        let bytesKey = await self.cacheClient.get(
            cacheName: self.integrationTestCacheName,
            key: ScalarType.data(Data(testKey.utf8))
        )
        XCTAssertTrue(bytesKey is CacheGetMiss, "Unexpected response: \(bytesKey)")
    }
    
    func testScalarSet() async throws {
        let invalidCacheName = await self.cacheClient.set(
            cacheName: "   ", 
            key: ScalarType.string("hello"),
            value: ScalarType.string("world"),
            ttl: nil
        )
        XCTAssertTrue(
            invalidCacheName is CacheSetError,
            "Unexpected response: \(invalidCacheName)"
        )
        let invalidCacheNameErrorCode = (invalidCacheName as! CacheSetError).errorCode
        XCTAssertEqual(
            invalidCacheNameErrorCode, MomentoErrorCode.INVALID_ARGUMENT_ERROR,
            "Unexpected error code: \(invalidCacheNameErrorCode)"
        )
        
        let invalidKey = await self.cacheClient.set(
            cacheName: self.integrationTestCacheName,
            key: ScalarType.string("   "),
            value: ScalarType.string("world"),
            ttl: nil
        )
        XCTAssertTrue(
            invalidKey is CacheSetError,
            "Unexpected response: \(invalidKey)"
        )
        let invalidKeyErrorCode = (invalidKey as! CacheSetError).errorCode
        XCTAssertEqual(
            invalidKeyErrorCode, MomentoErrorCode.INVALID_ARGUMENT_ERROR,
            "Unexpected error code: \(invalidKeyErrorCode)"
        )
        
        let invalidTtl = await self.cacheClient.set(
            cacheName: self.integrationTestCacheName,
            key: ScalarType.string("hello"),
            value: ScalarType.string("world"),
            ttl: -5
        )
        XCTAssertTrue(
            invalidTtl is CacheSetError,
            "Unexpected response: \(invalidTtl)"
        )
        let invalidTtlErrorCode = (invalidTtl as! CacheSetError).errorCode
        XCTAssertEqual(
            invalidTtlErrorCode, MomentoErrorCode.INVALID_ARGUMENT_ERROR,
            "Unexpected error code: \(invalidTtlErrorCode)"
        )
        
        let testKey1 = generateStringWithUuid(prefix: "hello")
        let testValue1 = "world"
        let stringKeyStringValue = await self.cacheClient.set(
            cacheName: self.integrationTestCacheName,
            key: ScalarType.string(testKey1),
            value: ScalarType.string(testValue1),
            ttl: nil
        )
        XCTAssertTrue(
            stringKeyStringValue is CacheSetSuccess,
            "Unexpected response: \(stringKeyStringValue)"
        )
        let getStringKeyStringValue = await self.cacheClient.get(
            cacheName: self.integrationTestCacheName, key: ScalarType.string(testKey1)
        )
        XCTAssertTrue(
            getStringKeyStringValue is CacheGetHit,
            "Unexpected response: \(getStringKeyStringValue)"
        )
        let value1 = (getStringKeyStringValue as! CacheGetHit).valueString
        XCTAssertTrue(value1 == testValue1)
        
        let testKey2 = generateStringWithUuid(prefix: "foo")
        let testValue2 = Data("bar".utf8)
        let stringKeyBytesValue = await self.cacheClient.set(
            cacheName: self.integrationTestCacheName,
            key: ScalarType.string(testKey2),
            value: ScalarType.data(testValue2),
            ttl: nil
        )
        XCTAssertTrue(
            stringKeyBytesValue is CacheSetSuccess,
            "Unexpected response: \(stringKeyBytesValue)"
        )
        let getStringKeyBytesValue = await self.cacheClient.get(
            cacheName: self.integrationTestCacheName, key: ScalarType.string(testKey2)
        )
        XCTAssertTrue(
            getStringKeyBytesValue is CacheGetHit,
            "Unexpected response: \(getStringKeyBytesValue)"
        )
        let value2 = (getStringKeyBytesValue as! CacheGetHit).valueData
        XCTAssertTrue(value2 == testValue2)
        
        let testKey3 = Data(generateStringWithUuid(prefix: "abc").utf8)
        let testValue3 = "123"
        let bytesKeyStringValue = await self.cacheClient.set(
            cacheName: self.integrationTestCacheName,
            key: ScalarType.data(testKey3),
            value: ScalarType.string(testValue3),
            ttl: nil
        )
        XCTAssertTrue(
            bytesKeyStringValue is CacheSetSuccess,
            "Unexpected response: \(bytesKeyStringValue)"
        )
        let getBytesKeyStringValue = await self.cacheClient.get(
            cacheName: self.integrationTestCacheName, key: ScalarType.data(testKey3)
        )
        XCTAssertTrue(
            getBytesKeyStringValue is CacheGetHit,
            "Unexpected response: \(getBytesKeyStringValue)"
        )
        let value3 = (getBytesKeyStringValue as! CacheGetHit).valueString
        XCTAssertTrue(value3 == testValue3)
        
        let testKey4 = Data(generateStringWithUuid(prefix: "321").utf8)
        let testValue4 = Data("xyz".utf8)
        let bytesKeyBytesValue = await self.cacheClient.set(
            cacheName: self.integrationTestCacheName,
            key: ScalarType.data(testKey4),
            value: ScalarType.data(testValue4),
            ttl: nil
        )
        XCTAssertTrue(
            bytesKeyBytesValue is CacheSetSuccess,
            "Unexpected response: \(bytesKeyBytesValue)"
        )
        let getBytesKeyBytesValue = await self.cacheClient.get(
            cacheName: self.integrationTestCacheName, key: ScalarType.data(testKey4)
        )
        XCTAssertTrue(
            getBytesKeyBytesValue is CacheGetHit,
            "Unexpected response: \(getBytesKeyBytesValue)"
        )
        let value4 = (getBytesKeyBytesValue as! CacheGetHit).valueData
        XCTAssertTrue(value4 == testValue4)
        
        let testKey5 = generateStringWithUuid(prefix: "apple")
        let testValue5 = "pie"
        let shortTtl = await self.cacheClient.set(
            cacheName: self.integrationTestCacheName,
            key: ScalarType.string(testKey5),
            value: ScalarType.string(testValue5),
            ttl: 1 // ttl = 1 second
        )
        XCTAssertTrue(
            shortTtl is CacheSetSuccess,
            "Unexpected response: \(shortTtl)"
        )
        
        // sleep for 5 seconds
        try await Task.sleep(nanoseconds: 5_000_000_000)
        
        let getShortTtl = await self.cacheClient.get(
            cacheName: self.integrationTestCacheName, key: ScalarType.string(testKey5)
        )
        XCTAssertTrue(
            getShortTtl is CacheGetMiss,
            "Unexpected response: \(getShortTtl)"
        )

        let testKey6 = generateStringWithUuid(prefix: "hello")
        let testValue6 = "world"
        let noTtlSetValue = await self.cacheClient.set(
            cacheName: self.integrationTestCacheName,
            key: ScalarType.string(testKey6),
            value: ScalarType.string(testValue6)
        )
        XCTAssertTrue(
            noTtlSetValue is CacheSetSuccess,
            "Unexpected response: \(stringKeyStringValue)"
        )
        let getNoTtlValue = await self.cacheClient.get(
            cacheName: self.integrationTestCacheName, key: ScalarType.string(testKey6)
        )
        XCTAssertTrue(
            getNoTtlValue is CacheGetHit,
            "Unexpected response: \(getNoTtlValue)"
        )
        let value6 = (getNoTtlValue as! CacheGetHit).valueString
        XCTAssertTrue(value6 == testValue6)
    }
}
