class StaticGrpcConfiguration: GrpcConfigurationProtocol {    
    var deadlineMillis: Int
    
    init(deadlineMillis: Int) {
        self.deadlineMillis = deadlineMillis
    }
    
    func withDeadlineMillis(deadlineMillis: Int) -> GrpcConfigurationProtocol {
        return StaticGrpcConfiguration(deadlineMillis: deadlineMillis)
    }
}

class StaticTransportStrategy: TransportStrategyProtocol {
    var grpcConfig: GrpcConfigurationProtocol
    
    init(grpcConfig: GrpcConfigurationProtocol) {
        self.grpcConfig = grpcConfig
    }
    
    func withGrpcConfig(grpcConfig: GrpcConfigurationProtocol) -> TransportStrategyProtocol {
        return StaticTransportStrategy(grpcConfig: grpcConfig)
    }
    
    func getClientTimeoutMillis() -> Int {
        return self.grpcConfig.deadlineMillis
    }
    
    func withClientTimeoutMillis(timeoutMillis: Int) -> TransportStrategyProtocol {
        return StaticTransportStrategy(grpcConfig: StaticGrpcConfiguration(deadlineMillis: timeoutMillis))
    }
    
}
