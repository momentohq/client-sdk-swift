import Foundation
import Logging

public protocol CacheClientConfigurationProtocol {
    var transportStrategy: TransportStrategyProtocol { get }
    var logLevel: Logger.Level { get set }
    
    func withTransportStrategy(transportStrategy: TransportStrategyProtocol) -> CacheClientConfigurationProtocol
    func withClientTimeout(timeout: TimeInterval) -> CacheClientConfigurationProtocol
}

public class CacheClientConfiguration: CacheClientConfigurationProtocol {
    public var transportStrategy: TransportStrategyProtocol
    public var logLevel: Logger.Level
    
    init(
        transportStrategy: TransportStrategyProtocol,
        logLevel: Logger.Level = .info
    ) {
        self.transportStrategy = transportStrategy
        self.logLevel = logLevel
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
