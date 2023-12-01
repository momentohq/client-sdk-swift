import Foundation

public protocol GrpcConfigurationProtocol {
    var deadline: TimeInterval { get }
    static func withDeadline(deadline: TimeInterval) -> GrpcConfigurationProtocol
}

public class StaticGrpcConfiguration: GrpcConfigurationProtocol {
    public var deadline: TimeInterval
    
    init(deadline: TimeInterval) {
        self.deadline = deadline
    }
    
    public static func withDeadline(deadline: TimeInterval) -> GrpcConfigurationProtocol {
        return StaticGrpcConfiguration(deadline: deadline)
    }
}
