public class TopicClientConfiguration: TopicClientConfigurationProtocol {
    var loggerFactory: MomentoLoggerFactoryProtocol
    var transportStrategy: TransportStrategyProtocol
    
    init(loggerFactory: MomentoLoggerFactoryProtocol, transportStrategy: TransportStrategyProtocol) {
        self.loggerFactory = loggerFactory
        self.transportStrategy = transportStrategy
    }
    
    func withTransportStrategy(transportStrategy: TransportStrategyProtocol) -> TopicClientConfigurationProtocol {
        return TopicClientConfiguration(loggerFactory: self.loggerFactory, transportStrategy: transportStrategy)
    }
    
    func withClientTimeout(timeoutMillis: Int) -> TopicClientConfigurationProtocol {
        return TopicClientConfiguration(loggerFactory: self.loggerFactory, transportStrategy: StaticTransportStrategy(grpcConfig: StaticGrpcConfiguration(deadlineMillis: timeoutMillis)))
    }
}

