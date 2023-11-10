public protocol ErrorResponseBaseProtocol {
    func message() -> String
    func innerException() -> SdkError
    func errorCode() -> MomentoErrorCode
    func toString() -> String
}

public class ErrorResponseBase: ErrorResponseBaseProtocol {
    var error: SdkError

    init(error: SdkError) {
        self.error = error
    }

    public func message() -> String {
        return self.error.messageWrapper
    }

    public func innerException() -> SdkError {
        return self.error
    }

    public func errorCode() -> MomentoErrorCode {
        return self.error.errorCode
    }

    public func toString() -> String {
        return "Error: \(self.message())"
    }
}
