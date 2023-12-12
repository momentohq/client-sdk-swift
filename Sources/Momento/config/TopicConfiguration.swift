import Foundation
import Logging

public protocol TopicClientConfigurationProtocol {
    /// Configures low-level options for network interactions with the Momento service
    var transportStrategy: TransportStrategyProtocol { get }
    
    /**
    Copy constructor for overriding TransportStrategy
    - Parameter transportStrategy
    - Returns a new `TopicClientConfiguration` object with the specified transport strategy
    */
    func withTransportStrategy(transportStrategy: TransportStrategyProtocol) -> TopicClientConfigurationProtocol
    func withClientTimeout(timeout: TimeInterval) -> TopicClientConfigurationProtocol
}

public class TopicClientConfiguration: TopicClientConfigurationProtocol {
    public var transportStrategy: TransportStrategyProtocol
    
    /**
    - Parameter transportStrategy: configures low-level options for network interactions with the Momento service
    */
    public init(transportStrategy: TransportStrategyProtocol) {
        self.transportStrategy = transportStrategy
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

