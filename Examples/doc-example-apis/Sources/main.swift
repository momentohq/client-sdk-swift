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
    }
}

@available(macOS 10.15, iOS 13, *)
func example_API_ListCaches(cacheClient: CacheClient) async {
    let result = await cacheClient.listCaches()
    switch result {
    case .success(let success):
        print("Successfully created fetched list of caches: \(success.caches.map { $0.name })")
    case .error(let err):
        print("Unable to fetch list of caches: \(err)")
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
    }
}

@available(macOS 10.15, iOS 13, *)
func example_API_Publish(topicClient: TopicClient, cacheName: String) async {
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
    }
}

@available(macOS 10.15, iOS 13, *)
func example_API_Subscribe(topicClient: TopicClient, cacheName: String) async {
    let result = await topicClient.subscribe(cacheName: cacheName, topicName: "topic")
    switch result {
    case .subscription(let subscription):
        print("Successfully subscribed to topic!")
        do {
            for try await message in subscription.stream {
                print("Received message: \(message)")
            }
        } catch {
            print("Unexpected error while receving message: \(error)")
        }

    case.error(let err):
        print("Unable to subscribe to topic: \(err)")
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
        await example_API_Publish(topicClient: topicClient, cacheName: cacheName)

        // make sure to timeout, else this example will cause the program to hang
        let subscribeTask = Task {
            await example_API_Subscribe(topicClient: topicClient, cacheName: cacheName)
        }
        // timeout in 3 seconds
        let timeoutTask = Task {
            try await Task.sleep(nanoseconds: 3_000_000_000)
            subscribeTask.cancel()
        }
        await withTaskCancellationHandler {
            await subscribeTask.value
            timeoutTask.cancel()
            return
        } onCancel: {
            subscribeTask.cancel()
            timeoutTask.cancel()
        }
        
        await example_API_DeleteCache(cacheClient: cacheClient, cacheName: cacheName)
    } catch {
        print("Unexpected error running doc examples: \(error)")
    }
}

if #available(macOS 10.15, iOS 13, *) {
    await main()
} else {
    // Fallback on earlier versions
    print("Unable to run doc examples, requires macOS 10.15 or iOS 13 or above")
}
