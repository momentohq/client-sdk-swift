public protocol CacheClientProtocol {
    func createCache(cacheName: String) async -> CacheCreateResponse
    
    func deleteCache(cacheName: String) async -> CacheDeleteResponse
    
    func listCaches() async -> CacheListResponse
}

@available(macOS 10.15, iOS 13, *)
public class CacheClient: CacheClientProtocol {
    private let credentialProvider: CredentialProviderProtocol
    private let configuration: CacheClientConfigurationProtocol
    private let controlClient: ControlClientProtocol
    
    init(
        configuration: CacheClientConfigurationProtocol,
        credentialProvider: CredentialProviderProtocol
    ) {
        // TODO: determine how to handle static logger class
        // LogProvider.setLogger(loggerFactory: configuration.loggerFactory)
        
        self.configuration = configuration
        self.credentialProvider = credentialProvider
        self.controlClient = ControlClient(
            configuration: configuration, 
            credentialProvider: credentialProvider
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
}
