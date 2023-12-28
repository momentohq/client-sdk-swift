public class ErrorResponseBase: ErrorResponseBaseProtocol, Error, CustomStringConvertible {
    var error: SdkError
    public var message: String { return self.error.message }
    public var errorCode: MomentoErrorCode { return self.error.errorCode }
    public var innerException: Error? { return self.error.innerException }

    init(error: SdkError) {
        self.error = error
    }

    public var description: String {
        return "[\(self.errorCode)] \(self.error.messageWrapper): \(self.error.message)"
    }
}
