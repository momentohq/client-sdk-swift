import Momento
import Foundation

func main() async {
  print("Running Momento Cache example!")
  let cacheName = "example-cache"

  var creds: CredentialProviderProtocol
    do {
        creds = try CredentialProvider.fromEnvironmentVariable(envVariableName: "MOMENTO_API_KEY")
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

    let listResult = await cacheClient.listCaches()
    switch listResult {
    case .success(let success):
        print("Successfully created fetched list of caches: \(success.caches.map { $0.name })")
    case .error(let err):
        print("Unable to fetch list of caches: \(err)")
        exit(1)
    }

    let setResult = await cacheClient.set(
        cacheName: cacheName,
        key: "key",
        value: "value"
    )
    switch setResult {
    case .success(_):
        print("Successfully set item in the cache")
    case .error(let err):
        print("Unable to set item in the cache: \(err)")
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

    let deleteResult = await cacheClient.deleteCache(cacheName: cacheName)
    switch deleteResult {
    case .success(_):
        print("Successfully deleted the cache!")
    case .error(let err):
        print("Unable to delete the cache: \(err)")
        exit(1)
    }
}

await main()