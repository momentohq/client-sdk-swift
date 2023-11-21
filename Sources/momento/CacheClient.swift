import Foundation

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
    
    public func listCaches() async -> CacheListResponse {
        return await self.controlClient.listCaches()
    }
    
    public func get(cacheName: String, key: String) async -> CacheGetResponse {
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
    
    public func get(cacheName: String, key: Data) async -> CacheGetResponse {
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
    
    public func set(cacheName: String, key: String, value: String, ttl: TimeInterval? = nil) async -> CacheSetResponse {
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
    
    public func set(cacheName: String, key: Data, value: String, ttl: TimeInterval? = nil) async -> CacheSetResponse {
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
    
    public func set(cacheName: String, key: String, value: Data, ttl: TimeInterval? = nil) async -> CacheSetResponse {
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
    
    public func set(cacheName: String, key: Data, value: Data, ttl: TimeInterval? = nil) async -> CacheSetResponse {
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
}
