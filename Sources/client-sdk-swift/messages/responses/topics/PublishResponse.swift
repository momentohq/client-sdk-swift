public class PublishResponse {}

public class PublishSuccess: PublishResponse {}

public class PublishError: ErrorResponseBase & PublishResponse {
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
        return "Publish Error: \(self.message())"
    }
}
