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
            createInvalidName is CreateCacheError,
            "Unexpected response: \(createInvalidName)"
        )
        let createErrorCode = (createInvalidName as! CreateCacheError).errorCode
        XCTAssertEqual(
            createErrorCode, MomentoErrorCode.INVALID_ARGUMENT_ERROR,
            "Unexpected error code: \(createErrorCode)"
        )
        
        let deleteInvalidName = await self.cacheClient.deleteCache(cacheName: "   ")
        XCTAssertTrue(
            deleteInvalidName is DeleteCacheError,
            "Unexpected response: \(deleteInvalidName)"
        )
        let deleteErrorCode = (deleteInvalidName as! DeleteCacheError).errorCode
        XCTAssertEqual(
            deleteErrorCode, MomentoErrorCode.INVALID_ARGUMENT_ERROR,
            "Unexpected error code: \(deleteErrorCode)"
        )
    }
    
    func testCacheClientCreatesAndDeletesCache() async throws {
        let cacheName = generateStringWithUuid(prefix: "a-totally-new-cache")
        let createResult = await self.cacheClient.createCache(cacheName: cacheName)
        XCTAssertTrue(
            createResult is CreateCacheSuccess,
            "Unexpected response: \(createResult)"
        )
        
        let deleteResult = await self.cacheClient.deleteCache(cacheName: cacheName)
        XCTAssertTrue(
            deleteResult is DeleteCacheSuccess,
            "Unexpected response: \(deleteResult)"
        )
    }
    
    func testListCaches() async throws {
        let listResult = await self.cacheClient.listCaches()
        
        // Expect list to include integration test cache
        switch listResult {
        case let listResult as ListCachesSuccess:
            let caches = listResult.caches
            XCTAssertTrue(
                caches.contains(where: {item in
                    item.name == self.integrationTestCacheName
                }),
                "Integration test cache not found in list caches result: \(caches)"
            )
        default:
            XCTAssertTrue(
                listResult is ListCachesSuccess,
                "Unexpected response: \(listResult)"
            )
        }
        
        // Create new cache
        let newCacheName = generateStringWithUuid(prefix: "a-totally-different-cache")
        let createResult = await self.cacheClient.createCache(cacheName: newCacheName)
        XCTAssertTrue(
            createResult is CreateCacheSuccess,
            "Unexpected response: \(createResult)"
        )
        
        // Expect list to include both new cache and integration test cache
        let listResult2 = await self.cacheClient.listCaches()
        switch listResult2 {
        case let listResult2 as ListCachesSuccess:
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
                listResult is ListCachesSuccess,
                "Unexpected response: \(listResult)"
            )
        }
        
        // Clean up additional created cache
        let deleteResult = await self.cacheClient.deleteCache(cacheName: newCacheName)
        XCTAssertTrue(
            deleteResult is DeleteCacheSuccess,
            "Unexpected response: \(deleteResult)"
        )
    }
    
    func testScalarGet() async throws {
        let invalidCacheName = await self.cacheClient.get(
            cacheName: "   ",
            key: ScalarType.string(generateStringWithUuid(prefix: "hello"))
        )
        switch invalidCacheName {
        case .hit(let hit):
            XCTFail("expected error but got \(hit)")
        case .miss(let miss):
            XCTFail("expected error but got \(miss)")
        case .error(let err):
            XCTAssertEqual(
                err.errorCode,
                MomentoErrorCode.INVALID_ARGUMENT_ERROR,
                "Unexpected error code: \(err.errorCode)"
            )
        }

        let invalidKey = await self.cacheClient.get(
            cacheName: self.integrationTestCacheName,
            key: ScalarType.string("   ")
        )
        switch invalidKey {
        case .hit(let hit):
            XCTFail("expected error but got \(hit)")
        case .miss(let miss):
            XCTFail("expected error but got \(miss)")
        case .error(let err):
            XCTAssertEqual(
                err.errorCode,
                MomentoErrorCode.INVALID_ARGUMENT_ERROR,
                "Unexpected error code: \(err.errorCode)"
            )
        }

        let testKey = generateStringWithUuid(prefix: "hello")
        let stringKey = await self.cacheClient.get(
            cacheName: self.integrationTestCacheName,
            key: testKey
        )

        switch stringKey {
        case .hit(let hit):
            XCTFail("expected a miss but got \(hit)")
        case .miss:
            XCTAssertTrue(true)
        case .error(let err):
            XCTFail("expected a miss but got \(err)")
        }

        let bytesKey = await self.cacheClient.get(
            cacheName: self.integrationTestCacheName,
            key: ScalarType.data(Data(testKey.utf8))
        )
        switch bytesKey {
        case .hit(let hit):
            XCTFail("expected a miss but got \(hit)")
        case .miss:
            XCTAssertTrue(true)
        case .error(let err):
            XCTFail("expected a miss but got \(err)")
        }
    }
    
    func testScalarDelete() async throws {
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

    func testScalarSet() async throws {
        let invalidCacheName = await self.cacheClient.set(
            cacheName: "   ", 
            key: "hello",
            value: "world",
            ttl: nil
        )
        switch invalidCacheName {
        case .success(let success):
            XCTFail("expected error but got \(success)")
        case .error(let err):
            XCTAssertEqual(
                err.errorCode,
                MomentoErrorCode.INVALID_ARGUMENT_ERROR,
                "Unexpected error code: \(err.errorCode)"
            )
        }

        let invalidKey = await self.cacheClient.set(
            cacheName: self.integrationTestCacheName,
            key: "   ",
            value: "world",
            ttl: nil
        )
        switch invalidKey {
        case .success(let success):
            XCTFail("expected error but got \(success)")
        case .error(let err):
            XCTAssertEqual(
                err.errorCode,
                MomentoErrorCode.INVALID_ARGUMENT_ERROR,
                "Unexpected error code: \(err.errorCode)"
            )
        }

        let invalidTtl = await self.cacheClient.set(
            cacheName: self.integrationTestCacheName,
            key: "hello",
            value: "world",
            ttl: -5
        )
        switch invalidTtl {
        case .success(let success):
            XCTFail("expected error but got \(success)")
        case .error(let err):
            XCTAssertEqual(
                err.errorCode,
                MomentoErrorCode.INVALID_ARGUMENT_ERROR,
                "Unexpected error code: \(err.errorCode)"
            )
        }

        let testKey1 = generateStringWithUuid(prefix: "hello")
        let testValue1 = "world"
        let stringKeyStringValue = await self.cacheClient.set(
            cacheName: self.integrationTestCacheName,
            key: testKey1,
            value: testValue1,
            ttl: nil
        )
        switch stringKeyStringValue {
        case .error(let err):
            XCTFail("expected success but got \(err)")
        case .success(_):
            XCTAssertTrue(true)
        }
        let getStringKeyStringValue = await self.cacheClient.get(
            cacheName: self.integrationTestCacheName, key: testKey1
        )
        switch getStringKeyStringValue {
        case .hit(let hit):
            XCTAssertEqual(hit.valueString, testValue1)
        case .miss(let miss):
            XCTFail("expected hit but got \(miss)")
        case .error(let err):
            XCTFail("expected hit but got \(err)")
        }
        
        let testKey2 = generateStringWithUuid(prefix: "foo")
        let testValue2 = Data("bar".utf8)
        let stringKeyBytesValue = await self.cacheClient.set(
            cacheName: self.integrationTestCacheName,
            key: testKey2,
            value: testValue2,
            ttl: nil
        )
        switch stringKeyBytesValue {
        case .error(let err):
            XCTFail("expected success but got \(err)")
        case .success(_):
            XCTAssertTrue(true)
        }
        let getStringKeyBytesValue = await self.cacheClient.get(
            cacheName: self.integrationTestCacheName, key: testKey2
        )
        switch getStringKeyBytesValue {
        case .hit(let hit):
            XCTAssertEqual(hit.valueData, testValue2)
        case .miss(let miss):
            XCTFail("expected hit but got \(miss)")
        case .error(let err):
            XCTFail("expected hit but got \(err)")
        }

        let testKey3 = Data(generateStringWithUuid(prefix: "abc").utf8)
        let testValue3 = "123"
        let bytesKeyStringValue = await self.cacheClient.set(
            cacheName: self.integrationTestCacheName,
            key: testKey3,
            value: testValue3,
            ttl: nil
        )
        switch bytesKeyStringValue {
        case .error(let err):
            XCTFail("expected success but got \(err)")
        case .success(_):
            XCTAssertTrue(true)
        }
        let getBytesKeyStringValue = await self.cacheClient.get(
            cacheName: self.integrationTestCacheName, key: testKey3
        )
        switch getBytesKeyStringValue {
        case .hit(let hit):
            XCTAssertEqual(hit.valueString, testValue3)
        case .miss(let miss):
            XCTFail("expected hit but got \(miss)")
        case .error(let err):
            XCTFail("expected hit but got \(err)")
        }

        let testKey4 = Data(generateStringWithUuid(prefix: "321").utf8)
        let testValue4 = Data("xyz".utf8)
        let bytesKeyBytesValue = await self.cacheClient.set(
            cacheName: self.integrationTestCacheName,
            key: testKey4,
            value: testValue4,
            ttl: nil
        )
        switch bytesKeyBytesValue {
        case .error(let err):
            XCTFail("expected success but got \(err)")
        case .success(_):
            XCTAssertTrue(true)
        }
        let getBytesKeyBytesValue = await self.cacheClient.get(
            cacheName: self.integrationTestCacheName, key: testKey4
        )
        switch getBytesKeyBytesValue {
        case .hit(let hit):
            XCTAssertEqual(hit.valueData, testValue4)
        case .miss(let miss):
            XCTFail("expected hit but got \(miss)")
        case .error(let err):
            XCTFail("expected hit but got \(err)")
        }

        let testKey5 = generateStringWithUuid(prefix: "apple")
        let testValue5 = "pie"
        let shortTtl = await self.cacheClient.set(
            cacheName: self.integrationTestCacheName,
            key: testKey5,
            value: testValue5,
            ttl: 1 // ttl = 1 second
        )
        switch shortTtl {
        case .error(let err):
            XCTFail("expected success but got \(err)")
        case .success(_):
            XCTAssertTrue(true)
        }
        
        // sleep for 5 seconds
        try await Task.sleep(nanoseconds: 5_000_000_000)
        
        let getShortTtl = await self.cacheClient.get(
            cacheName: self.integrationTestCacheName, key: testKey5
        )
        switch getShortTtl {
        case .error(let err):
            XCTFail("expected miss but got \(err)")
        case .hit(let hit):
            XCTFail("expected miss but got \(hit)")
        case .miss:
            XCTAssertTrue(true)
        }

        let testKey6 = generateStringWithUuid(prefix: "hello")
        let testValue6 = "world"
        let noTtlSetValue = await self.cacheClient.set(
            cacheName: self.integrationTestCacheName,
            key: testKey6,
            value: testValue6
        )
        switch noTtlSetValue {
        case .error(let err):
            XCTFail("expected success but got \(err)")
        case .success(_):
            XCTAssertTrue(true)
        }
        let getNoTtlValue = await self.cacheClient.get(
            cacheName: self.integrationTestCacheName, key: testKey6
        )
        switch getNoTtlValue {
        case .error(let err):
            XCTFail("expected hit but got \(err)")
        case .miss(let miss):
            XCTFail("expected hit but got \(miss)")
        case .hit(let hit):
            XCTAssertEqual(hit.valueString, testValue6)
        }
    }
}
