protocol GrpcConfigurationProtocol {
    var deadlineMillis: Int { get }
    mutating func withDeadlineMillis(deadlineMillis: Int) -> GrpcConfigurationProtocol
}
