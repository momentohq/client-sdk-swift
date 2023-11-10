import Foundation

protocol GrpcConfigurationProtocol {
    var deadline: TimeInterval { get }
    static func withDeadline(deadline: TimeInterval) -> GrpcConfigurationProtocol
}

public class StaticGrpcConfiguration: GrpcConfigurationProtocol {
    var deadline: TimeInterval
    
    init(deadline: TimeInterval) {
        self.deadline = deadline
    }
    
    static func withDeadline(deadline: TimeInterval) -> GrpcConfigurationProtocol {
        return StaticGrpcConfiguration(deadline: deadline)
    }
}
