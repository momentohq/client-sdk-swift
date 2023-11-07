protocol TopicClientConfigurationProtocol {
    var loggerFactory: MomentoLoggerFactoryProtocol { get }
    var transportStrategy: TransportStrategyProtocol { get }
    
    func withTransportStrategy(transportStrategy: TransportStrategyProtocol) -> TopicClientConfigurationProtocol
    func withClientTimeout(timeoutMillis: Int) -> TopicClientConfigurationProtocol
}
