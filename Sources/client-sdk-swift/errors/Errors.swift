import GRPC

enum MomentoErrorCode {
    case INVALID_ARGUMENT_ERROR
    case UNKNOWN_SERVICE_ERROR
    case ALREADY_EXISTS_ERROR
    case NOT_FOUND_ERROR
    case INTERNAL_SERVER_ERROR
    case PERMISSION_ERROR
    case AUTHENTICATION_ERROR
    case CANCELLED_ERROR
    case LIMIT_EXCEEDED_ERROR
    case BAD_REQUEST_ERROR
    case TIMEOUT_ERROR
    case SERVER_UNAVAILABLE
    case CLIENT_RESOURCE_EXHAUSTED
    case FAILED_PRECONDITION_ERROR
    case UNKNOWN_ERROR
}

struct MomentoGrpcErrorDetails {
    let code: GRPCStatus
    let details: String
    // TODO: metadata?
}

struct MomentoErrorTransportDetails {
    let grpc: MomentoGrpcErrorDetails
}

class SdkError: Error {
    let message: String
    let errorCode: MomentoErrorCode
    let transportDetails: MomentoErrorTransportDetails?
    let messageWrapper: String
    
    init(
        message: String,
        errorCode: MomentoErrorCode,
        transportDetails: MomentoErrorTransportDetails? = nil,
        messageWrapper: String = ""
    ) {
        self.message = message
        self.errorCode = errorCode
        self.transportDetails = transportDetails
        self.messageWrapper = messageWrapper
    }
}

class AlreadyExistsError: SdkError {
    init(message: String, transportDetails: MomentoErrorTransportDetails? = nil) {
        super.init(
            message: message,
            errorCode: MomentoErrorCode.BAD_REQUEST_ERROR,
            transportDetails: transportDetails,
            messageWrapper: "A cache with the specified name already exists. To resolve this error, either delete the existing cache and make a new one, or use a different name"
        )
    }
}

class AuthenticationError: SdkError {
    init(message: String, transportDetails: MomentoErrorTransportDetails? = nil) {
        super.init(
            message: message,
            errorCode: MomentoErrorCode.AUTHENTICATION_ERROR,
            transportDetails: transportDetails,
            messageWrapper: "Invalid authentication credentials to connect to cache service"
        )
    }
}

class BadRequestError: SdkError {
    init(message: String, transportDetails: MomentoErrorTransportDetails? = nil) {
        super.init(
            message: message,
            errorCode: MomentoErrorCode.BAD_REQUEST_ERROR,
            transportDetails: transportDetails,
            messageWrapper: "The request was invalid; please contact us at support@momentohq.com"
        )
    }
}

class CancelledError: SdkError {
    init(message: String, transportDetails: MomentoErrorTransportDetails? = nil) {
        super.init(
            message: message,
            errorCode: MomentoErrorCode.CANCELLED_ERROR,
            transportDetails: transportDetails,
            messageWrapper: "The request was cancelled by the server; please contact us at support@momentohq.com"
        )
    }
}

class FailedPreconditionError: SdkError {
    init(message: String, transportDetails: MomentoErrorTransportDetails? = nil) {
        super.init(
            message: message,
            errorCode: MomentoErrorCode.FAILED_PRECONDITION_ERROR,
            transportDetails: transportDetails,
            messageWrapper: "System is not in a state required for the operation's execution"
        )
    }
}

class InternalServerError: SdkError {
    init(message: String, transportDetails: MomentoErrorTransportDetails? = nil) {
        super.init(
            message: message,
            errorCode: MomentoErrorCode.INTERNAL_SERVER_ERROR,
            transportDetails: transportDetails,
            messageWrapper: "An unexpected error occurred while trying to fulfill the request; please contact us at support@momentohq.com"
        )
    }
}

class InvalidArgumentError: SdkError {
    init(message: String, transportDetails: MomentoErrorTransportDetails? = nil) {
        super.init(
            message: message,
            errorCode: MomentoErrorCode.INVALID_ARGUMENT_ERROR,
            transportDetails: transportDetails,
            messageWrapper: "Invalid argument passed to Momento client"
        )
    }
}

