import Foundation
import Logging

public protocol TopicClientConfigurationProtocol {
    var transportStrategy: TransportStrategyProtocol { get }
    var logLevel: Logger.Level { get set }
    
    func withTransportStrategy(transportStrategy: TransportStrategyProtocol) -> TopicClientConfigurationProtocol
    func withClientTimeout(timeout: TimeInterval) -> TopicClientConfigurationProtocol
}

public class TopicClientConfiguration: TopicClientConfigurationProtocol {
    public var transportStrategy: TransportStrategyProtocol
    public var logLevel: Logger.Level
    
    public init(
        transportStrategy: TransportStrategyProtocol,
        logLevel: Logger.Level = .info
    ) {
        self.transportStrategy = transportStrategy
        self.logLevel = logLevel
    }
    
    public func withTransportStrategy(transportStrategy: TransportStrategyProtocol) -> TopicClientConfigurationProtocol {
        return TopicClientConfiguration(
            transportStrategy: transportStrategy
        )
    }
    
    public func withClientTimeout(timeout: TimeInterval) -> TopicClientConfigurationProtocol {
        return TopicClientConfiguration(
            transportStrategy: StaticTransportStrategy(
                grpcConfig: StaticGrpcConfiguration(deadline: timeout)
            )
        )
    }
}

