protocol GrpcConfigurationProtocol {
    var deadlineMillis: Int { get }
    static func withDeadlineMillis(deadlineMillis: Int) -> GrpcConfigurationProtocol
}