class LimitExceededError: SdkError {
    init(message: String, transportDetails: MomentoErrorTransportDetails? = nil) {
        super.init(
            message: message,
            errorCode: MomentoErrorCode.LIMIT_EXCEEDED_ERROR,
            transportDetails: transportDetails,
            messageWrapper: "Request rate, bandwidth, or object size exceeded the limits for this account. To resolve this error, reduce your usage as appropriate or contact us at support@momentohq.com to request a limit increase"
        )
    }
}

class NotFoundError: SdkError {
    init(message: String, transportDetails: MomentoErrorTransportDetails? = nil) {
        super.init(
            message: message,
            errorCode: MomentoErrorCode.NOT_FOUND_ERROR,
            transportDetails: transportDetails,
            messageWrapper: "A cache with the specified name does not exist. To resolve this error, make sure you have created the cache before attempting to use it"
        )
    }
}

class PermissionDeniedError: SdkError {
    init(message: String, transportDetails: MomentoErrorTransportDetails? = nil) {
        super.init(
            message: message,
            errorCode: MomentoErrorCode.PERMISSION_ERROR,
            transportDetails: transportDetails,
            messageWrapper: "Insufficient permissions to perform an operation on a cache"
        )
    }
}

class TimeoutError: SdkError {
    init(message: String, transportDetails: MomentoErrorTransportDetails? = nil) {
        super.init(
            message: message,
            errorCode: MomentoErrorCode.TIMEOUT_ERROR,
            transportDetails: transportDetails,
            messageWrapper: "The client's configured timeout was exceeded; you may need to use a Configuration with more lenient timeouts"
        )
    }
}

class ServerUnavailableError: SdkError {
    init(message: String, transportDetails: MomentoErrorTransportDetails? = nil) {
        super.init(
            message: message,
            errorCode: MomentoErrorCode.SERVER_UNAVAILABLE,
            transportDetails: transportDetails,
            messageWrapper: "The server was unable to handle the request; consider retrying. If the error persists, please contact us at support@momentohq.com"
        )
    }
}

class UnknownError: SdkError {
    init(message: String, transportDetails: MomentoErrorTransportDetails? = nil) {
        super.init(
            message: message,
            errorCode: MomentoErrorCode.UNKNOWN_ERROR,
            transportDetails: transportDetails,
            messageWrapper: "Unknown error has occurred"
        )
    }
}

class UnknownServiceError: SdkError {
    init(message: String, transportDetails: MomentoErrorTransportDetails? = nil) {
        super.init(
            message: message,
            errorCode: MomentoErrorCode.BAD_REQUEST_ERROR,
            transportDetails: transportDetails,
            messageWrapper: "Service returned an unknown response; please contact us at support@momentohq.com"
        )
    }
}

internal func grpcStatusToSdkError(grpcStatus: GRPCStatus) -> SdkError {
    let message = grpcStatus.message ?? "No message"
    switch grpcStatus.code {
    case .aborted:
        return InternalServerError(message: message)
    case .alreadyExists:
        return AlreadyExistsError(message: message)
    case .cancelled:
        return CancelledError(message: message)
    case .dataLoss:
        return InternalServerError(message: message)
    case .deadlineExceeded:
        return TimeoutError(message: message)
    case .failedPrecondition:
        return FailedPreconditionError(message: message)
    case .internalError:
        return InternalServerError(message: message)
    case .invalidArgument:
        return InvalidArgumentError(message: message)
    case .notFound:
        return NotFoundError(message: message)
    case .outOfRange:
        return BadRequestError(message: message)
    case .permissionDenied:
        return PermissionDeniedError(message:message)
    case .resourceExhausted:
        return LimitExceededError(message: message)
    case .unauthenticated:
        return AuthenticationError(message: message)
    case .unavailable:
        return ServerUnavailableError(message: message)
    case .unimplemented:
        return BadRequestError(message: message)
    case .unknown:
        return UnknownServiceError(message: message)
    default:
        return UnknownError(message: "Unknown error")
    }
}
