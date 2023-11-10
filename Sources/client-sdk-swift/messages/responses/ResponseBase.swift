public class ErrorResponseBase: ErrorResponseBaseProtocol {
    var error: SdkError
    public var message: String { return self.error.message }
    public var errorCode: MomentoErrorCode { return self.error.errorCode }
    public var innerException: Error? { return self.error.innerException }
    
    init(error: SdkError) {
        self.error = error
    }

    // TODO: add type
    public var description: String {
        return "Error: \(self.error.messageWrapper): \(self.error.message)"
    }
}
