import Foundation

enum ScalarType {
    case string(String)
    case data(Data)
}

// The CacheClient class provides user-friendly, public-facing methods
// with default values for non-required parameters and overloaded functions
// that accept String and Data values directly rather than ScalarTypes

protocol CacheClientProtocol: ControlClientProtocol & DataClientProtocol {}

extension CacheClientProtocol {
    public func get(cacheName: String, key: String) async -> GetResponse {
        return await self.get(cacheName: cacheName, key: ScalarType.string(key))
    }
    
    public func get(cacheName: String, key: Data) async -> GetResponse {
        return await self.get(cacheName: cacheName, key: ScalarType.data(key))
    }
    
    public func set(
        cacheName: String,
        key: String,
        value: String,
        ttl: TimeInterval? = nil
    ) async -> SetResponse {
        return await set(
            cacheName: cacheName,
            key: ScalarType.string(key),
            value: ScalarType.string(value),
            ttl: ttl
        )
    }
    
    public func set(
        cacheName: String,
        key: String,
        value: Data,
        ttl: TimeInterval? = nil
    ) async -> SetResponse {
        return await set(
            cacheName: cacheName,
            key: ScalarType.string(key),
            value: ScalarType.data(value),
            ttl: ttl
        )
    }
    
    public func set(
        cacheName: String,
        key: Data,
        value: String,
        ttl: TimeInterval? = nil
    ) async -> SetResponse {
        return await set(
            cacheName: cacheName,
            key: ScalarType.data(key),
            value: ScalarType.string(value),
            ttl: ttl
        )
    }
    
    public func set(
        cacheName: String,
        key: Data,
        value: Data,
        ttl: TimeInterval? = nil
    ) async -> SetResponse {
        return await set(
            cacheName: cacheName,
            key: ScalarType.data(key),
            value: ScalarType.data(value),
            ttl: ttl
        )
    }
    
    public func delete(cacheName: String, key: String) async -> DeleteResponse {
        return await delete(cacheName: cacheName, key: ScalarType.string(key))
    }

    public func delete(cacheName: String, key: Data) async -> DeleteResponse {
        return await delete(cacheName: cacheName, key: ScalarType.data(key))
    }

    public func listConcatenateBack(
        cacheName: String,
        listName: String,
        values: [String],
        truncateFrontToSize: Int? = nil,
        ttl: CollectionTtl? =  nil
    ) async -> CacheListConcatenateBackResponse {
        return await listConcatenateBack(
            cacheName: cacheName,
            listName: listName,
            values: values.map { ScalarType.string($0) },
            truncateFrontToSize: truncateFrontToSize,
            ttl: ttl
        )
    }
    
    public func listConcatenateBack(
        cacheName: String,
        listName: String,
        values: [Data],
        truncateFrontToSize: Int? = nil,
        ttl: CollectionTtl? =  nil
    ) async -> CacheListConcatenateBackResponse {
        return await listConcatenateBack(
            cacheName: cacheName,
            listName: listName,
            values: values.map { ScalarType.data($0) },
            truncateFrontToSize: truncateFrontToSize,
            ttl: ttl
        )
    }
    
    public func listConcatenateFront(
        cacheName: String,
        listName: String,
        values: [String],
        truncateBackToSize: Int? = nil,
        ttl: CollectionTtl? = nil
    ) async -> CacheListConcatenateFrontResponse {
        return await listConcatenateFront(
            cacheName: cacheName,
            listName: listName,
            values: values.map { ScalarType.string($0) },
            truncateBackToSize: truncateBackToSize,
            ttl: ttl
        )
    }
    
    public func listConcatenateFront(
        cacheName: String,
        listName: String,
        values: [Data],
        truncateBackToSize: Int? = nil,
        ttl: CollectionTtl? = nil
    ) async -> CacheListConcatenateFrontResponse {
        return await listConcatenateFront(
            cacheName: cacheName,
            listName: listName,
            values: values.map { ScalarType.data($0) },
            truncateBackToSize: truncateBackToSize,
            ttl: ttl
        )
    }
    
    public func listFetch(
        cacheName: String,
        listName: String,
        startIndex: Int? = nil,
        endIndex: Int? = nil
    ) async -> CacheListFetchResponse {
        return await listFetch(
            cacheName: cacheName,
            listName: listName,
            startIndex: startIndex,
            endIndex: endIndex
        )
    }
    
    public func listPushBack(
        cacheName: String,
        listName: String,
        value: String,
        truncateFrontToSize: Int? = nil,
        ttl: CollectionTtl? = nil
    ) async -> CacheListPushBackResponse {
        return await listPushBack(
            cacheName: cacheName,
            listName: listName,
            value: ScalarType.string(value),
            truncateFrontToSize: truncateFrontToSize,
            ttl: ttl
        )
    }
    
