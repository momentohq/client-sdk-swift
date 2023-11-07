protocol TransportStrategyProtocol {
    var grpcConfig: GrpcConfigurationProtocol { get }
    static func withGrpcConfig(grpcConfig: GrpcConfigurationProtocol) -> TransportStrategyProtocol
    func getClientTimeoutMillis() -> Int
    static func withClientTimeoutMillis(timeoutMillis: Int) -> TransportStrategyProtocol
}
