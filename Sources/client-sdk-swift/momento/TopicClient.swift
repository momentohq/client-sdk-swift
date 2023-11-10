import Foundation

public protocol TopicClientProtocol {
    func publish() async -> String
    func subscribe() async -> String
}

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
    
    public func publish() async -> String {
        do {
            let result = try await self.pubsubClient.publish()
        } catch {
            print("TopicClientPublishError: \(error)")
        }
        return "publishing"
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
