import Foundation

public protocol TopicClientProtocol {
    func publish(
        cacheName: String,
        topicName: String,
        value: String
    ) async -> TopicPublishResponse
    
    func subscribe(
        cacheName: String,
        topicName: String
    ) async -> TopicSubscribeResponse
    
    func close()
}

public class TopicClient: TopicClientProtocol {
    var logger: MomentoLoggerProtocol
    private let pubsubClient: PubsubClientProtocol
    private let credentialProvider: CredentialProviderProtocol
    
    @available(macOS 10.15, *)
    public init(
        configuration: TopicClientConfigurationProtocol,
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
            return TopicPublishError(
                error: UnknownError(
                    message: "Unknown error from publish",
                    innerException: error
                )
            )
        }
    }
    
    public func subscribe(cacheName: String, topicName: String) async -> TopicSubscribeResponse {
        if cacheName.count < 1 {
            return TopicSubscribeError(
                error: InvalidArgumentError(message: "Must provide a cache name")
            )
        }
        if topicName.count < 1 {
            return TopicSubscribeError(
                error: InvalidArgumentError(message: "Must provide a topic name")
            )
        }
        do {
            let result = try await self.pubsubClient.subscribe(
                cacheName: cacheName, 
                topicName: topicName
            )
            return result
        } catch {
            return TopicSubscribeError(
                error: UnknownError(
                    message: "Unknown error from subscribe",
                    innerException: error
                )
            )
        }
    }
    
    public func close() {
        self.pubsubClient.close()
    }
}
