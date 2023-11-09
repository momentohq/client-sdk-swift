import Foundation

@available(macOS 10.15, *)
public protocol TopicClientProtocol {
    func publish(cacheName: String, topicName: String, value: String) async -> PublishResponse
    func subscribe() async -> String
}

@available(macOS 10.15, *)
public class TopicClient: TopicClientProtocol {
    var logger: MomentoLoggerProtocol
    var pubsubClient: PubsubClientProtocol
    var credentialProvider: CredentialProviderProtocol
    
    @available(macOS 10.15, *)
    init(configuration: TopicClientConfiguration, credentialProvider: CredentialProviderProtocol, logger: MomentoLoggerProtocol = DefaultMomentoLogger(loggerName: "swift-momento-logger", level: DefaultMomentoLoggerLevel.info)) {
        self.logger = logger
        self.credentialProvider = credentialProvider
        self.pubsubClient = PubsubClient(logger: logger, configuration: configuration, credentialProvider: credentialProvider)
    }
    
    public func publish(cacheName: String, topicName: String, value: String) async -> PublishResponse {
        let result = await self.pubsubClient.publish(cacheName: cacheName, topicName: topicName, value: value)
        return result
    }
    
    public func subscribe() async -> String {
        let result = await self.pubsubClient.subscribe()
        return result
    }
}
