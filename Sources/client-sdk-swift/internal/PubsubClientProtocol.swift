@available(macOS 10.15, *)
protocol PubsubClientProtocol {
    var logger: MomentoLoggerProtocol { get }
    var configuration: TopicClientConfiguration { get }
    var credentialProvider: CredentialProviderProtocol { get }
    var client: CacheClient_Pubsub_PubsubAsyncClient { get }
    
    func publish() async -> PublishResponse
    func subscribe() async -> String
}
