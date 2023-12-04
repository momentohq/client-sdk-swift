import Foundation

public protocol CacheClientConfigurationProtocol {
    var transportStrategy: TransportStrategyProtocol { get }
    
    func withTransportStrategy(transportStrategy: TransportStrategyProtocol) -> CacheClientConfigurationProtocol
    func withClientTimeout(timeout: TimeInterval) -> CacheClientConfigurationProtocol
}

public class CacheClientConfiguration: CacheClientConfigurationProtocol {
    public var transportStrategy: TransportStrategyProtocol
    
    init(transportStrategy: TransportStrategyProtocol) {
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
