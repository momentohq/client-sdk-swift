import Foundation

public class StaticGrpcConfiguration: GrpcConfigurationProtocol {
    var deadlineMillis: TimeInterval
    
    init(deadlineMillis: TimeInterval) {
        self.deadlineMillis = deadlineMillis
    }
    
    static func withDeadlineMillis(deadlineMillis: TimeInterval) -> GrpcConfigurationProtocol {
        return StaticGrpcConfiguration(deadlineMillis: deadlineMillis)
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
    
    func getClientTimeoutMillis() -> TimeInterval {
        return self.grpcConfig.deadlineMillis
    }
    
    static func withClientTimeoutMillis(timeoutMillis: TimeInterval) -> TransportStrategyProtocol {
        return StaticTransportStrategy(grpcConfig: StaticGrpcConfiguration(deadlineMillis: timeoutMillis))
    }
    
}
