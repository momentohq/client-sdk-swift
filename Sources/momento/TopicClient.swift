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
    private let logProvider: LogProvider
    private let pubsubClient: PubsubClientProtocol
    private let credentialProvider: CredentialProviderProtocol
    
    @available(macOS 10.15, *)
    public init(
        configuration: TopicClientConfigurationProtocol,
        credentialProvider: CredentialProviderProtocol
    ) {
        self.logProvider = LogProvider()
        LogProvider.setLogger(loggerFactory: configuration.loggerFactory)
        
        self.credentialProvider = credentialProvider
        self.pubsubClient = PubsubClient(
            configuration: configuration,
            credentialProvider: credentialProvider
        )
    }
    
    public func publish(
        cacheName: String,
        topicName: String,
        value: String
    ) async -> TopicPublishResponse {
        do {
            try validateCacheName(cacheName: cacheName)
            try validateTopicName(topicName: topicName)
        } catch let err as SdkError {
            return TopicPublishError(error: err)
        } catch {
            return TopicPublishError(error: UnknownError(
                message: "unexpected error: \(error)")
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

    public func publish(
        cacheName: String,
        topicName: String,
        value: Data
    ) async -> TopicPublishResponse {
        do {
            try validateCacheName(cacheName: cacheName)
            try validateTopicName(topicName: topicName)
        } catch let err as SdkError {
            return TopicPublishError(error: err)
        } catch {
            return TopicPublishError(error: UnknownError(
                message: "unexpected error: \(error)")
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
        do {
            try validateCacheName(cacheName: cacheName)
            try validateTopicName(topicName: topicName)
        } catch let err as SdkError {
            return TopicSubscribeError(error: err)
        } catch {
            return TopicSubscribeError(error: UnknownError(
                message: "unexpected error: \(error)")
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
