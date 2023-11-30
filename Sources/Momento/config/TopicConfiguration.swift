import Foundation

public protocol TopicClientConfigurationProtocol {
    var loggerFactory: MomentoLoggerFactoryProtocol { get }
    var transportStrategy: TransportStrategyProtocol { get }
    
    func withTransportStrategy(transportStrategy: TransportStrategyProtocol) -> TopicClientConfigurationProtocol
    func withClientTimeout(timeout: TimeInterval) -> TopicClientConfigurationProtocol
}

public class TopicClientConfiguration: TopicClientConfigurationProtocol {
    public var loggerFactory: MomentoLoggerFactoryProtocol
    public var transportStrategy: TransportStrategyProtocol
    
    init(
        loggerFactory: MomentoLoggerFactoryProtocol,
        transportStrategy: TransportStrategyProtocol
    ) {
        self.loggerFactory = loggerFactory
        self.transportStrategy = transportStrategy
    }
    
    public func withTransportStrategy(transportStrategy: TransportStrategyProtocol) -> TopicClientConfigurationProtocol {
        return TopicClientConfiguration(
            loggerFactory: self.loggerFactory,
            transportStrategy: transportStrategy
        )
    }
    
    public func withClientTimeout(timeout: TimeInterval) -> TopicClientConfigurationProtocol {
        return TopicClientConfiguration(
            loggerFactory: self.loggerFactory,
            transportStrategy: StaticTransportStrategy(
                grpcConfig: StaticGrpcConfiguration(deadline: timeout)
            )
        )
    }
}

