public protocol ErrorResponseBase {
    func message() -> String
    func innerException() -> String
    func errorCode() -> String
    func toString() -> String
}
