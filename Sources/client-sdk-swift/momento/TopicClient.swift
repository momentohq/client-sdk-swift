import Foundation

public class TopicClient: TopicClientProtocol {
    var logger: MomentoLoggerProtocol
    var pubsubClient: PubsubClientProtocol
    
    init(configuration: TopicClientConfiguration, logger: MomentoLoggerProtocol = DefaultMomentoLogger(loggerName: "swift-momento-logger", level: DefaultMomentoLoggerLevel.info)) {
        self.logger = logger
        self.pubsubClient = PubsubClient(logger: logger, configuration: configuration)
    }
    
    public func publish() async -> String {
        return "publishing"
    }
    
    public func subscribe() async -> String {
        return "subscribing"
    }
}
