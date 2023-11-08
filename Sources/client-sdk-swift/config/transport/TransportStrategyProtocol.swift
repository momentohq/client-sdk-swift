import Foundation

protocol TransportStrategyProtocol {
    var grpcConfig: GrpcConfigurationProtocol { get }
    static func withGrpcConfig(grpcConfig: GrpcConfigurationProtocol) -> TransportStrategyProtocol
    func getClientTimeout() -> TimeInterval
    static func withClientTimeout(timeout: TimeInterval) -> TransportStrategyProtocol
}
