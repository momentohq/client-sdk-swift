import Foundation
import Momento

func main() async {
    print("Running Momento Cache example!")
    let cacheName = "example-cache"

    var creds: CredentialProviderProtocol
    do {
        creds = try CredentialProvider.fromEnvironmentVariablesV2()
    } catch {
        print("Error establishing credential provider: \(error)")
        exit(1)
    }

    let cacheClient = CacheClient(
        configuration: CacheClientConfigurations.iOS.latest(),
        credentialProvider: creds,
        defaultTtlSeconds: 10
    )

    let createResult = await cacheClient.createCache(cacheName: cacheName)
    switch createResult {
    case .alreadyExists(_):
        print("Cache already exists!")
    case .success(_):
        print("Successfully created the cache!")
    case .error(let err):
        print("Unable to create the cache: \(err)")
        exit(1)
    }

    let getResult = await cacheClient.get(
        cacheName: cacheName,
        key: "key"
    )
    switch getResult {
    case .hit(let hit):
        print("Cache hit: \(hit.valueString)")
    case .miss(_):
        print("Cache miss")
    case .error(let err):
        print("Unable to get item in the cache: \(err)")
        exit(1)
    }
}

await main()
