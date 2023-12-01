import GRPC

public enum MomentoErrorCode: String {
    case INVALID_ARGUMENT_ERROR = "INVALID_ARGUMENT_ERROR"
    case UNKNOWN_SERVICE_ERROR = "UNKNOWN_SERVICE_ERROR"
    case ALREADY_EXISTS_ERROR = "ALREADY_EXISTS_ERROR"
    case NOT_FOUND_ERROR = "NOT_FOUND_ERROR"
    case INTERNAL_SERVER_ERROR = "INTERNAL_SERVER_ERROR"
    case PERMISSION_ERROR = "PERMISSION_ERROR"
    case AUTHENTICATION_ERROR = "AUTHENTICATION_ERROR"
    case CANCELLED_ERROR = "CANCELLED_ERROR"
    case LIMIT_EXCEEDED_ERROR = "LIMIT_EXCEEDED_ERROR"
    case BAD_REQUEST_ERROR = "BAD_REQUEST_ERROR"
    case TIMEOUT_ERROR = "TIMEOUT_ERROR"
    case SERVER_UNAVAILABLE = "SERVER_UNAVAILABLE"
    case CLIENT_RESOURCE_EXHAUSTED = "CLIENT_RESOURCE_EXHAUSTED"
    case FAILED_PRECONDITION_ERROR = "FAILED_PRECONDITION_ERROR"
    case UNKNOWN_ERROR = "UNKNOWN_ERROR"
}

struct MomentoGrpcErrorDetails {
    let code: GRPCStatus
    let details: String
    // TODO: metadata?
}

struct MomentoErrorTransportDetails {
    let grpc: MomentoGrpcErrorDetails
}

public protocol ErrorResponseBaseProtocol {
    var message: String { get }
    var errorCode: MomentoErrorCode { get }
    var innerException: Error? { get }
}

public class SdkError: Error, ErrorResponseBaseProtocol {
    public let message: String
    public let errorCode: MomentoErrorCode
    public let innerException: Error?
    let transportDetails: MomentoErrorTransportDetails?
    let messageWrapper: String
    
    var description: String {
        return "\(self.errorCode): \(self.message)"
    }
    
    init(
        message: String,
        errorCode: MomentoErrorCode,
        innerException: Error? = nil,
        transportDetails: MomentoErrorTransportDetails? = nil,
        messageWrapper: String = ""
    ) {
        self.message = message
        self.errorCode = errorCode
        self.innerException = innerException
        self.transportDetails = transportDetails
        self.messageWrapper = messageWrapper
    }
}

public class AlreadyExistsError: SdkError {
    init(message: String, innerException: Error? = nil, transportDetails: MomentoErrorTransportDetails? = nil) {
        super.init(
            message: message,
            errorCode: MomentoErrorCode.BAD_REQUEST_ERROR,
            innerException: innerException,
            transportDetails: transportDetails,
            messageWrapper: "A cache with the specified name already exists. To resolve this error, either delete the existing cache and make a new one, or use a different name"
        )
    }
}

public class AuthenticationError: SdkError {
    init(message: String, innerException: Error? = nil, transportDetails: MomentoErrorTransportDetails? = nil) {
        super.init(
            message: message,
            errorCode: MomentoErrorCode.AUTHENTICATION_ERROR,
            innerException: innerException,
            transportDetails: transportDetails,
            messageWrapper: "Invalid authentication credentials to connect to cache service"
        )
    }
}

public class BadRequestError: SdkError {
    init(message: String, innerException: Error? = nil, transportDetails: MomentoErrorTransportDetails? = nil) {
        super.init(
            message: message,
            errorCode: MomentoErrorCode.BAD_REQUEST_ERROR,
            innerException: innerException,
            transportDetails: transportDetails,
            messageWrapper: "The request was invalid; please contact us at support@momentohq.com"
        )
    }
}

public class CancelledError: SdkError {
    init(message: String, innerException: Error? = nil, transportDetails: MomentoErrorTransportDetails? = nil) {
        super.init(
            message: message,
            errorCode: MomentoErrorCode.CANCELLED_ERROR,
            innerException: innerException,
            transportDetails: transportDetails,
            messageWrapper: "The request was cancelled by the server; please contact us at support@momentohq.com"
        )
    }
}

public class FailedPreconditionError: SdkError {
    init(message: String, innerException: Error? = nil, transportDetails: MomentoErrorTransportDetails? = nil) {
        super.init(
            message: message,
            errorCode: MomentoErrorCode.FAILED_PRECONDITION_ERROR,
            innerException: innerException,
            transportDetails: transportDetails,
            messageWrapper: "System is not in a state required for the operation's execution"
        )
    }
}

public class InternalServerError: SdkError {
    init(message: String, innerException: Error? = nil, transportDetails: MomentoErrorTransportDetails? = nil) {
        super.init(
            message: message,
            errorCode: MomentoErrorCode.INTERNAL_SERVER_ERROR,
            innerException: innerException,
            transportDetails: transportDetails,
            messageWrapper: "An unexpected error occurred while trying to fulfill the request; please contact us at support@momentohq.com"
        )
    }
}

