protocol MomentoLoggerProtocol {
    var loggerName: String { get }
    var level: DefaultMomentoLoggerLevel { get }
    
    func error(msg: String)
    func warn(msg: String)
    func info(msg: String)
    func debug(msg: String)
    func trace(msg: String)
}

protocol MomentoLoggerFactoryProtocol {
    var level: DefaultMomentoLoggerLevel { get }
    func getLogger(loggerName: String) -> MomentoLoggerProtocol
}
