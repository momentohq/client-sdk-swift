public protocol MomentoLoggerProtocol {
    func error(msg: String)
    func warn(msg: String)
    func info(msg: String)
    func debug(msg: String)
    func trace(msg: String)
}

public protocol MomentoLoggerFactoryProtocol {
    func getLogger(loggerName: String) -> MomentoLoggerProtocol
}
