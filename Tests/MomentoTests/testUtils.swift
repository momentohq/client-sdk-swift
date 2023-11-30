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
            configuration: TopicConfigurations.Default.latest(),
            credentialProvider: creds
        )
        
        let cacheClient = CacheClient(
            configuration: CacheConfigurations.Default.latest(),
            credentialProvider: creds,
            defaultTtlSeconds: 10
        )
        
        let cacheName = generateStringWithUuid(prefix: "swift-test")
        let result = await cacheClient.createCache(cacheName: cacheName)
        if result is CacheCreateError {
            throw (result as! CacheCreateError) as! Error
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
    if result is CacheDeleteError {
        fatalError("Unable to tear down integration test setup: \(result)")
    }
}

// For generating unique cache names, keys, etc strings
// in case of CI jobs that run in parallel
func generateStringWithUuid(prefix: String?) -> String {
    return "\(prefix ?? "")-\(UUID().uuidString)"
}

