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
    ) async -> ListConcatenateBackResponse {
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
    ) async -> ListConcatenateBackResponse {
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
    ) async -> ListConcatenateFrontResponse {
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
    ) async -> ListConcatenateFrontResponse {
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
    ) async -> ListFetchResponse {
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
    ) async -> ListPushBackResponse {
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
    ) async -> ListPushBackResponse {
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
    ) async -> ListPushFrontResponse {
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
    ) async -> ListPushFrontResponse {
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
    ) async -> ListRemoveValueResponse {
        return await listRemoveValue(cacheName: cacheName, listName: listName, value: ScalarType.string(value))
    }
    
    public func listRemoveValue(
        cacheName: String,
        listName: String,
        value: Data
    ) async -> ListRemoveValueResponse {
        return await listRemoveValue(cacheName: cacheName, listName: listName, value: ScalarType.data(value))
    }
    
    public func listRetain(
        cacheName: String,
        listName: String,
        startIndex: Int? = nil,
        endIndex: Int? = nil,
        ttl: CollectionTtl? = nil
    ) async -> ListRetainResponse {
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
     - Returns: `CacheCreateResponse` representing the result of the create cache operation.
     
     Pattern matching can be used to operate on the appropriate subtype.
    ```
     switch response {
     case .error(let err):
        print("Error: \(err)")
     case .success(_):
        print("Success")
     }
    ```
     */
    public func createCache(cacheName: String) async -> CreateCacheResponse {
        do {
            try validateCacheName(cacheName: cacheName)
        } catch let err as SdkError {
            return CreateCacheResponse.error(CreateCacheError(error: err))
        } catch {
            return CreateCacheResponse.error(
                CreateCacheError(error: UnknownError(message: "unexpected error: \(error)"))
            )
        }
        return await self.controlClient.createCache(cacheName: cacheName)
    }
    
    /**
     Deletes a cache and all items in it.
     - Parameter cacheName: name of the cache to be deleted
     - Returns: `DeleteCacheResponse` representing the result of the delete cache operation.
     
     Pattern matching can be used to operate on the appropriate subtype.
     ```
      switch response {
      case .error(let err):
         print("Error: \(err)")
      case .success(_):
         print("Success")
      }
     ```
     */
    public func deleteCache(cacheName: String) async -> DeleteCacheResponse {
        do {
            try validateCacheName(cacheName: cacheName)
        } catch let err as SdkError {
            return DeleteCacheResponse.error(DeleteCacheError(error: err))
        } catch {
            return DeleteCacheResponse.error(
                DeleteCacheError(error: UnknownError(message: "unexpected error: \(error)"))
            )
        }
        return await self.controlClient.deleteCache(cacheName: cacheName)
    }
    
    /**
     Lists all caches.
     - Returns: `ListCachesResponse` representing the result of the list caches operation.
     
     Pattern matching can be used to operate on the appropriate subtype.
     ```
      switch response {
      case .error(let err):
         print("Error: \(err)")
      case .success(let s):
         print("Success: \(s.caches)")
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
     - Returns: `GetResponse` representing the result of the get operation.
     
     Pattern matching can be used to operate on the appropriate subtype.
     ```
      switch response {
      case .error(let err):
         print("Error: \(err)")
      case .miss(_):
         print("Miss")
      case .hit(let hit):
         print("Hit: \(hit.valueString)")
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
     - Returns: `GetResponse` representing the result of the get operation.
     
     Pattern matching can be used to operate on the appropriate subtype.
     ```
      switch response {
      case .error(let err):
         print("Error: \(err)")
      case .miss(_):
         print("Miss")
      case .hit(let hit):
         print("Hit: \(hit.valueData)")
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
     - Returns: `SetResponse` representing the result of the set operation.
     
     Pattern matching can be used to operate on the appropriate subtype.
     ```
      switch response {
      case .error(let err):
         print("Error: \(err)")
      case .success(_):
         print("Success")
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
     - Returns: `SetResponse` representing the result of the set operation.
     
     Pattern matching can be used to operate on the appropriate subtype.
     ```
      switch response {
      case .error(let err):
         print("Error: \(err)")
      case .success(_):
         print("Success")
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
     - Returns: `SetResponse` representing the result of the set operation.
     
     Pattern matching can be used to operate on the appropriate subtype.
     ```
      switch response {
      case .error(let err):
         print("Error: \(err)")
      case .success(_):
         print("Success")
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
     - Returns: `SetResponse` representing the result of the set operation.
     
     Pattern matching can be used to operate on the appropriate subtype.
     ```
      switch response {
      case .error(let err):
         print("Error: \(err)")
      case .success(_):
         print("Success")
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
    
    /**
     Deletes the given key from the cache.
     - Parameters:
        - cacheName: the name of the cache to store the value in
        - key: the key to delete as a String
     - Returns: `DeleteResponse` representing the result of the set operation.
     
     Pattern matching can be used to operate on the appropriate subtype.
     ```
      switch response {
      case .error(let err):
         print("Error: \(err)")
      case .success(_):
         print("Success")
      }
     ```
     */
    public func delete(cacheName: String, key: String) async -> DeleteResponse {
        return await delete(cacheName: cacheName, key: ScalarType.string(key))
    }

    /**
     Deletes the given key from the cache.
     - Parameters:
        - cacheName: the name of the cache to store the value in
        - key: the key to delete as Data
     - Returns: `DeleteResponse` representing the result of the set operation.
     
     Pattern matching can be used to operate on the appropriate subtype.
     ```
      switch response {
      case .error(let err):
         print("Error: \(err)")
      case .success(_):
         print("Success")
      }
     ```
     */
    public func delete(cacheName: String, key: Data) async -> DeleteResponse {
        return await delete(cacheName: cacheName, key: ScalarType.data(key))
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
     - Returns: `ListConcatenateBackResponse` representing the result of the operation.
     
     Pattern matching can be used to operate on the appropriate subtype.
     ```
      switch response {
      case .error(let err):
         print("Error: \(err)")
      case .success(let s):
         print("Success: \(s.listLength)")
      }
     ```
     */
    public func listConcatenateBack(
        cacheName: String,
        listName: String,
        values: [String],
        truncateFrontToSize: Int? = nil,
        ttl: CollectionTtl? =  nil
    ) async -> ListConcatenateBackResponse {
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
     - Returns: `ListConcatenateBackResponse` representing the result of the operation.
     
     Pattern matching can be used to operate on the appropriate subtype.
     ```
      switch response {
      case .error(let err):
         print("Error: \(err)")
      case .success(let s):
         print("Success: \(s.listLength)")
      }
     ```
     */
    public func listConcatenateBack(
        cacheName: String,
        listName: String,
        values: [Data],
        truncateFrontToSize: Int? = nil,
        ttl: CollectionTtl? =  nil
    ) async -> ListConcatenateBackResponse {
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
    ) async -> ListConcatenateBackResponse {
        do {
            try validateCacheName(cacheName: cacheName)
            try validateListName(listName: listName)
            try validateTruncateSize(size: truncateFrontToSize)
            try validateTtl(ttl: ttl?.ttlSeconds())
            try validateListSize(list: values)
        } catch let err as SdkError {
            return ListConcatenateBackResponse.error(ListConcatenateBackError(error: err))
        } catch {
            return ListConcatenateBackResponse.error(
                ListConcatenateBackError(error: UnknownError(
                    message: "unexpected error: \(error)")
                )
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
     - Returns: `ListConcatenateFrontResponse` representing the result of the operation.
     
     Pattern matching can be used to operate on the appropriate subtype.
     ```
      switch response {
      case .error(let err):
         print("Error: \(err)")
      case .success(let s):
         print("Success: \(s.listLength)")
      }
     ```
     */
    public func listConcatenateFront(
        cacheName: String,
        listName: String,
        values: [String],
        truncateBackToSize: Int? = nil,
        ttl: CollectionTtl? = nil
    ) async -> ListConcatenateFrontResponse {
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
     - Returns: `ListConcatenateFrontResponse` representing the result of the operation.
     
     Pattern matching can be used to operate on the appropriate subtype.
     ```
      switch response {
      case .error(let err):
         print("Error: \(err)")
      case .success(let s):
         print("Success: \(s.listLength)")
      }
     ```
     */
    public func listConcatenateFront(
        cacheName: String,
        listName: String,
        values: [Data],
        truncateBackToSize: Int? = nil,
        ttl: CollectionTtl? = nil
    ) async -> ListConcatenateFrontResponse {
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
    ) async -> ListConcatenateFrontResponse {
        do {
            try validateCacheName(cacheName: cacheName)
            try validateListName(listName: listName)
            try validateTruncateSize(size: truncateBackToSize)
            try validateTtl(ttl: ttl?.ttlSeconds())
            try validateListSize(list: values)
        } catch let err as SdkError {
            return ListConcatenateFrontResponse.error(ListConcatenateFrontError(error: err))
        } catch {
            return ListConcatenateFrontResponse.error(
                ListConcatenateFrontError(error: UnknownError(message: "unexpected error: \(error)"))
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
     - Returns: `ListFetchResponse` representing the result of the operation.
     
     Pattern matching can be used to operate on the appropriate subtype.
     ```
      switch response {
      case .error(let err):
         print("Error: \(err)")
      case .miss(_):
         print("Miss")
      case .hit(let hit):
         print("Hit: \(hit.valueListString)")
      }
     ```
     */
    public func listFetch(
        cacheName: String,
        listName: String,
        startIndex: Int? = nil,
        endIndex: Int? = nil
    ) async -> ListFetchResponse {
        do {
            try validateCacheName(cacheName: cacheName)
            try validateListName(listName: listName)
            try validateListSliceStartEnd(startIndex: startIndex, endIndex: endIndex)
        } catch let err as SdkError {
            return ListFetchResponse.error(ListFetchError(error: err))
        } catch {
            return ListFetchResponse.error(
                ListFetchError(error: UnknownError(message: "unexpected error: \(error)"))
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
     - Returns: `ListLengthResponse` representing the result of the operation.
     
     Pattern matching can be used to operate on the appropriate subtype.
     ```
      switch response {
      case .error(let err):
         print("Error: \(err)")
      case .miss(_):
         print("Miss")
      case .hit(let hit):
         print("Hit: \(hit.length)")
      }
     ```
     */
    public func listLength(
        cacheName: String,
        listName: String
    ) async -> ListLengthResponse {
        do {
            try validateCacheName(cacheName: cacheName)
            try validateListName(listName: listName)
        } catch let err as SdkError {
            return ListLengthResponse.error(ListLengthError(error: err))
        } catch {
            return ListLengthResponse.error(
                ListLengthError(error: UnknownError(message: "unexpected error: \(error)"))
            )
        }
        return await self.dataClient.listLength(cacheName: cacheName, listName: listName)
    }
    
    /**
     Gets and removes the last value from the given list.
     - Parameters:
        - cacheName: the name of the cache containing the list
        - listName: the list to get the last element from
     - Returns: `ListPopBackResponse` representing the result of the operation.
     
     Pattern matching can be used to operate on the appropriate subtype.
     ```
      switch response {
      case .error(let err):
         print("Error: \(err)")
      case .miss(_):
         print("Miss")
      case .hit(let hit):
         print("Hit: \(hit.valueString)")
      }
     ```
     */
    public func listPopBack(
        cacheName: String,
        listName: String
    ) async -> ListPopBackResponse {
        do {
            try validateCacheName(cacheName: cacheName)
            try validateListName(listName: listName)
        } catch let err as SdkError {
            return ListPopBackResponse.error(ListPopBackError(error: err))
        } catch {
            return ListPopBackResponse.error(
                ListPopBackError(error: UnknownError(message: "unexpected error: \(error)"))
            )
        }
        return await self.dataClient.listPopBack(cacheName: cacheName, listName: listName)
    }
    
    /**
     Gets and removes the first value from the given list.
     - Parameters:
        - cacheName: the name of the cache containing the list
        - listName: the list to get the first element from
     - Returns: `ListPopFrontResponse` representing the result of the operation.
     
     Pattern matching can be used to operate on the appropriate subtype.
     ```
      switch response {
      case .error(let err):
         print("Error: \(err)")
      case .miss(_):
         print("Miss")
      case .hit(let hit):
         print("Hit: \(hit.valueString)")
      }
     ```
     */
    public func listPopFront(
        cacheName: String,
        listName: String
    ) async -> ListPopFrontResponse {
        do {
            try validateCacheName(cacheName: cacheName)
            try validateListName(listName: listName)
        } catch let err as SdkError {
            return ListPopFrontResponse.error(ListPopFrontError(error: err))
        } catch {
            return ListPopFrontResponse.error(
                ListPopFrontError(error: UnknownError(message: "unexpected error: \(error)"))
            )
        }
        return await self.dataClient.listPopFront(cacheName: cacheName, listName: listName)
    }
    
    /**
     Adds an element to the back of the given list. Creates the list if it does not already exist.
     - Parameters:
        - cacheName: the name of the cache to store the list in
        - listName: the list to add to
        - value: the element to add to the list as String
        - truncateFrontToSize: If the list exceeds this length, remove excess from the front of the list. Must be positive.
        - ttl: refreshes the list's TTL using the client's default if this is not supplied.
     - Returns: `ListPushBackResponse` representing the result of the operation.
     
     Pattern matching can be used to operate on the appropriate subtype.
     ```
      switch response {
      case .error(let err):
         print("Error: \(err)")
      case .success(let s):
         print("Success: \(s.listLength)")
      }
     ```
     */
    public func listPushBack(
        cacheName: String,
        listName: String,
        value: String,
        truncateFrontToSize: Int? = nil,
        ttl: CollectionTtl? = nil
    ) async -> ListPushBackResponse {
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
        - value: the element to add to the list as Data
        - truncateFrontToSize: If the list exceeds this length, remove excess from the front of the list. Must be positive.
        - ttl: refreshes the list's TTL using the client's default if this is not supplied.
     - Returns: `ListPushBackResponse` representing the result of the operation.
     
     Pattern matching can be used to operate on the appropriate subtype.
     ```
      switch response {
      case .error(let err):
         print("Error: \(err)")
      case .success(let s):
         print("Success: \(s.listLength)")
      }
     ```
     */
    public func listPushBack(
        cacheName: String,
        listName: String,
        value: Data,
        truncateFrontToSize: Int? = nil,
        ttl: CollectionTtl? = nil
    ) async -> ListPushBackResponse {
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
    ) async -> ListPushBackResponse {
        do {
            try validateCacheName(cacheName: cacheName)
            try validateListName(listName: listName)
            try validateTruncateSize(size: truncateFrontToSize)
            try validateTtl(ttl: ttl?.ttlSeconds())
        } catch let err as SdkError {
            return ListPushBackResponse.error(ListPushBackError(error: err))
        } catch {
            return ListPushBackResponse.error(
                ListPushBackError(error: UnknownError(message: "unexpected error: \(error)"))
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
        - value: the element to add to the list as String
        - truncateBackToSize: If the list exceeds this length, remove excess from the back of the list. Must be positive.
        - ttl: refreshes the list's TTL using the client's default if this is not supplied.
     - Returns: `ListPushFrontResponse` representing the result of the operation.
     
     Pattern matching can be used to operate on the appropriate subtype.
     ```
      switch response {
      case .error(let err):
         print("Error: \(err)")
      case .success(let s):
         print("Success: \(s.listLength)")
      }
     ```
     */
    public func listPushFront(
        cacheName: String,
        listName: String,
        value: String,
        truncateBackToSize: Int? = nil,
        ttl: CollectionTtl? = nil
    ) async -> ListPushFrontResponse {
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
        - value: the element to add to the list as Data
        - truncateBackToSize: If the list exceeds this length, remove excess from the back of the list. Must be positive.
        - ttl: refreshes the list's TTL using the client's default if this is not supplied.
     - Returns: `ListPushFrontResponse` representing the result of the operation.
     
     Pattern matching can be used to operate on the appropriate subtype.
     ```
      switch response {
      case .error(let err):
         print("Error: \(err)")
      case .success(let s):
         print("Success: \(s.listLength)")
      }
     ```
     */
    public func listPushFront(
        cacheName: String,
        listName: String,
        value: Data,
        truncateBackToSize: Int? = nil,
        ttl: CollectionTtl? = nil
    ) async -> ListPushFrontResponse {
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
    ) async -> ListPushFrontResponse {
        do {
            try validateCacheName(cacheName: cacheName)
            try validateListName(listName: listName)
            try validateTruncateSize(size: truncateBackToSize)
            try validateTtl(ttl: ttl?.ttlSeconds())
        } catch let err as SdkError {
            return ListPushFrontResponse.error(ListPushFrontError(error: err))
        } catch {
            return ListPushFrontResponse.error(
                ListPushFrontError(error: UnknownError(message: "unexpected error: \(error)"))
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
        - value: the value to remove as String
     - Returns: `ListRemoveValueResponse` representing the result of the operation.
     
     Pattern matching can be used to operate on the appropriate subtype.
     ```
      switch response {
      case .error(let err):
         print("Error: \(err)")
      case .success(_):
         print("Success")
      }
     ```
     */
    public func listRemoveValue(
        cacheName: String,
        listName: String,
        value: String
    ) async -> ListRemoveValueResponse {
        return await listRemoveValue(cacheName: cacheName, listName: listName, value: ScalarType.string(value))
    }
    
    /**
     Removes all elements from the given list equal to the given value.
     - Parameters:
        - cacheName: the name of the cache containing the list
        - listName: the list to remove values from
        - value: the value to remove as Data
     - Returns: `ListRemoveValueResponse` representing the result of the operation.
     
     Pattern matching can be used to operate on the appropriate subtype.
     ```
      switch response {
      case .error(let err):
         print("Error: \(err)")
      case .success(_):
         print("Success")
      }
     ```
     */
    public func listRemoveValue(
        cacheName: String,
        listName: String,
        value: Data
    ) async -> ListRemoveValueResponse {
        return await listRemoveValue(cacheName: cacheName, listName: listName, value: ScalarType.data(value))
    }
    
    internal func listRemoveValue(
        cacheName: String,
        listName: String,
        value: ScalarType
    ) async -> ListRemoveValueResponse {
        do {
            try validateCacheName(cacheName: cacheName)
            try validateListName(listName: listName)
        } catch let err as SdkError {
            return ListRemoveValueResponse.error(ListRemoveValueError(error: err))
        } catch {
            return ListRemoveValueResponse.error(
                ListRemoveValueError(error: UnknownError(message: "unexpected error: \(error)"))
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
     - Returns: `ListRetainResponse` representing the result of the operation.
     
     Pattern matching can be used to operate on the appropriate subtype.
     ```
      switch response {
      case .error(let err):
         print("Error: \(err)")
      case .success(_):
         print("Success")
      }
     ```
     */
    public func listRetain(
        cacheName: String,
        listName: String,
        startIndex: Int? = nil,
        endIndex: Int? = nil,
        ttl: CollectionTtl? = nil
    ) async -> ListRetainResponse {
        do {
            try validateCacheName(cacheName: cacheName)
            try validateListName(listName: listName)
            try validateListSliceStartEnd(startIndex: startIndex, endIndex: endIndex)
            try validateTtl(ttl: ttl?.ttlSeconds())
        } catch let err as SdkError {
            return ListRetainResponse.error(ListRetainError(error: err))
        } catch {
            return ListRetainResponse.error(
                ListRetainError(error: UnknownError(message: "unexpected error: \(error)"))
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
