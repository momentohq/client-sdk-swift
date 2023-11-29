import Foundation

public enum ScalarType {
    case string(String)
    case data(Data)
}

typealias CacheClientProtocol = ControlClientProtocol & DataClientProtocol

@available(macOS 10.15, iOS 13, *)
public class CacheClient: CacheClientProtocol {
    private let credentialProvider: CredentialProviderProtocol
    private let configuration: CacheClientConfigurationProtocol
    private let controlClient: ControlClientProtocol
    private let dataClient: DataClientProtocol
    
    init(
        configuration: CacheClientConfigurationProtocol,
        credentialProvider: CredentialProviderProtocol,
        defaultTtlSeconds: TimeInterval
    ) {
        // TODO: determine how to handle static logger class
        // LogProvider.setLogger(loggerFactory: configuration.loggerFactory)
        
        self.configuration = configuration
        self.credentialProvider = credentialProvider
        self.controlClient = ControlClient(
            configuration: configuration, 
            credentialProvider: credentialProvider
        )
        self.dataClient = DataClient(
            configuration: configuration,
            credentialProvider: credentialProvider,
            defaultTtlSeconds: defaultTtlSeconds
        )
    }
    
    /**
     Creates a cache if it does not exist.
     - Parameter cacheName: name of the cache to be created
     - Returns: CacheCreateResponse representing the result of the create cache operation.
     Pattern matching can be used to operate on the appropriate subtype.
    ```
     switch response {
     case let responseError as CacheCreateError:
        // handle error
     case let responseSuccess as CacheCreateSuccess:
        // handle success
     }
    ```
     */
    public func createCache(cacheName: String) async -> CacheCreateResponse {
        do {
            try validateCacheName(cacheName: cacheName)
        } catch let err as SdkError {
            return CacheCreateError(error: err)
        } catch {
            return CacheCreateError(error: UnknownError(
                message: "unexpected error: \(error)")
            )
        }
        return await self.controlClient.createCache(cacheName: cacheName)
    }
    
    /**
     Deletes a cache and all items in it.
     - Parameter cacheName: name of the cache to be deleted
     - Returns: CacheDeleteResponse representing the result of the delete cache operation.
     Pattern matching can be used to operate on the appropriate subtype.
    ```
     switch response {
     case let responseError as CacheDeleteError:
        // handle error
     case let responseSuccess as CacheDeleteSuccess:
        // handle success
     }
    ```
     */
    public func deleteCache(cacheName: String) async -> CacheDeleteResponse {
        do {
            try validateCacheName(cacheName: cacheName)
        } catch let err as SdkError {
            return CacheDeleteError(error: err)
        } catch {
            return CacheDeleteError(error: UnknownError(
                message: "unexpected error: \(error)")
            )
        }
        return await self.controlClient.deleteCache(cacheName: cacheName)
    }
    
    /**
     Lists all caches.
     - Returns: CacheListResponse representing the result of the list caches operation.
     Pattern matching can be used to operate on the appropriate subtype.
    ```
     switch response {
     case let responseError as CacheListError:
        // handle error
     case let responseSuccess as CacheListSuccess:
        // handle success
        print(responseSuccess.caches)
     }
    ```
     */
    public func listCaches() async -> CacheListResponse {
        return await self.controlClient.listCaches()
    }
    
    /**
     Gets the value stored for the given key.
     - Parameters:
        - cacheName: the name of the cache to perform the lookup in
        - key: the key to look up
     - Returns: CacheGetResponse representing the result of the get operation.
     Pattern matching can be used to operate on the appropriate subtype.
    ```
     switch response {
     case let responseError as CacheGetError:
        // handle error
     case let responseMiss as CacheGetMiss:
        // handle miss
    case let responseHit as CacheGetHit:
        // handle hit
     }
    ```
     */
    public func get(cacheName: String, key: ScalarType) async -> CacheGetResponse {
        do {
            try validateCacheName(cacheName: cacheName)
            try validateCacheKey(key: key)
        } catch let err as SdkError {
            return CacheGetError(error: err)
        } catch {
            return CacheGetError(error: UnknownError(
                message: "unexpected error: \(error)")
            )
        }
        return await self.dataClient.get(cacheName: cacheName, key: key)
    }
    
