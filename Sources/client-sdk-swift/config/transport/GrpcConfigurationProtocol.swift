protocol GrpcConfigurationProtocol {
    var deadlineMillis: Int { get }
    func withDeadlineMillis(deadlineMillis: Int) -> GrpcConfigurationProtocol
}
