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

    func subscribe(
        cacheName: String,
        topicName: String,
        resumeAtTopicSequenceNumber: UInt64?,
        resumeAtTopicSequencePage: UInt64?
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
    
     ```swift
     let topicClient = TopicClient(
       configuration: TopicClientConfigurations.iOS.latest(),
       credentialProvider: yourCredentialProvider
     )
     ```
     */
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
    ```swift
     switch publishResponse {
     case .error(let err):
         print("Error: \(err)")
     case .success(_):
         print("Success")
     }
    ```
     */
    public func publish(
        cacheName: String,
        topicName: String,
        value: String
    ) async -> TopicPublishResponse {
        return await self.doPublish(
            cacheName: cacheName, topicName: topicName, value: ScalarType.string(value))
    }

    /**
    Publishes a value to a topic
     - Parameters:
        - cacheName: name of the cache containing the topic
        - topicName: name of the topic
        - value: the value to be published as Data
     - Returns: TopicPublishResponse representing the result of the publish operation.
    
     Pattern matching can be used to operate on the appropriate subtype.
    ```swift
     switch publishResponse {
     case .error(let err):
         print("Error: \(err)")
     case .success(_):
         print("Success")
     }
    ```
     */
    public func publish(
        cacheName: String,
        topicName: String,
        value: Data
    ) async -> TopicPublishResponse {
        return await self.doPublish(
            cacheName: cacheName, topicName: topicName, value: ScalarType.data(value))
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
            return TopicPublishResponse.error(TopicPublishError(error: err))
        } catch {
            return TopicPublishResponse.error(
                TopicPublishError(
                    error: SdkError.UnknownError(
                        UnknownError(
                            message: "unexpected error: '\(error)'", innerException: error
                        )
                    )
                )
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
            return TopicPublishResponse.error(
                TopicPublishError(
                    error: SdkError.UnknownError(
                        UnknownError(
                            message: "Unknown error from publish: '\(error)'",
                            innerException: error
                        ))
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
     ```swift
      switch subscribeResponse {
      case .error(let err):
          print("Error: \(err)")
      case .subscription(let sub):
          for try await item in sub.stream {...}
      }
     ```
     */
    public func subscribe(cacheName: String, topicName: String) async -> TopicSubscribeResponse {
        return await self.doSubscribe(
            cacheName: cacheName, topicName: topicName, resumeAtTopicSequenceNumber: nil,
            resumeAtTopicSequencePage: nil)
    }

    /**
     Subscribe to a topic. The returned value can be used to iterate over newly published messages on the topic.
     - Parameters:
        - cacheName: name of the cache containing the topic
          topicName: name of the topic
          resumeAtTopicSequenceNumber: sequence number to resume at. Use nil or 0 to start at the latest messages.
          resumeAtTopicSequenceNumber: page number to resume at. Use nil or 0 to start at the latest messages.
     - Returns: TopicSubscribeResponse representing the result of the subscribe operation.
    
     Pattern matching can be used to operate on the appropriate subtype.
     ```swift
      switch subscribeResponse {
      case .error(let err):
          print("Error: \(err)")
      case .subscription(let sub):
          for try await item in sub.stream {...}
      }
     ```
     */
    public func subscribe(
        cacheName: String, topicName: String, resumeAtTopicSequenceNumber: UInt64?,
        resumeAtTopicSequencePage: UInt64?
    ) async -> TopicSubscribeResponse {
        return await doSubscribe(
            cacheName: cacheName, topicName: topicName,
            resumeAtTopicSequenceNumber: resumeAtTopicSequenceNumber,
            resumeAtTopicSequencePage: resumeAtTopicSequencePage
        )
    }

    internal func doSubscribe(
        cacheName: String, topicName: String, resumeAtTopicSequenceNumber: UInt64?,
        resumeAtTopicSequencePage: UInt64?
    ) async -> TopicSubscribeResponse {
        do {
            try validateCacheName(cacheName: cacheName)
            try validateTopicName(topicName: topicName)
        } catch let err as SdkError {
            return TopicSubscribeResponse.error(TopicSubscribeError(error: err))
        } catch {
            return TopicSubscribeResponse.error(
                TopicSubscribeError(
                    error: SdkError.UnknownError(
                        UnknownError(
                            message: "unexpected error: '\(error)'", innerException: error)))
            )
        }

        do {
            let result = try await self.pubsubClient.subscribe(
                cacheName: cacheName,
                topicName: topicName,
                resumeAtTopicSequenceNumber: resumeAtTopicSequenceNumber,
                resumeAtTopicSequencePage: resumeAtTopicSequencePage
            )
            return result
        } catch let err as TopicSubscribeError {
            return TopicSubscribeResponse.error(err)
        } catch {
            return TopicSubscribeResponse.error(
                TopicSubscribeError(
                    error: SdkError.UnknownError(
                        UnknownError(
                            message: "Unknown error from subscribe: '\(error)'",
                            innerException: error
                        ))
                ))
        }
    }

    public func close() {
        self.pubsubClient.close()
    }
}
