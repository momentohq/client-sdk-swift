import XCTest
@testable import momento

final class cacheTests: XCTestCase {
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
        let createResult = await self.cacheClient.createCache(cacheName: "a-totally-new-cache")
        XCTAssertTrue(
            createResult is CacheCreateSuccess,
            "Unexpected response: \(createResult)"
        )
        
        let deleteResult = await self.cacheClient.deleteCache(cacheName: "a-totally-new-cache")
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
        let newCacheName = "a-totally-different-cache"
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
        let invalidCacheName = await self.cacheClient.get(cacheName: "   ", key: "hello")
        XCTAssertTrue(
            invalidCacheName is CacheGetError,
            "Unexpected response: \(invalidCacheName)"
        )
        let invalidCacheNameErrorCode = (invalidCacheName as! CacheGetError).errorCode
        XCTAssertEqual(
            invalidCacheNameErrorCode, MomentoErrorCode.INVALID_ARGUMENT_ERROR,
            "Unexpected error code: \(invalidCacheNameErrorCode)"
        )
        
        let invalidKey = await self.cacheClient.get(cacheName: self.integrationTestCacheName, key: "   ")
        XCTAssertTrue(
            invalidKey is CacheGetError,
            "Unexpected response: \(invalidKey)"
        )
        let invalidKeyErrorCode = (invalidKey as! CacheGetError).errorCode
        XCTAssertEqual(
            invalidKeyErrorCode, MomentoErrorCode.INVALID_ARGUMENT_ERROR,
            "Unexpected error code: \(invalidKeyErrorCode)"
        )
        
        let stringKey = await self.cacheClient.get(cacheName: self.integrationTestCacheName, key: "hello")
        XCTAssertTrue(stringKey is CacheGetMiss, "Unexpected response: \(stringKey)")
        
        let bytesKey = await self.cacheClient.get(
            cacheName: self.integrationTestCacheName,
            key: Data("hello".utf8)
        )
        XCTAssertTrue(bytesKey is CacheGetMiss, "Unexpected response: \(bytesKey)")
    }
    
    func testScalarSet() async throws {
        let invalidCacheName = await self.cacheClient.set(
            cacheName: "   ", 
            key: "hello",
            value: "world",
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
            key: "   ",
            value: "world",
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
        
        let invalidValue = await self.cacheClient.set(
            cacheName: self.integrationTestCacheName,
            key: "hello",
            value: "    ",
            ttl: nil
        )
        XCTAssertTrue(
            invalidValue is CacheSetError,
            "Unexpected response: \(invalidValue)"
        )
        let invalidValueErrorCode = (invalidValue as! CacheSetError).errorCode
        XCTAssertEqual(
            invalidValueErrorCode, MomentoErrorCode.INVALID_ARGUMENT_ERROR,
            "Unexpected error code: \(invalidValueErrorCode)"
        )
        
        let invalidTtl = await self.cacheClient.set(
            cacheName: self.integrationTestCacheName,
            key: "hello",
            value: "world",
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
        
        let stringKeyStringValue = await self.cacheClient.set(
            cacheName: self.integrationTestCacheName,
            key: "hello",
            value: "world",
            ttl: nil
        )
        XCTAssertTrue(
            stringKeyStringValue is CacheSetSuccess,
            "Unexpected response: \(stringKeyStringValue)"
        )
        let getStringKeyStringValue = await self.cacheClient.get(
            cacheName: self.integrationTestCacheName, key: "hello"
        )
        XCTAssertTrue(
            getStringKeyStringValue is CacheGetHit,
            "Unexpected response: \(getStringKeyStringValue)"
        )
        let value1 = (getStringKeyStringValue as! CacheGetHit).valueString
        XCTAssertTrue(value1 == "world")
        
        let stringKeyBytesValue = await self.cacheClient.set(
            cacheName: self.integrationTestCacheName,
            key: "foo",
            value: Data("bar".utf8),
            ttl: nil
        )
        XCTAssertTrue(
            stringKeyBytesValue is CacheSetSuccess,
            "Unexpected response: \(stringKeyBytesValue)"
        )
        let getStringKeyBytesValue = await self.cacheClient.get(
            cacheName: self.integrationTestCacheName, key: "foo"
        )
        XCTAssertTrue(
            getStringKeyBytesValue is CacheGetHit,
            "Unexpected response: \(getStringKeyBytesValue)"
        )
        let value2 = (getStringKeyBytesValue as! CacheGetHit).valueBytes
        XCTAssertTrue(value2 == Data("bar".utf8))
        
        let bytesKeyStringValue = await self.cacheClient.set(
            cacheName: self.integrationTestCacheName,
            key: Data("abc".utf8),
            value: "123",
            ttl: nil
        )
        XCTAssertTrue(
            bytesKeyStringValue is CacheSetSuccess,
            "Unexpected response: \(bytesKeyStringValue)"
        )
        let getBytesKeyStringValue = await self.cacheClient.get(
            cacheName: self.integrationTestCacheName, key: Data("abc".utf8)
        )
        XCTAssertTrue(
            getBytesKeyStringValue is CacheGetHit,
            "Unexpected response: \(getBytesKeyStringValue)"
        )
        let value3 = (getBytesKeyStringValue as! CacheGetHit).valueString
        XCTAssertTrue(value3 == "123")
        
        let bytesKeyBytesValue = await self.cacheClient.set(
            cacheName: self.integrationTestCacheName,
            key: Data("321".utf8),
            value: Data("xyz".utf8),
            ttl: nil
        )
        XCTAssertTrue(
            bytesKeyBytesValue is CacheSetSuccess,
            "Unexpected response: \(bytesKeyBytesValue)"
        )
        let getBytesKeyBytesValue = await self.cacheClient.get(
            cacheName: self.integrationTestCacheName, key: Data("321".utf8)
        )
        XCTAssertTrue(
            getBytesKeyBytesValue is CacheGetHit,
            "Unexpected response: \(getBytesKeyBytesValue)"
        )
        let value4 = (getBytesKeyBytesValue as! CacheGetHit).valueBytes
        XCTAssertTrue(value4 == Data("xyz".utf8))
        
        let shortTtl = await self.cacheClient.set(
            cacheName: self.integrationTestCacheName,
            key: "apple",
            value: "pie",
            ttl: 1
        )
        XCTAssertTrue(
            shortTtl is CacheSetSuccess,
            "Unexpected response: \(shortTtl)"
        )
        try await Task.sleep(nanoseconds: 5_000_000)
        let getShortTtl = await self.cacheClient.get(
            cacheName: self.integrationTestCacheName, key: "apple"
        )
        XCTAssertTrue(
            getShortTtl is CacheGetMiss,
            "Unexpected response: \(getShortTtl)"
        )
    }
}
