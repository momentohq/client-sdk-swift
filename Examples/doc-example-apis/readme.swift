import Momento

func main() async {
  print("Running Momento Cache example!")
  let cacheName = "example-cache"

  var creds: CredentialProviderProtocol
    do {
        creds = try CredentialProvider.fromEnvironmentVariable(envVariableName: "MOMENTO_API_KEY")
    } catch {
        print("Error establishing credential provider: \(error)")
        return
    }

    let cacheClient = CacheClient(
      configuration: CacheClientConfigurations.iOS.latest(), 
      credentialProvider: creds,
      defaultTtlSeconds: 10
    )

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
    }
}

await main()