import Foundation

protocol GrpcConfigurationProtocol {
    var deadline: TimeInterval { get }
    static func withDeadline(deadline: TimeInterval) -> GrpcConfigurationProtocol
}
