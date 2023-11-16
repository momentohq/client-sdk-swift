import Foundation
public enum DefaultMomentoLoggerLevel {
    case trace, debug, info, warn, error
    var value: Int {
        switch self {
        case .trace:
            return 5
        case .debug:
            return 10
        case .info:
            return 20
        case .warn:
            return 30
        case .error:
            return 40
        }
    }
}

public class DefaultMomentoLoggerFactory: MomentoLoggerFactoryProtocol {
    var level: DefaultMomentoLoggerLevel
    
    public init(level: DefaultMomentoLoggerLevel = DefaultMomentoLoggerLevel.info) {
        self.level = level
    }
    
    public func getLogger(loggerName: String) -> MomentoLoggerProtocol {
        return DefaultMomentoLogger(loggerName: loggerName, level: self.level)
    }
}

public class DefaultMomentoLogger: MomentoLoggerProtocol {
    var loggerName: String
    var level: DefaultMomentoLoggerLevel
    
    public init(loggerName: String, level: DefaultMomentoLoggerLevel) {
        self.loggerName = loggerName
        self.level = level
    }
    
    private func outputMessage(level: String, msg: String) {
        fputs("[\(self.getCurrentTime())] \(level) (Momento: \(loggerName): \(msg)", stderr)
    }
    
    private func getCurrentTime() -> String {
        let now = Date()
        let formatter = ISO8601DateFormatter()
        let formattedTime = formatter.string(from: now)
        return formattedTime
    }
    
    public func error(msg: String) {
        if self.level.value <= DefaultMomentoLoggerLevel.error.value {
            self.outputMessage(level: "ERROR", msg: msg)
        }
    }
    
    public func warn(msg: String) {
        if self.level.value <= DefaultMomentoLoggerLevel.warn.value {
            self.outputMessage(level: "WARN", msg: msg)
        }
    }
    
    public func info(msg: String) {
        if self.level.value <= DefaultMomentoLoggerLevel.info.value {
            self.outputMessage(level: "INFO", msg: msg)
        }
    }
    
    public func debug(msg: String) {
        if self.level.value <= DefaultMomentoLoggerLevel.debug.value {
            self.outputMessage(level: "DEBUG", msg: msg)
        }
    }
    
    public func trace(msg: String) {
        if self.level.value <= DefaultMomentoLoggerLevel.trace.value {
            self.outputMessage(level: "TRACE", msg: msg)
        }
    }
}
