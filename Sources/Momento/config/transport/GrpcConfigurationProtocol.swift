import Foundation

public protocol GrpcConfigurationProtocol {
    /// Number of seconds the client is willing to wait for an RPC to complete before it is terminated with a DeadlineExceeded error
    var deadline: TimeInterval { get }
    /// Copy constructor for overriding the client-side deadline
    static func withDeadline(deadline: TimeInterval) -> GrpcConfigurationProtocol
}

/// Encapsulates gRPC configuration tunables
public class StaticGrpcConfiguration: GrpcConfigurationProtocol {
    public var deadline: TimeInterval

    /**
     - Parameter deadline: `TimeInterval` representing the number of seconds the client is willing to wait for an RPC to complete before it is terminated with a DeadlineExceeded error
     */
    init(deadline: TimeInterval) {
        self.deadline = deadline
    }
    
    public static func withDeadline(deadline: TimeInterval) -> GrpcConfigurationProtocol {
        return StaticGrpcConfiguration(deadline: deadline)
    }
}
