import Logging

class LogProvider {
    internal static var logLevel: Logger.Level = .info

    internal static func setLogLevel(logLevel: Logger.Level) {
        // If multiple Momento clients are instantiated with different logging levels,
        // LogProvider should use the minimum level for all of them
        if logLevel <= self.logLevel {
            self.logLevel = logLevel
        }
    }

    public static func getLogger(name: String) -> Logger {
        // Uses the default logging backend which prints to stdout.
        // Call LoggingSystem.boostrap(...) once at the beginning of your
        // program to change the logging backend.
        // Reference: https://github.com/apple/swift-log#default-logger-behavior
        var logger = Logger(label: name)
        logger.logLevel = self.logLevel
        return logger
    }
}
