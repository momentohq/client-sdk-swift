import Foundation

protocol GrpcConfigurationProtocol {
    var deadlineMillis: TimeInterval { get }
    static func withDeadlineMillis(deadlineMillis: TimeInterval) -> GrpcConfigurationProtocol
}
