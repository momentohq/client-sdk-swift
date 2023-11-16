class LogProvider {
    internal static var momentoLoggerFactory: MomentoLoggerFactoryProtocol = DefaultMomentoLoggerFactory()
    
    internal static func setLogger(loggerFactory: MomentoLoggerFactoryProtocol) {
        self.momentoLoggerFactory = loggerFactory
    }
    
    internal static func getLogger(name: String) -> MomentoLoggerProtocol {
        return self.momentoLoggerFactory.getLogger(loggerName: name)
    }
}