    /**
     Associates the given key with the given value. If a value for the key is already present it is replaced with the new value.
     - Parameters:
        - cacheName: the name of the cache to store the value in
        - key: the key to set the value for
        - value: the value to associate with the key
        - ttl: the time to live for the item in the cache. Uses the client's default TTL if this is not supplied.
     - Returns: CacheSetResponse representing the result of the set operation.
     Pattern matching can be used to operate on the appropriate subtype.
    ```
     switch response {
     case let responseError as CacheSetError:
        // handle error
     case let responseSuccess as CacheSetSuccess:
        // handle success
     }
    ```
     */
    public func set(
        cacheName: String,
        key: ScalarType,
        value: ScalarType,
        ttl: TimeInterval? = nil
    ) async -> CacheSetResponse {
        do {
            try validateCacheName(cacheName: cacheName)
            try validateCacheKey(key: key)
            try validateCacheValue(value: value)
            try validateTtl(ttl: ttl)
        } catch let err as SdkError {
            return CacheSetError(error: err)
        } catch {
            return CacheSetError(error: UnknownError(
                message: "unexpected error: \(error)")
            )
        }
        return await self.dataClient.set(cacheName: cacheName, key: key, value: value, ttl: ttl)
    }
    
    public func listConcatenateBack(
        cacheName: String,
        listName: String,
        values: [ScalarType],
        truncateFrontToSize: Int? = nil,
        ttl: TimeInterval? = nil
    ) async -> CacheListConcatenateBackResponse {
        do {
            try validateCacheName(cacheName: cacheName)
            try validateListName(listName: listName)
            try validateTtl(ttl: ttl)
        } catch let err as SdkError {
            return CacheListConcatenateBackError(error: err)
        } catch {
            return CacheListConcatenateBackError(error: UnknownError(
                message: "unexpected error: \(error)")
            )
        }
        return await self.dataClient.listConcatenateBack(
            cacheName: cacheName,
            listName: listName,
            values: values,
            truncateFrontToSize: truncateFrontToSize,
            ttl: ttl
        )
    }
    
    public func listConcatenateFront(
        cacheName: String,
        listName: String,
        values: [ScalarType],
        truncateBackToSize: Int? = nil,
        ttl: TimeInterval? = nil
    ) async -> CacheListConcatenateFrontResponse {
        do {
            try validateCacheName(cacheName: cacheName)
            try validateListName(listName: listName)
            try validateTtl(ttl: ttl)
        } catch let err as SdkError {
            return CacheListConcatenateFrontError(error: err)
        } catch {
            return CacheListConcatenateFrontError(error: UnknownError(
                message: "unexpected error: \(error)")
            )
        }
        return await self.dataClient.listConcatenateFront(
            cacheName: cacheName,
            listName: listName,
            values: values,
            truncateBackToSize: truncateBackToSize,
            ttl: ttl
        )
    }
    
    public func listFetch(
        cacheName: String,
        listName: String,
        startIndex: Int?,
        endIndex: Int?
    ) async -> CacheListFetchResponse {
        do {
            try validateCacheName(cacheName: cacheName)
            try validateListName(listName: listName)
            try validateListSliceStartEnd(startIndex: startIndex, endIndex: endIndex)
        } catch let err as SdkError {
            return CacheListFetchError(error: err)
        } catch {
            return CacheListFetchError(error: UnknownError(
                message: "unexpected error: \(error)")
            )
        }
        return await self.dataClient.listFetch(
            cacheName: cacheName,
            listName: listName,
            startIndex: startIndex,
            endIndex: endIndex
        )
    }
    
    public func listLength(
        cacheName: String,
        listName: String
    ) async -> CacheListLengthResponse {
        do {
            try validateCacheName(cacheName: cacheName)
            try validateListName(listName: listName)
        } catch let err as SdkError {
            return CacheListLengthError(error: err)
        } catch {
            return CacheListLengthError(error: UnknownError(
                message: "unexpected error: \(error)")
            )
        }
        return await self.dataClient.listLength(cacheName: cacheName, listName: listName)
    }
    
