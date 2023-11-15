import Foundation

public protocol TransportStrategyProtocol {
    var grpcConfig: GrpcConfigurationProtocol { get }
    static func withGrpcConfig(grpcConfig: GrpcConfigurationProtocol) -> TransportStrategyProtocol
    func getClientTimeout() -> TimeInterval
    static func withClientTimeout(timeout: TimeInterval) -> TransportStrategyProtocol
}

public class StaticTransportStrategy: TransportStrategyProtocol {
    public var grpcConfig: GrpcConfigurationProtocol
    
    init(grpcConfig: GrpcConfigurationProtocol) {
        self.grpcConfig = grpcConfig
    }
    
    public static func withGrpcConfig(grpcConfig: GrpcConfigurationProtocol) -> TransportStrategyProtocol {
        return StaticTransportStrategy(grpcConfig: grpcConfig)
    }
    
    public func getClientTimeout() -> TimeInterval {
        return self.grpcConfig.deadline
    }
    
    public static func withClientTimeout(timeout: TimeInterval) -> TransportStrategyProtocol {
        return StaticTransportStrategy(
            grpcConfig: StaticGrpcConfiguration(deadline: timeout)
        )
    }
    
}