    public func listPushBack(
        cacheName: String,
        listName: String,
        value: Data,
        truncateFrontToSize: Int? = nil,
        ttl: CollectionTtl? = nil
    ) async -> CacheListPushBackResponse {
        return await listPushBack(
            cacheName: cacheName,
            listName: listName,
            value: ScalarType.data(value),
            truncateFrontToSize: truncateFrontToSize,
            ttl: ttl
        )
    }
    
    public func listPushFront(
        cacheName: String,
        listName: String,
        value: String,
        truncateBackToSize: Int? = nil,
        ttl: CollectionTtl? = nil
    ) async -> CacheListPushFrontResponse {
        return await listPushFront(
            cacheName: cacheName,
            listName: listName,
            value: ScalarType.string(value),
            truncateBackToSize: truncateBackToSize,
            ttl: ttl
        )
    }
    
    public func listPushFront(
        cacheName: String,
        listName: String,
        value: Data,
        truncateBackToSize: Int? = nil,
        ttl: CollectionTtl? = nil
    ) async -> CacheListPushFrontResponse {
        return await listPushFront(
            cacheName: cacheName,
            listName: listName,
            value: ScalarType.data(value),
            truncateBackToSize: truncateBackToSize,
            ttl: ttl
        )
    }
    
    public func listRemoveValue(
        cacheName: String,
        listName: String,
        value: String
    ) async -> CacheListRemoveValueResponse {
        return await listRemoveValue(cacheName: cacheName, listName: listName, value: ScalarType.string(value))
    }
    
    public func listRemoveValue(
        cacheName: String,
        listName: String,
        value: Data
    ) async -> CacheListRemoveValueResponse {
        return await listRemoveValue(cacheName: cacheName, listName: listName, value: ScalarType.data(value))
    }
    
    public func listRetain(
        cacheName: String,
        listName: String,
        startIndex: Int? = nil,
        endIndex: Int? = nil,
        ttl: CollectionTtl? = nil
    ) async -> CacheListRetainResponse {
        return await listRetain(
            cacheName: cacheName,
            listName: listName,
            startIndex: startIndex,
            endIndex: endIndex,
            ttl: ttl
        )
    }
}

/**
 Client to perform operations against Momento Serverless Cache.
 To learn more, see the [Momento Cache developer documentation](https://docs.momentohq.com/cache)
 */
@available(macOS 10.15, iOS 13, *)
public class CacheClient: CacheClientProtocol {
    private let credentialProvider: CredentialProviderProtocol
    private let configuration: CacheClientConfigurationProtocol
    private let controlClient: ControlClientProtocol
    private let dataClient: DataClientProtocol
    
