import Foundation

protocol TransportStrategyProtocol {
    var grpcConfig: GrpcConfigurationProtocol { get }
    static func withGrpcConfig(grpcConfig: GrpcConfigurationProtocol) -> TransportStrategyProtocol
    func getClientTimeout() -> TimeInterval
    static func withClientTimeout(timeout: TimeInterval) -> TransportStrategyProtocol
}

public class StaticTransportStrategy: TransportStrategyProtocol {
    var grpcConfig: GrpcConfigurationProtocol
    
    init(grpcConfig: GrpcConfigurationProtocol) {
        self.grpcConfig = grpcConfig
    }
    
    static func withGrpcConfig(grpcConfig: GrpcConfigurationProtocol) -> TransportStrategyProtocol {
        return StaticTransportStrategy(grpcConfig: grpcConfig)
    }
    
    func getClientTimeout() -> TimeInterval {
        return self.grpcConfig.deadline
    }
    
    static func withClientTimeout(timeout: TimeInterval) -> TransportStrategyProtocol {
        return StaticTransportStrategy(grpcConfig: StaticGrpcConfiguration(deadline: timeout))
    }
    
}
