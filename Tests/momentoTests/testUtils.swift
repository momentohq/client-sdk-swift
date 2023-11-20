import Foundation
@testable import momento

struct TestSetup {
    var cacheName: String
    var cacheClient: CacheClientProtocol
    var topicClient: TopicClientProtocol
}

func setUpIntegrationTests() async -> TestSetup {
    do {
        let creds = try CredentialProvider.fromEnvironmentVariable(envVariableName: "TEST_AUTH_TOKEN")
        
        let topicClient = TopicClient(
            configuration: TopicConfigurations.Default.latest(),
            credentialProvider: creds
        )
        
        let cacheClient = CacheClient(
            configuration: CacheConfigurations.Default.latest(),
            credentialProvider: creds,
            defaultTtlMillis: 10000
        )
        
        let cacheName = "swift-test-\(UUID().uuidString)"
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