    /**
     Constructs the client to perform operations against Momento Serverless Cache.
     - Parameters:
        - configuration: CacheClient configuration object specifying grpc transport strategy and other settings
        - credentialProvider: provides the Momento API key, which you can create in the [Momento Web Console](https://console.gomomento.com/api-keys)
        - defaultTtlSeconds: default time to live for the item in cache
     */
    public init(
        configuration: CacheClientConfigurationProtocol,
        credentialProvider: CredentialProviderProtocol,
        defaultTtlSeconds: TimeInterval
    ) {
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
    public func createCache(cacheName: String) async -> CreateCacheResponse {
        do {
            try validateCacheName(cacheName: cacheName)
        } catch let err as SdkError {
            return CreateCacheError(error: err)
        } catch {
            return CreateCacheError(error: UnknownError(
                message: "unexpected error: \(error)")
            )
        }
        return await self.controlClient.createCache(cacheName: cacheName)
    }
    
    /**
     Deletes a cache and all items in it.
     - Parameter cacheName: name of the cache to be deleted
     - Returns: DeleteCacheResponse representing the result of the delete cache operation.
     Pattern matching can be used to operate on the appropriate subtype.
    ```
     switch response {
     case let responseError as DeleteCacheError:
        // handle error
     case let responseSuccess as DeleteCacheSuccess:
        // handle success
     }
    ```
     */
    public func deleteCache(cacheName: String) async -> DeleteCacheResponse {
        do {
            try validateCacheName(cacheName: cacheName)
        } catch let err as SdkError {
            return DeleteCacheError(error: err)
        } catch {
            return DeleteCacheError(error: UnknownError(
                message: "unexpected error: \(error)")
            )
        }
        return await self.controlClient.deleteCache(cacheName: cacheName)
    }
    
    /**
     Lists all caches.
     - Returns: ListCachesResponse representing the result of the list caches operation.
     Pattern matching can be used to operate on the appropriate subtype.
    ```
     switch response {
     case let responseError as ListCachesError:
        // handle error
     case let responseSuccess as ListCachesSuccess:
        // handle success
        print(responseSuccess.caches)
     }
    ```
     */
    public func listCaches() async -> ListCachesResponse {
        return await self.controlClient.listCaches()
    }
    
    /**
     Gets the value stored for the given key.
     - Parameters:
        - cacheName: the name of the cache to perform the lookup in
        - key: the key to look up as type String
     - Returns: GetResponse representing the result of the get operation.
     Pattern matching can be used to operate on the appropriate subtype.
    ```
     switch response {
     case let responseError as GetError:
        // handle error
     case let responseMiss as GetMiss:
        // handle miss
     case let responseHit as GetHit:
        // handle hit
     }
    ```
     */
    public func get(cacheName: String, key: String) async -> GetResponse {
        return await self.get(cacheName: cacheName, key: ScalarType.string(key))
    }
    
    /**
     Gets the value stored for the given key.
     - Parameters:
        - cacheName: the name of the cache to perform the lookup in
        - key: the key to look up as type Data
     - Returns: GetResponse representing the result of the get operation.
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
    public func get(cacheName: String, key: Data) async -> GetResponse {
        return await self.get(cacheName: cacheName, key: ScalarType.data(key))
    }
    
    internal func get(cacheName: String, key: ScalarType) async -> GetResponse {
        do {
            try validateCacheName(cacheName: cacheName)
            try validateCacheKey(key: key)
        } catch let err as SdkError {
            return GetResponse.error(GetError(error: err))
        } catch {
            return GetResponse.error(GetError(error: UnknownError(
                message: "unexpected error: \(error)")
            ))
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
     - Returns: SetResponse representing the result of the set operation.
     Pattern matching can be used to operate on the appropriate subtype.
    ```
     switch response {
     case let responseError as SetError:
        // handle error
     case let responseSuccess as SetSuccess:
        // handle success
     }
    ```
     */
    public func set(
        cacheName: String,
        key: String,
        value: String,
        ttl: TimeInterval? = nil
    ) async -> SetResponse {
        return await set(
            cacheName: cacheName,
            key: ScalarType.string(key),
            value: ScalarType.string(value),
            ttl: ttl
        )
    }
    
    /**
     Associates the given key with the given value. If a value for the key is already present it is replaced with the new value.
     - Parameters:
        - cacheName: the name of the cache to store the value in
        - key: the key to set the value for
        - value: the value to associate with the key
        - ttl: the time to live for the item in the cache. Uses the client's default TTL if this is not supplied.
     - Returns: SetResponse representing the result of the set operation.
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
        key: String,
        value: Data,
        ttl: TimeInterval? = nil
    ) async -> SetResponse {
        return await set(
            cacheName: cacheName,
            key: ScalarType.string(key),
            value: ScalarType.data(value),
            ttl: ttl
        )
    }
    
    /**
     Associates the given key with the given value. If a value for the key is already present it is replaced with the new value.
     - Parameters:
        - cacheName: the name of the cache to store the value in
        - key: the key to set the value for
        - value: the value to associate with the key
        - ttl: the time to live for the item in the cache. Uses the client's default TTL if this is not supplied.
     - Returns: SetResponse representing the result of the set operation.
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
        key: Data,
        value: String,
        ttl: TimeInterval? = nil
    ) async -> SetResponse {
        return await set(
            cacheName: cacheName,
            key: ScalarType.data(key),
            value: ScalarType.string(value),
            ttl: ttl
        )
    }
    
    /**
     Associates the given key with the given value. If a value for the key is already present it is replaced with the new value.
     - Parameters:
        - cacheName: the name of the cache to store the value in
        - key: the key to set the value for
        - value: the value to associate with the key
        - ttl: the time to live for the item in the cache. Uses the client's default TTL if this is not supplied.
     - Returns: SetResponse representing the result of the set operation.
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
        key: Data,
        value: Data,
        ttl: TimeInterval? = nil
    ) async -> SetResponse {
        return await set(
            cacheName: cacheName,
            key: ScalarType.data(key),
            value: ScalarType.data(value),
            ttl: ttl
        )
    }
    
    internal func set(
        cacheName: String,
        key: ScalarType,
        value: ScalarType,
        ttl: TimeInterval? = nil
    ) async -> SetResponse {
        do {
            try validateCacheName(cacheName: cacheName)
            try validateCacheKey(key: key)
            try validateTtl(ttl: ttl)
        } catch let err as SdkError {
            return SetResponse.error(SetError(error: err))
        } catch {
            return SetResponse.error(SetError(error: UnknownError(
                message: "unexpected error: \(error)")
            ))
        }
        return await self.dataClient.set(
            cacheName: cacheName,
            key: key,
            value: value,
            ttl: ttl
        )
    }
    
    internal func delete(cacheName: String, key: ScalarType) async -> DeleteResponse {
        do {
            try validateCacheName(cacheName: cacheName)
            try validateCacheKey(key: key)
        } catch let err as SdkError {
            return DeleteResponse.error(DeleteError(error: err))
        } catch {
            return DeleteResponse.error(DeleteError(error: UnknownError(
                message: "unexpected error: \(error)")
            ))
        }
        return await self.dataClient.delete(cacheName: cacheName, key: key)
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
        values: [String],
        truncateFrontToSize: Int? = nil,
        ttl: CollectionTtl? =  nil
    ) async -> CacheListConcatenateBackResponse {
        return await listConcatenateBack(
            cacheName: cacheName,
            listName: listName,
            values: values.map { ScalarType.string($0) },
            truncateFrontToSize: truncateFrontToSize,
            ttl: ttl
        )
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
        values: [Data],
        truncateFrontToSize: Int? = nil,
        ttl: CollectionTtl? =  nil
    ) async -> CacheListConcatenateBackResponse {
        return await listConcatenateBack(
            cacheName: cacheName,
            listName: listName,
            values: values.map { ScalarType.data($0) },
            truncateFrontToSize: truncateFrontToSize,
            ttl: ttl
        )
    }
    
    internal func listConcatenateBack(
        cacheName: String,
        listName: String,
        values: [ScalarType],
        truncateFrontToSize: Int? = nil,
        ttl: CollectionTtl? =  nil
    ) async -> CacheListConcatenateBackResponse {
        do {
            try validateCacheName(cacheName: cacheName)
            try validateListName(listName: listName)
            try validateTruncateSize(size: truncateFrontToSize)
            try validateTtl(ttl: ttl?.ttlSeconds())
            try validateListSize(list: values)
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
        values: [String],
        truncateBackToSize: Int? = nil,
        ttl: CollectionTtl? = nil
    ) async -> CacheListConcatenateFrontResponse {
        return await listConcatenateFront(
            cacheName: cacheName,
            listName: listName,
            values: values.map { ScalarType.string($0) },
            truncateBackToSize: truncateBackToSize,
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
        values: [Data],
        truncateBackToSize: Int? = nil,
        ttl: CollectionTtl? = nil
    ) async -> CacheListConcatenateFrontResponse {
        return await listConcatenateFront(
            cacheName: cacheName,
            listName: listName,
            values: values.map { ScalarType.data($0) },
            truncateBackToSize: truncateBackToSize,
            ttl: ttl
        )
    }
    
    internal func listConcatenateFront(
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
            try validateListSize(list: values)
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
        value: String,
        truncateFrontToSize: Int? = nil,
        ttl: CollectionTtl? = nil
    ) async -> CacheListPushBackResponse {
        return await listPushBack(
            cacheName: cacheName,
            listName: listName,
            value: ScalarType.string(value),
            truncateFrontToSize: truncateFrontToSize,
            ttl: ttl
        )
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
        value: Data,
        truncateFrontToSize: Int? = nil,
        ttl: CollectionTtl? = nil
    ) async -> CacheListPushBackResponse {
        return await listPushBack(
            cacheName: cacheName,
            listName: listName,
            value: ScalarType.data(value),
            truncateFrontToSize: truncateFrontToSize,
            ttl: ttl
        )
    }
    
    internal func listPushBack(
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
        value: String,
        truncateBackToSize: Int? = nil,
        ttl: CollectionTtl? = nil
    ) async -> CacheListPushFrontResponse {
        return await listPushFront(
            cacheName: cacheName,
            listName: listName,
            value: ScalarType.string(value),
            truncateBackToSize: truncateBackToSize,
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
        value: Data,
        truncateBackToSize: Int? = nil,
        ttl: CollectionTtl? = nil
    ) async -> CacheListPushFrontResponse {
        return await listPushFront(
            cacheName: cacheName,
            listName: listName,
            value: ScalarType.data(value),
            truncateBackToSize: truncateBackToSize,
            ttl: ttl
        )
    }
    
    internal func listPushFront(
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
        value: String
    ) async -> CacheListRemoveValueResponse {
        return await listRemoveValue(cacheName: cacheName, listName: listName, value: ScalarType.string(value))
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
        value: Data
    ) async -> CacheListRemoveValueResponse {
        return await listRemoveValue(cacheName: cacheName, listName: listName, value: ScalarType.data(value))
    }
    
    internal func listRemoveValue(
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
