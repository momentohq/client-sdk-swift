import Foundation
@testable import Momento

let apiKeyEnvVarName = "TEST_API_KEY"

struct TestSetup {
    var cacheName: String
    var cacheClient: CacheClientProtocol
    var topicClient: TopicClientProtocol
}

func setUpIntegrationTests() async -> TestSetup {
    do {
        let creds = try CredentialProvider.fromEnvironmentVariable(envVariableName: apiKeyEnvVarName)
        
        let topicClient = TopicClient(
            configuration: TopicClientConfigurations.iOS.latest(),
            credentialProvider: creds
        )

        let cacheClient = CacheClient(
            configuration: CacheClientConfigurations.iOS.latest().withClientTimeout(timeout: 30),
            credentialProvider: creds,
            defaultTtlSeconds: 10
        )
        
        let cacheName = generateStringWithUuid(prefix: "swift-test")
        let result = await cacheClient.createCache(cacheName: cacheName)
        switch result {
        case .error(let err):
            fatalError("Unable to create integration test cache: \(err)")
        default:
            break
        }

        return TestSetup(
            cacheName: cacheName,
            cacheClient: cacheClient,
            topicClient:  topicClient
        )
    } catch {
        fatalError("Unable to setup integration tests: \(error)")
    }
}

func cleanUpIntegrationTests(cacheName: String, cacheClient: CacheClientProtocol) async {
    let result = await cacheClient.deleteCache(cacheName: cacheName)
    switch result {
    case DeleteCacheResponse.error(let err):
        fatalError("Unable to tear delete integration test cache \(cacheName): \(err)")
    default:
        break
    }
}

// For generating unique cache names, keys, etc strings
// in case of CI jobs that run in parallel
func generateStringWithUuid(prefix: String?) -> String {
    return "\(prefix ?? "")-\(UUID().uuidString)"
}
