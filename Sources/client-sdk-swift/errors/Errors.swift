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
            errorCode: MomentoErrorCode.ALREADY_EXISTS_ERROR,
            transportDetails: transportDetails,
            messageWrapper: "A cache with the specified name already exists. To resolve this error, either delete the existing cache and make a new one, or use a different name"
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

internal func grpcStatusToSdkError(grpcStatus: GRPCStatus) -> SdkError {
    let message = grpcStatus.message ?? "No message"
    switch grpcStatus.code {
    case .aborted, .dataLoss:
        return InternalServerError(message: message)
    case .alreadyExists:
        return AlreadyExistsError(message: message)
    case .cancelled:
        return CancelledError(message: message)
    case .deadlineExceeded:
        return TimeoutError(message: message)
    case .notFound:
        return NotFoundError(message: message)
    default:
        return UnknownError(message: "Unknown error")
    }
}
