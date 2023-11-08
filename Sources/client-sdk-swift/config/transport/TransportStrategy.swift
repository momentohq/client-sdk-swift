import Foundation

public class StaticGrpcConfiguration: GrpcConfigurationProtocol {
    var deadline: TimeInterval
    
    init(deadline: TimeInterval) {
        self.deadline = deadline
    }
    
    static func withDeadline(deadline: TimeInterval) -> GrpcConfigurationProtocol {
        return StaticGrpcConfiguration(deadline: deadline)
    }
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
