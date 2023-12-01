import Foundation

public protocol CacheClientConfigurationProtocol {
    var loggerFactory: MomentoLoggerFactoryProtocol { get }
    var transportStrategy: TransportStrategyProtocol { get }
    
    func withTransportStrategy(transportStrategy: TransportStrategyProtocol) -> CacheClientConfigurationProtocol
    func withClientTimeout(timeout: TimeInterval) -> CacheClientConfigurationProtocol
}

public class CacheClientConfiguration: CacheClientConfigurationProtocol {
    public var loggerFactory: MomentoLoggerFactoryProtocol
    public var transportStrategy: TransportStrategyProtocol
    
    init(
        loggerFactory: MomentoLoggerFactoryProtocol,
        transportStrategy: TransportStrategyProtocol
    ) {
        self.loggerFactory = loggerFactory
        self.transportStrategy = transportStrategy
    }
    
    public func withTransportStrategy(transportStrategy: TransportStrategyProtocol) -> CacheClientConfigurationProtocol {
        return CacheClientConfiguration(
            loggerFactory: self.loggerFactory,
            transportStrategy: transportStrategy
        )
    }
    
    public func withClientTimeout(timeout: TimeInterval) -> CacheClientConfigurationProtocol {
        return CacheClientConfiguration(
            loggerFactory: self.loggerFactory,
            transportStrategy: StaticTransportStrategy(
                grpcConfig: StaticGrpcConfiguration(deadline: timeout)
            )
        )
    }
}
