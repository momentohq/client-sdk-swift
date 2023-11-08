import Foundation

protocol TransportStrategyProtocol {
    var grpcConfig: GrpcConfigurationProtocol { get }
    static func withGrpcConfig(grpcConfig: GrpcConfigurationProtocol) -> TransportStrategyProtocol
    func getClientTimeoutMillis() -> TimeInterval
    static func withClientTimeoutMillis(timeoutMillis: TimeInterval) -> TransportStrategyProtocol
}
