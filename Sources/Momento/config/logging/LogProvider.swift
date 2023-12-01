enum MomentoClient {
    case CacheClient
    case TopicClient
}

class LogProvider {
    internal static var cacheClientLoggerFactory: MomentoLoggerFactoryProtocol = DefaultMomentoLoggerFactory()
    
    internal static var topicClientLoggerFactory: MomentoLoggerFactoryProtocol = DefaultMomentoLoggerFactory()
    
    internal static func setLoggerFactory(
        loggerFactory: MomentoLoggerFactoryProtocol,
        client: MomentoClient
    ) {
        switch client {
        case .CacheClient:
            self.cacheClientLoggerFactory = loggerFactory
        case .TopicClient:
            self.topicClientLoggerFactory = loggerFactory
        }
    }
    
    public static func getLogger(name: String, client: MomentoClient) -> MomentoLoggerProtocol {
        switch client {
        case .CacheClient:
            return self.cacheClientLoggerFactory.getLogger(loggerName: name)
        case .TopicClient:
            return self.topicClientLoggerFactory.getLogger(loggerName: name)
        }
    }
}
