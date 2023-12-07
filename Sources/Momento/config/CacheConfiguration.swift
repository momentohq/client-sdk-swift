import Foundation
import Logging

public protocol CacheClientConfigurationProtocol {
    /// Configures low-level options for network interactions with the Momento service
    var transportStrategy: TransportStrategyProtocol { get }
    
    /**
     Copy constructor for overriding TransportStrategy
    - Parameter transportStrategy
    - Returns a new `CacheConfiguration` object with the specified transport strategy
     */
    func withTransportStrategy(transportStrategy: TransportStrategyProtocol) -> CacheClientConfigurationProtocol
    /**
     Convenience copy constructor that updates the client-side timeout setting in the transport strategy
     - Parameter timeout: a `TimeInterval` respresenting the client-side timeout
     - Returns a new `CacheConfiguration` object with its transport strategy updated to use the specified client timeout
     */
    func withClientTimeout(timeout: TimeInterval) -> CacheClientConfigurationProtocol
}

public class CacheClientConfiguration: CacheClientConfigurationProtocol {
    public var transportStrategy: TransportStrategyProtocol
    
    /**
     - Parameter transportStrategy: configures low-level options for network interactions with the Momento service
     */
    public init(transportStrategy: TransportStrategyProtocol) {
        self.transportStrategy = transportStrategy
    }
    
    public func withTransportStrategy(transportStrategy: TransportStrategyProtocol) -> CacheClientConfigurationProtocol {
        return CacheClientConfiguration(transportStrategy: transportStrategy)
    }
    
    public func withClientTimeout(timeout: TimeInterval) -> CacheClientConfigurationProtocol {
        return CacheClientConfiguration(
            transportStrategy: StaticTransportStrategy(
                grpcConfig: StaticGrpcConfiguration(deadline: timeout)
            )
        )
    }
}
