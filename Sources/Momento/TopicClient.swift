import Foundation

public protocol TopicClientProtocol {
    func publish(
        cacheName: String,
        topicName: String,
        value: String
    ) async -> TopicPublishResponse
    
    func publish(
        cacheName: String,
        topicName: String,
        value: Data
    ) async -> TopicPublishResponse

    func subscribe(
        cacheName: String,
        topicName: String
    ) async -> TopicSubscribeResponse
    
    func close()
}

/**
 Client to perform operations against Momento Topics, a serverless publish/subscribe service.
 To learn more, see the [Momento Topics developer documentation](https://docs.momentohq.com/topics)
 */
public class TopicClient: TopicClientProtocol {
    private let pubsubClient: PubsubClientProtocol
    private let credentialProvider: CredentialProviderProtocol
    
    /**
     Constructs the client to perform operations against Momento Topics.
     - Parameters:
        - configuration: TopicClient configuration object specifying grpc transport strategy and other settings
        - credentialProvider: provides the Momento API key, which you can create in the [Momento Web Console](https://console.gomomento.com/api-keys)
     */
    @available(macOS 10.15, iOS 13, *)
    public init(
        configuration: TopicClientConfigurationProtocol,
        credentialProvider: CredentialProviderProtocol
    ) {
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
        - value: the value to be published as String
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
        value: String
    ) async -> TopicPublishResponse {
        return await self.doPublish(cacheName: cacheName, topicName: topicName, value: ScalarType.string(value))
    }
    
    /**
    Publishes a value to a topic
     - Parameters:
        - cacheName: name of the cache containing the topic
        - topicName: name of the topic
        - value: the value to be published as Data
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
        value: Data
    ) async -> TopicPublishResponse {
        return await self.doPublish(cacheName: cacheName, topicName: topicName, value: ScalarType.data(value))
    }
    
    internal func doPublish(
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
