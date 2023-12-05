import Momento
import Foundation

@available(macOS 10.15, iOS 13, *)
func example_API_InstantiateCacheClient() {
    do {
        let credentialProvider = try CredentialProvider.fromEnvironmentVariable(envVariableName: "MOMENTO_API_KEY")
        let cacheClient = CacheClient(
            configuration: CacheConfigurations.Default.latest(),
            credentialProvider: credentialProvider,
            defaultTtlSeconds: 10
        )
    } catch {
        print("Unable to create cache client: \(error)")
    }
}

@available(macOS 10.15, iOS 13, *)
func example_API_CreateCache(cacheClient: CacheClient, cacheName: String) async {
    let result = await cacheClient.createCache(cacheName: cacheName)
    switch result {
    case is CacheCreateCacheAlreadyExists:
        print("Cache already exists!")
    case is CacheCreateSuccess:
        print("Successfully created the cache!")
    default:
        print("Unable to create the cache")
    }
}

@available(macOS 10.15, iOS 13, *)
func example_API_ListCaches(cacheClient: CacheClient) async {
    let result = await cacheClient.listCaches()
    switch result {
    case let result as CacheListSuccess:
        print("Successfully created fetched list of caches: \(result.caches)")
    default:
        print("Unable to fetch list of caches")
    }
}

@available(macOS 10.15, iOS 13, *)
func example_API_Set(cacheClient: CacheClient, cacheName: String) async {
    let result = await cacheClient.set(
        cacheName: cacheName,
        key: ScalarType.string("key"),
        value: ScalarType.string("value")
    )
    switch result {
    case is CacheSetSuccess:
        print("Successfully set item in the cache")
    default:
        print("Unable to set item in the cache")
    }
}

@available(macOS 10.15, iOS 13, *)
func example_API_Get(cacheClient: CacheClient, cacheName: String) async {
    let result = await cacheClient.get(
        cacheName: cacheName,
        key: ScalarType.string("key")
    )
    switch result {
    case is CacheGetHit:
        print("Cache hit!")
    case is CacheGetMiss:
        print("Cache miss!")
    default:
        print("Unable to get item in the cache")
    }
}

@available(macOS 10.15, iOS 13, *)
func example_API_InstantiateTopicClient() {
    do {
        let credentialProvider = try CredentialProvider.fromEnvironmentVariable(envVariableName: "MOMENTO_API_KEY")
        let topicClient = TopicClient(
            configuration: TopicConfigurations.Default.latest(),
            credentialProvider: credentialProvider
        )
    } catch {
        print("Unable to create topic client: \(error)")
    }
}

@available(macOS 10.15, iOS 13, *)
func example_API_Publish(topicClient: TopicClient, cacheName: String) async {
    let result = await topicClient.publish(
        cacheName: cacheName,
        topicName: "topic",
        value: ScalarType.string("value")
    )
    switch result {
    case is TopicPublishSuccess:
        print("Successfully published message!")
    default:
        print("Unable to publish message")
    }
}

@available(macOS 10.15, iOS 13, *)
func example_API_Subscribe(topicClient: TopicClient, cacheName: String) async {
    let result = await topicClient.subscribe(cacheName: cacheName, topicName: "topic")
    switch result {
    case let result as TopicSubscribeSuccess:
        print("Successfully subscribed to topic!")
        do {
            for try await message in result.subscription {
                print("Received message: \(message)")
            }
        } catch {
            print("Unexpected error while receving message: \(error)")
        }
        
    default:
        print("Unable to publish message")
    }
}

@available(macOS 10.15, iOS 13, *)
func main() async {
    var creds: CredentialProviderProtocol
    do {
        creds = try CredentialProvider.fromEnvironmentVariable(envVariableName: "MOMENTO_API_KEY")
    } catch {
        print("Unexpected error running doc examples: \(error)")
    }
    
    let topicClient = TopicClient(
        configuration: TopicConfigurations.Default.latest(),
        credentialProvider: creds
    )
    
    let cacheClient = CacheClient(
        configuration: CacheConfigurations.Default.latest(),
        credentialProvider: creds,
        defaultTtlSeconds: 10
    )
    
    let cacheName = "doc-example-apis-\(UUID().uuidString)"
    
    example_API_InstantiateCacheClient()
    await example_API_CreateCache(cacheClient: cacheClient, cacheName: cacheName)
    await example_API_ListCaches(cacheClient: cacheClient)
    await example_API_Set(cacheClient: cacheClient, cacheName: cacheName)
    await example_API_Get(cacheClient: cacheClient, cacheName: cacheName)
    
    example_API_InstantiateTopicClient()
    await example_API_Publish(topicClient: topicClient, cacheName: cacheName)
    await example_API_Subscribe(topicClient: topicClient, cacheName: cacheName)
}

if #available(macOS 10.15, iOS 13, *) {
    await main()
} else {
    // Fallback on earlier versions
    print("Unable to run doc examples, requires macOS 10.15 or iOS 13 or above")
}

