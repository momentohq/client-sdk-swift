public protocol ErrorResponseBaseProtocol {
    func message() -> String
    func innerException() -> String
    func errorCode() -> String
    func toString() -> String
}

public class ErrorResponseBase: ErrorResponseBaseProtocol {
    var error: Error

    init(error: Error) {
        self.error = error
    }

    public func message() -> String {
        return "inner wrapped error message"
    }

    public func innerException() -> String {
        return "inner error"
    }

    public func errorCode() -> String {
        return "error code"
    }

    public func toString() -> String {
        return "Error: \(self.message())"
    }
}
