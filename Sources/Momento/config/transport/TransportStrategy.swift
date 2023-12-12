import Foundation

public protocol TransportStrategyProtocol {
    /// Low-level gRPC settings for communication with the Momento server
    var grpcConfig: GrpcConfigurationProtocol { get }
    
    /**
    Copy constructor to update the client-side timeout
    - Parameter grpcConfig
    - Returns a new transport strategy with the specified gRPC config
    */
    static func withGrpcConfig(grpcConfig: GrpcConfigurationProtocol) -> TransportStrategyProtocol
    
    /// Returns The currently configured client-side timeout
    func getClientTimeout() -> TimeInterval
    
    /**
    Copy constructor to update the client-side timeout
    - Parameter timeout: `TimeInterval` representing the client-side timeout
    */
    static func withClientTimeout(timeout: TimeInterval) -> TransportStrategyProtocol
}

public class StaticTransportStrategy: TransportStrategyProtocol {
    public var grpcConfig: GrpcConfigurationProtocol
    
    /**
    - Parameter grpcConfig:low-level gRPC settings for communication with the Momento server
    */
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