    public func listPopBack(
        cacheName: String,
        listName: String
    ) async -> CacheListPopBackResponse {
        do {
            try validateCacheName(cacheName: cacheName)
            try validateListName(listName: listName)
        } catch let err as SdkError {
            return CacheListPopBackError(error: err)
        } catch {
            return CacheListPopBackError(error: UnknownError(
                message: "unexpected error: \(error)")
            )
        }
        return await self.dataClient.listPopBack(cacheName: cacheName, listName: listName)
    }
    
    public func listPopFront(
        cacheName: String,
        listName: String
    ) async -> CacheListPopFrontResponse {
        do {
            try validateCacheName(cacheName: cacheName)
            try validateListName(listName: listName)
        } catch let err as SdkError {
            return CacheListPopFrontError(error: err)
        } catch {
            return CacheListPopFrontError(error: UnknownError(
                message: "unexpected error: \(error)")
            )
        }
        return await self.dataClient.listPopFront(cacheName: cacheName, listName: listName)
    }
    
    public func listPushBack(
        cacheName: String,
        listName: String,
        value: ScalarType,
        truncateFrontToSize: Int?,
        ttl: TimeInterval?
    ) async -> CacheListPushBackResponse {
        do {
            try validateCacheName(cacheName: cacheName)
            try validateListName(listName: listName)
            try validateTtl(ttl: ttl)
        } catch let err as SdkError {
            return CacheListPushBackError(error: err)
        } catch {
            return CacheListPushBackError(error: UnknownError(
                message: "unexpected error: \(error)")
            )
        }
        return await self.dataClient.listPushBack(
            cacheName: cacheName,
            listName: listName,
            value: value,
            truncateFrontToSize: truncateFrontToSize,
            ttl: ttl
        )
    }
    
    public func listPushFront(
        cacheName: String,
        listName: String,
        value: ScalarType,
        truncateBackToSize: Int?,
        ttl: TimeInterval?
    ) async -> CacheListPushFrontResponse {
        do {
            try validateCacheName(cacheName: cacheName)
            try validateListName(listName: listName)
            try validateTtl(ttl: ttl)
        } catch let err as SdkError {
            return CacheListPushFrontError(error: err)
        } catch {
            return CacheListPushFrontError(error: UnknownError(
                message: "unexpected error: \(error)")
            )
        }
        return await self.dataClient.listPushFront(
            cacheName: cacheName,
            listName: listName,
            value: value,
            truncateBackToSize: truncateBackToSize,
            ttl: ttl
        )
    }
    
    public func listRemoveValue(
        cacheName: String,
        listName: String,
        value: ScalarType
    ) async -> CacheListRemoveValueResponse {
        do {
            try validateCacheName(cacheName: cacheName)
            try validateListName(listName: listName)
        } catch let err as SdkError {
            return CacheListRemoveValueError(error: err)
        } catch {
            return CacheListRemoveValueError(error: UnknownError(
                message: "unexpected error: \(error)")
            )
        }
        return await self.dataClient.listRemoveValue(
            cacheName: cacheName,
            listName: listName,
            value: value
        )
    }
    
    public func listRetain(
        cacheName: String,
        listName: String,
        startIndex: Int?,
        endIndex: Int?,
        ttl: TimeInterval?
    ) async -> CacheListRetainResponse {
        do {
            try validateCacheName(cacheName: cacheName)
            try validateListName(listName: listName)
            try validateListSliceStartEnd(startIndex: startIndex, endIndex: endIndex)
            try validateTtl(ttl: ttl)
        } catch let err as SdkError {
            return CacheListRetainError(error: err)
        } catch {
            return CacheListRetainError(error: UnknownError(
                message: "unexpected error: \(error)")
            )
        }
        return await self.dataClient.listRetain(
            cacheName: cacheName,
            listName: listName,
            startIndex: startIndex,
            endIndex: endIndex,
            ttl: ttl
        )
    }
}
