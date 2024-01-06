import Momento
import Foundation

@available(macOS 10.15, iOS 13, *)
func example_API_InstantiateCacheClient() {
    do {
        let credentialProvider = try CredentialProvider.fromEnvironmentVariable(envVariableName: "MOMENTO_API_KEY")
        let cacheClient = CacheClient(
            configuration: CacheClientConfigurations.iOS.latest(),
            credentialProvider: credentialProvider,
            defaultTtlSeconds: 10
        )
    } catch {
        print("Unable to create cache client: \(error)")
        exit(1)
    }
}

@available(macOS 10.15, iOS 13, *)
func example_API_CreateCache(cacheClient: CacheClient, cacheName: String) async {
    let result = await cacheClient.createCache(cacheName: cacheName)
    switch result {
    case .alreadyExists(_):
        print("Cache already exists!")
    case .success(_):
        print("Successfully created the cache!")
    case .error(let err):
        print("Unable to create the cache: \(err)")
        exit(1)
    }
}

@available(macOS 10.15, iOS 13, *)
func example_API_ListCaches(cacheClient: CacheClient) async {
    let result = await cacheClient.listCaches()
    switch result {
    case .success(let success):
        print("Successfully fetched list of caches: \(success.caches.map { $0.name })")
    case .error(let err):
        print("Unable to fetch list of caches: \(err)")
        exit(1)
    }
}

@available(macOS 10.15, iOS 13, *)
func example_API_DeleteCache(cacheClient: CacheClient, cacheName: String) async {
    let result = await cacheClient.deleteCache(cacheName: cacheName)
    switch result {
    case .success(let success):
        print("Successfully deleted the cache")
    case .error(let err):
        print("Unable to delete cache: \(err)")
        exit(1)
    }
}

@available(macOS 10.15, iOS 13, *)
func example_API_Set(cacheClient: CacheClient, cacheName: String) async {
    let result = await cacheClient.set(
        cacheName: cacheName,
        key: "key",
        value: "value"
    )
    switch result {
    case .success(_):
        print("Successfully set item in the cache")
    case .error(let err):
        print("Unable to set item in the cache: \(err)")
        exit(1)
    }
}

@available(macOS 10.15, iOS 13, *)
func example_API_Get(cacheClient: CacheClient, cacheName: String) async {
    let result = await cacheClient.get(
        cacheName: cacheName,
        key: "key"
    )
    switch result {
    case .hit(let hit):
        print("Cache hit: \(hit.valueString)")
    case .miss(_):
        print("Cache miss")
    case .error(let err):
        print("Unable to get item in the cache: \(err)")
        exit(1)
    }
}

@available(macOS 10.15, iOS 13, *)
func example_API_Delete(cacheClient: CacheClient, cacheName: String) async {
    let result = await cacheClient.delete(
        cacheName: cacheName,
        key: "key"
    )
    switch result {
    case .success(_):
        print("Successfully deleted item in the cache")
    case .error(let err):
        print("Unable to delete item in the cache: \(err)")
        exit(1)
    }
}

@available(macOS 10.15, iOS 13, *)
func example_API_InstantiateTopicClient() {
    do {
        let credentialProvider = try CredentialProvider.fromEnvironmentVariable(envVariableName: "MOMENTO_API_KEY")
        let topicClient = TopicClient(
            configuration: TopicClientConfigurations.iOS.latest(),
            credentialProvider: credentialProvider
        )
    } catch {
        print("Unable to create topic client: \(error)")
        exit(1)
    }
}

@available(macOS 10.15, iOS 13, *)
func example_API_TopicPublish(topicClient: TopicClient, cacheName: String) async {
    let result = await topicClient.publish(
        cacheName: cacheName,
        topicName: "topic",
        value: "value"
    )
    switch result {
    case .success(_):
        print("Successfully published message!")
    case .error(let err):
        print("Unable to publish message: \(err)")
        exit(1)
    }
}

@available(macOS 10.15, iOS 13, *)
func example_API_TopicSubscribe(topicClient: TopicClient, cacheName: String) async {
    let subscribeResponse = await topicClient.subscribe(cacheName: cacheName, topicName: "topic")
    let subscription = switch subscribeResponse {
        case .error(let err): fatalError("Error subscribing to topic: \(err)")
        case .subscription(let sub): sub
    }

    // unsubscribe in 5 seconds
    Task {
        try await Task.sleep(nanoseconds: 5_000_000_000)
        subscription.unsubscribe()
    }

    // loop over messages as they are received
    for try await item in subscription.stream {
        var value: String = ""
        switch item {
        case .itemText(let textItem):
            value = textItem.value
            print("Subscriber recieved text message: \(value)")
        case .itemBinary(let binaryItem):
            value = String(decoding: binaryItem.value, as: UTF8.self)
            print("Subscriber recieved binary message: \(value)")
        case .error(let err):
            print("Subscriber received error: \(err)")
        }
    }
}

@available(macOS 10.15, iOS 13, *)
func main() async {
    do {
        let creds = try CredentialProvider.fromEnvironmentVariable(envVariableName: "MOMENTO_API_KEY")
        let topicClient = TopicClient(
            configuration: TopicClientConfigurations.iOS.latest(),
            credentialProvider: creds
        )

        let cacheClient = CacheClient(
            configuration: CacheClientConfigurations.iOS.latest(),
            credentialProvider: creds,
            defaultTtlSeconds: 10
        )

        let cacheName = "doc-example-apis-\(UUID().uuidString)"

        example_API_InstantiateCacheClient()
        await example_API_CreateCache(cacheClient: cacheClient, cacheName: cacheName)
        await example_API_ListCaches(cacheClient: cacheClient)
        await example_API_Set(cacheClient: cacheClient, cacheName: cacheName)
        await example_API_Get(cacheClient: cacheClient, cacheName: cacheName)
        await example_API_Delete(cacheClient: cacheClient, cacheName: cacheName)

        example_API_InstantiateTopicClient()
        await example_API_TopicPublish(topicClient: topicClient, cacheName: cacheName)
        await example_API_TopicSubscribe(topicClient: topicClient, cacheName: cacheName)
        
        await example_API_DeleteCache(cacheClient: cacheClient, cacheName: cacheName)
    } catch {
        print("Unexpected error running doc examples: \(error)")
        exit(1)
    }
}

if #available(macOS 10.15, iOS 13, *) {
    await main()
} else {
    // Fallback on earlier versions
    print("Unable to run doc examples, requires macOS 10.15 or iOS 13 or above")
}
