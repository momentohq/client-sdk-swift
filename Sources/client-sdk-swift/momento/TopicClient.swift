import Foundation

public protocol TopicClientProtocol {
    func publish(
        cacheName: String,
        topicName: String,
        value: String
    ) async -> TopicPublishResponse
    func subscribe() async -> String
}

public class TopicClient: TopicClientProtocol {
    var logger: MomentoLoggerProtocol
    var pubsubClient: PubsubClientProtocol
    var credentialProvider: CredentialProviderProtocol
    
    @available(macOS 10.15, *)
    init(
        configuration: TopicClientConfiguration,
        credentialProvider: CredentialProviderProtocol,
        logger: MomentoLoggerProtocol = DefaultMomentoLogger(
            loggerName: "swift-momento-logger",
            level: DefaultMomentoLoggerLevel.info
        )
    ) {
        self.logger = logger
        self.credentialProvider = credentialProvider
        self.pubsubClient = PubsubClient(
            logger: logger,
            configuration: configuration,
            credentialProvider: credentialProvider
        )
    }
    
    public func publish(
        cacheName: String,
        topicName: String,
        value: String
    ) async -> TopicPublishResponse {
        if cacheName.count < 1 {
            return TopicPublishError(
                error: InvalidArgumentError(message: "Must provide a cache name")
            )
        }
        if topicName.count < 1 {
            return TopicPublishError(
                error: InvalidArgumentError(message: "Must provide a topic name")
            )
        }
        do {
            let result = try await self.pubsubClient.publish(
                cacheName: cacheName,
                topicName: topicName,
                value: value
            )
            return result
        } catch {
            return error as! TopicPublishResponse
        }
    }
    
    public func subscribe() async -> String {
        do {
            let result = try await self.pubsubClient.subscribe()
        } catch {
            print("TopicClientSubscribeError: \(error)")
        }
        return "subscribing"
    }
}