public class InvalidArgumentError: SdkError {
    init(message: String, innerException: Error? = nil, transportDetails: MomentoErrorTransportDetails? = nil) {
        super.init(
            message: message,
            errorCode: MomentoErrorCode.INVALID_ARGUMENT_ERROR,
            innerException: innerException,
            transportDetails: transportDetails,
            messageWrapper: "Invalid argument passed to Momento client"
        )
    }
}

public class LimitExceededError: SdkError {
    init(message: String, innerException: Error? = nil, transportDetails: MomentoErrorTransportDetails? = nil) {
        super.init(
            message: message,
            errorCode: MomentoErrorCode.LIMIT_EXCEEDED_ERROR,
            innerException: innerException,
            transportDetails: transportDetails,
            messageWrapper: "Request rate, bandwidth, or object size exceeded the limits for this account. To resolve this error, reduce your usage as appropriate or contact us at support@momentohq.com to request a limit increase"
        )
    }
}

public class NotFoundError: SdkError {
    init(message: String, innerException: Error? = nil, transportDetails: MomentoErrorTransportDetails? = nil) {
        super.init(
            message: message,
            errorCode: MomentoErrorCode.NOT_FOUND_ERROR,
            innerException: innerException,
            transportDetails: transportDetails,
            messageWrapper: "A cache with the specified name does not exist. To resolve this error, make sure you have created the cache before attempting to use it"
        )
    }
}

public class PermissionDeniedError: SdkError {
    init(message: String, innerException: Error? = nil, transportDetails: MomentoErrorTransportDetails? = nil) {
        super.init(
            message: message,
            errorCode: MomentoErrorCode.PERMISSION_ERROR,
            innerException: innerException,
            transportDetails: transportDetails,
            messageWrapper: "Insufficient permissions to perform an operation on a cache"
        )
    }
}

public class TimeoutError: SdkError {
    init(message: String, innerException: Error? = nil, transportDetails: MomentoErrorTransportDetails? = nil) {
        super.init(
            message: message,
            errorCode: MomentoErrorCode.TIMEOUT_ERROR,
            innerException: innerException,
            transportDetails: transportDetails,
            messageWrapper: "The client's configured timeout was exceeded; you may need to use a Configuration with more lenient timeouts"
        )
    }
}

public class ServerUnavailableError: SdkError {
    init(message: String, innerException: Error? = nil, transportDetails: MomentoErrorTransportDetails? = nil) {
        super.init(
            message: message,
            errorCode: MomentoErrorCode.SERVER_UNAVAILABLE,
            innerException: innerException,
            transportDetails: transportDetails,
            messageWrapper: "The server was unable to handle the request; consider retrying. If the error persists, please contact us at support@momentohq.com"
        )
    }
}

public class UnknownError: SdkError {
    init(message: String, innerException: Error? = nil, transportDetails: MomentoErrorTransportDetails? = nil) {
        super.init(
            message: message,
            errorCode: MomentoErrorCode.UNKNOWN_ERROR,
            innerException: innerException,
            transportDetails: transportDetails,
            messageWrapper: "Unknown error has occurred"
        )
    }
}

public class UnknownServiceError: SdkError {
    init(message: String, innerException: Error? = nil, transportDetails: MomentoErrorTransportDetails? = nil) {
        super.init(
            message: message,
            errorCode: MomentoErrorCode.BAD_REQUEST_ERROR,
            innerException: innerException,
            transportDetails: transportDetails,
            messageWrapper: "Service returned an unknown response; please contact us at support@momentohq.com"
        )
    }
}

internal func grpcStatusToSdkError(grpcStatus: GRPCStatus) -> SdkError {
    let message = grpcStatus.message ?? "No message"
    switch grpcStatus.code {
    case .aborted:
        return InternalServerError(message: message, innerException: grpcStatus)
    case .alreadyExists:
        return AlreadyExistsError(message: message, innerException: grpcStatus)
    case .cancelled:
        return CancelledError(message: message, innerException: grpcStatus)
    case .dataLoss:
        return InternalServerError(message: message, innerException: grpcStatus)
    case .deadlineExceeded:
        return TimeoutError(message: message, innerException: grpcStatus)
    case .failedPrecondition:
        return FailedPreconditionError(message: message, innerException: grpcStatus)
    case .internalError:
        return InternalServerError(message: message, innerException: grpcStatus)
    case .invalidArgument:
        return InvalidArgumentError(message: message, innerException: grpcStatus)
    case .notFound:
        return NotFoundError(message: message, innerException: grpcStatus)
    case .outOfRange:
        return BadRequestError(message: message, innerException: grpcStatus)
    case .permissionDenied:
        return PermissionDeniedError(message:message, innerException: grpcStatus)
    case .resourceExhausted:
        return LimitExceededError(message: message, innerException: grpcStatus)
    case .unauthenticated:
        return AuthenticationError(message: message, innerException: grpcStatus)
    case .unavailable:
        return ServerUnavailableError(message: message, innerException: grpcStatus)
    case .unimplemented:
        return BadRequestError(message: message, innerException: grpcStatus)
    case .unknown:
        return UnknownServiceError(message: message, innerException: grpcStatus)
    default:
        return UnknownError(message: "Unknown error")
    }
}
