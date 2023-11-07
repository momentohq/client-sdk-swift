protocol TransportStrategyProtocol {
    var grpcConfig: GrpcConfigurationProtocol { get }
    func withGrpcConfig(grpcConfig: GrpcConfigurationProtocol) -> TransportStrategyProtocol
    func getClientTimeoutMillis() -> Int
    func withClientTimeoutMillis(timeoutMillis: Int) -> TransportStrategyProtocol
}
