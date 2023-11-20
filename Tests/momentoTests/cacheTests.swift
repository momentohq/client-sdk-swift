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
}
