class LogProvider {
    internal static var momentoLoggerFactory: MomentoLoggerFactoryProtocol? = nil
    
    internal static func setLogger(loggerFactory: MomentoLoggerFactoryProtocol) {
        self.momentoLoggerFactory = loggerFactory
    }
    
    internal static func getLogger(name: String) throws -> MomentoLoggerProtocol {
        if self.momentoLoggerFactory != nil {
            return self.momentoLoggerFactory!.getLogger(loggerName: name)
        } else {
            throw FailedPreconditionError(
                message: "Momento Logger Factory is not yet initialized"
            )
        }
    }
}
