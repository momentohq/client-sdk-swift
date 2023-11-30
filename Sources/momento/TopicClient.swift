import Foundation

public protocol TopicClientProtocol {
    func publish(
        cacheName: String,
        topicName: String,
        value: ScalarType
    ) async -> TopicPublishResponse

    func subscribe(
        cacheName: String,
        topicName: String
    ) async -> TopicSubscribeResponse
    
    func close()
}

public class TopicClient: TopicClientProtocol {
    private let pubsubClient: PubsubClientProtocol
    private let credentialProvider: CredentialProviderProtocol
    
    @available(macOS 10.15, iOS 13, *)
    public init(
        configuration: TopicClientConfigurationProtocol,
        credentialProvider: CredentialProviderProtocol
    ) {
        LogProvider.setLogger(loggerFactory: configuration.loggerFactory)
        self.credentialProvider = credentialProvider
        self.pubsubClient = PubsubClient(
            configuration: configuration,
            credentialProvider: credentialProvider
        )
    }
    
    /**
    Publishes a value to a topic
     - Parameters:
        - cacheName: name of the cache containing the topic
        - topicName: name of the topic
        - value: the value to be published
     - Returns: TopicPublishResponse representing the result of the publish operation.
     Pattern matching can be used to operate on the appropriate subtype.
    ```
     switch publishResponse {
     case let publishError as TopicPublishError:
        // handle error
     case is TopicPublishSuccess:
        // handle success
     }
    ```
     */
    public func publish(
        cacheName: String,
        topicName: String,
        value: ScalarType
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

    /**
     Subscribe to a topic. The returned value can be used to iterate over newly published messages on the topic.
     - Parameters:
        - cacheName: name of the cache containing the topic
        - topicName: name of the topic
     - Returns: TopicSubscribeResponse representing the result of the subscribe operation.
     Pattern matching can be used to operate on the appropriate subtype.
    ```
     switch subscribeResponse {
     case let subscribeError as TopicSubscribeError:
        // handle error
     case let subscribeSuccess as TopicSubscribeSuccess:
        // handle success, iterate over newly published messages
        for try await item in subscribeSuccess.subscription {...}
     }
    ```
     */
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
