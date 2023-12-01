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
    
    /**
     Adds multiple elements to the back of the given list. Creates the list if it does not already exist.
     - Parameters:
        - cacheName: the name of the cache to store the list in
        - listName: the list to add to
        - values: the elements to add to the list
        - truncateFrontToSize: If the list exceeds this length, remove excess from the front of the list. Must be positive.
        - ttl: refreshes the list's TTL using the client's default if this is not supplied.
     - Returns: CacheListConcatenateBackResponse representing the result of the operation.
     Pattern matching can be used to operate on the appropriate subtype.
    ```
     switch response {
     case let responseError as CacheListConcatenateBackError:
        // handle error
     case let responseSuccess as CacheListConcatenateBackSuccess:
        // handle success
     }
    ```
     */
    public func listConcatenateBack(
        cacheName: String,
        listName: String,
        values: [ScalarType],
        truncateFrontToSize: Int? = nil,
        ttl: CollectionTtl? = nil
    ) async -> CacheListConcatenateBackResponse {
        do {
            try validateCacheName(cacheName: cacheName)
            try validateListName(listName: listName)
            try validateTruncateSize(size: truncateFrontToSize)
            try validateTtl(ttl: ttl?.ttlSeconds())
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
    
    /**
     Adds multiple elements to the front of the given list. Creates the list if it does not already exist.
     - Parameters:
        - cacheName: the name of the cache to store the list in
        - listName: the list to add to
        - values: the elements to add to the list
        - truncateBackToSize: If the list exceeds this length, remove excess from the back of the list. Must be positive.
        - ttl: refreshes the list's TTL using the client's default if this is not supplied.
     - Returns: CacheListConcatenateFrontResponse representing the result of the operation.
     Pattern matching can be used to operate on the appropriate subtype.
    ```
     switch response {
     case let responseError as CacheListConcatenateFrontError:
        // handle error
     case let responseSuccess as CacheListConcatenateFrontSuccess:
        // handle success
     }
    ```
     */
    public func listConcatenateFront(
        cacheName: String,
        listName: String,
        values: [ScalarType],
        truncateBackToSize: Int? = nil,
        ttl: CollectionTtl? = nil
    ) async -> CacheListConcatenateFrontResponse {
        do {
            try validateCacheName(cacheName: cacheName)
            try validateListName(listName: listName)
            try validateTruncateSize(size: truncateBackToSize)
            try validateTtl(ttl: ttl?.ttlSeconds())
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
    
    /**
     Fetches all elements of the given list.
     - Parameters:
        - cacheName: the name of the cache containing the list
        - listName: the list to fetch
        - startIndex: start index (inclusive) to begin fetching
        - endIndex: end index (exclusive) to stop fetching
     - Returns: CacheListFetchResponse representing the result of the operation.
     Pattern matching can be used to operate on the appropriate subtype.
    ```
     switch response {
     case let responseError as CacheListFetchError:
        // handle error
     case let responseMiss as CacheListFetchMiss:
        // list does not exist
     case let responseHit as CacheListFetchHit:
        // list exists, handle values
     }
    ```
     */
    public func listFetch(
        cacheName: String,
        listName: String,
        startIndex: Int? = nil,
        endIndex: Int? = nil
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
    
    /**
     Gets the number of elements in the given list.
     - Parameters:
        - cacheName: the name of the cache containing the list
        - listName: the list to get the length of
     - Returns: CacheListLengthResponse representing the result of the operation.
     Pattern matching can be used to operate on the appropriate subtype.
    ```
     switch response {
     case let responseError as CacheListLengthError:
        // handle error
     case let responseMiss as CacheListLengthMiss:
        // list does not exist
     case let responseHit as CacheListLengthHit:
        // list exists, handle length
     }
    ```
     */
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
    
    /**
     Gets and removes the last value from the given list.
     - Parameters:
        - cacheName: the name of the cache containing the list
        - listName: the list to get the last element from
     - Returns: CacheListPopBackResponse representing the result of the operation.
     Pattern matching can be used to operate on the appropriate subtype.
    ```
     switch response {
     case let responseError as CacheListPopBackError:
        // handle error
     case let responseMiss as CacheListPopBackMiss:
        // list does not exist
     case let responseHit as CacheListPopBackHit:
        // list exists, handle value
     }
    ```
     */
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
    
    /**
     Gets and removes the first value from the given list.
     - Parameters:
        - cacheName: the name of the cache containing the list
        - listName: the list to get the first element from
     - Returns: CacheListPopFrontResponse representing the result of the operation.
     Pattern matching can be used to operate on the appropriate subtype.
    ```
     switch response {
     case let responseError as CacheListPopFrontError:
        // handle error
     case let responseMiss as CacheListPopFrontMiss:
        // list does not exist
     case let responseHit as CacheListPopFrontHit:
        // list exists, handle value
     }
    ```
     */
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
    
    /**
     Adds an element to the back of the given list. Creates the list if it does not already exist.
     - Parameters:
        - cacheName: the name of the cache to store the list in
        - listName: the list to add to
        - value: the element to add to the list
        - truncateFrontToSize: If the list exceeds this length, remove excess from the front of the list. Must be positive.
        - ttl: refreshes the list's TTL using the client's default if this is not supplied.
     - Returns: CacheListPushBackResponse representing the result of the operation.
     Pattern matching can be used to operate on the appropriate subtype.
    ```
     switch response {
     case let responseError as CacheListPushBackError:
        // handle error
     case let responseSuccess as CacheListPushBackSuccess:
        // handle success
     }
    ```
     */
    public func listPushBack(
        cacheName: String,
        listName: String,
        value: ScalarType,
        truncateFrontToSize: Int? = nil,
        ttl: CollectionTtl? = nil
    ) async -> CacheListPushBackResponse {
        do {
            try validateCacheName(cacheName: cacheName)
            try validateListName(listName: listName)
            try validateTruncateSize(size: truncateFrontToSize)
            try validateTtl(ttl: ttl?.ttlSeconds())
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
    
    /**
     Adds an element to the front of the given list. Creates the list if it does not already exist.
     - Parameters:
        - cacheName: the name of the cache to store the list in
        - listName: the list to add to
        - value: the element to add to the list
        - truncateBackToSize: If the list exceeds this length, remove excess from the back of the list. Must be positive.
        - ttl: refreshes the list's TTL using the client's default if this is not supplied.
     - Returns: CacheListPushFrontResponse representing the result of the operation.
     Pattern matching can be used to operate on the appropriate subtype.
    ```
     switch response {
     case let responseError as CacheListPushFrontError:
        // handle error
     case let responseSuccess as CacheListPushFrontSuccess:
        // handle success
     }
    ```
     */
    public func listPushFront(
        cacheName: String,
        listName: String,
        value: ScalarType,
        truncateBackToSize: Int? = nil,
        ttl: CollectionTtl? = nil
    ) async -> CacheListPushFrontResponse {
        do {
            try validateCacheName(cacheName: cacheName)
            try validateListName(listName: listName)
            try validateTruncateSize(size: truncateBackToSize)
            try validateTtl(ttl: ttl?.ttlSeconds())
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
    
    /**
     Removes all elements from the given list equal to the given value.
     - Parameters:
        - cacheName: the name of the cache containing the list
        - listName: the list to remove values from
        - value: the value to remove
     - Returns: CacheListRemoveValueResponse representing the result of the operation.
     Pattern matching can be used to operate on the appropriate subtype.
    ```
     switch response {
     case let responseError as CacheListRemoveValueError:
        // handle error
     case let responseSuccess as CacheListRemoveValueSuccess:
        // handle success
     }
    ```
     */
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
    
    /**
     Retains slice of elements of a given list, deletes the rest of the list that isn't being retained.
     - Parameters:
        - cacheName: the name of the cache containing the list
        - listName: the list to retain a slice of
        - startIndex: start index (inclusive) of the slice to retain. Defaults to the start of the list.
        - endIndex: end index (exclusive) of the slice to retain. Defaults to the end of the list.
        - ttl: refreshes the list's TTL using the client's default if this is not supplied.
     - Returns: CacheListRetainResponse representing the result of the operation.
     Pattern matching can be used to operate on the appropriate subtype.
    ```
     switch response {
     case let responseError as CacheListRetainError:
        // handle error
     case let responseSuccess as CacheListRetainSuccess:
        // handle success
     }
    ```
     */
    public func listRetain(
        cacheName: String,
        listName: String,
        startIndex: Int? = nil,
        endIndex: Int? = nil,
        ttl: CollectionTtl? = nil
    ) async -> CacheListRetainResponse {
        do {
            try validateCacheName(cacheName: cacheName)
            try validateListName(listName: listName)
            try validateListSliceStartEnd(startIndex: startIndex, endIndex: endIndex)
            try validateTtl(ttl: ttl?.ttlSeconds())
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
