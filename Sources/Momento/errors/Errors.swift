import GRPC
import NIOHPACK
import SwiftProtobuf

public enum MomentoErrorCode: String {
    /// Invalid argument passed to Momento client
    case INVALID_ARGUMENT_ERROR = "INVALID_ARGUMENT_ERROR"
    /// Service returned an unknown response
    case UNKNOWN_SERVICE_ERROR = "UNKNOWN_SERVICE_ERROR"
    /// Resource with specified name already exists
    case ALREADY_EXISTS_ERROR = "ALREADY_EXISTS_ERROR"
    /// Cache with specified name doesn't exist
    case NOT_FOUND_ERROR = "NOT_FOUND_ERROR"
    /// An unexpected error occurred while trying to fulfill the request
    case INTERNAL_SERVER_ERROR = "INTERNAL_SERVER_ERROR"
    /// Insufficient permissions to perform operation
    case PERMISSION_ERROR = "PERMISSION_ERROR"
    /// Invalid authentication credentials to connect to service
    case AUTHENTICATION_ERROR = "AUTHENTICATION_ERROR"
    /// Request was cancelled by the server
    case CANCELLED_ERROR = "CANCELLED_ERROR"
    /// Request rate, bandwidth, or object size exceeded the limits for the account
    case LIMIT_EXCEEDED_ERROR = "LIMIT_EXCEEDED_ERROR"
    /// Request was invalid
    case BAD_REQUEST_ERROR = "BAD_REQUEST_ERROR"
    /// Client's configured timeout was exceeded
    case TIMEOUT_ERROR = "TIMEOUT_ERROR"
    /// Server was unable to handle the request
    case SERVER_UNAVAILABLE = "SERVER_UNAVAILABLE"
    /// A client resource (most likely memory) was exhausted
    case CLIENT_RESOURCE_EXHAUSTED = "CLIENT_RESOURCE_EXHAUSTED"
    /// System is not in a state required for the operation's execution
    case FAILED_PRECONDITION_ERROR = "FAILED_PRECONDITION_ERROR"
    /// Unknown error has occurred
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
    /// Detailed information about the error
    var message: String { get }
    /// Error code corresponding to one of the values of `MomentoErrorCode`
    var errorCode: MomentoErrorCode { get }
    /// Original `Error`, if any, from which the `SdkError` was created
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

    /**
    - Parameters:
        - message: detailed information about the error
        - errorCode: error code corresponding to one of the values of `MomentoErrorCode`
        - innerExecption: optional `Error` causing the `SdkError` to be returned
    */
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

/// Resource with specified name already exists
public class AlreadyExistsError: SdkError {
    init(
        message: String, innerException: Error? = nil,
        transportDetails: MomentoErrorTransportDetails? = nil
    ) {
        super.init(
            message: message,
            errorCode: MomentoErrorCode.BAD_REQUEST_ERROR,
            innerException: innerException,
            transportDetails: transportDetails,
            messageWrapper:
                "A cache with the specified name already exists. To resolve this error, either delete the existing cache and make a new one, or use a different name"
        )
    }
}

/// Invalid authentication credentials to connect to service
public class AuthenticationError: SdkError {
    init(
        message: String, innerException: Error? = nil,
        transportDetails: MomentoErrorTransportDetails? = nil
    ) {
        super.init(
            message: message,
            errorCode: MomentoErrorCode.AUTHENTICATION_ERROR,
            innerException: innerException,
            transportDetails: transportDetails,
            messageWrapper: "Invalid authentication credentials to connect to cache service"
        )
    }
}

/// Request was invalid
public class BadRequestError: SdkError {
    init(
        message: String, innerException: Error? = nil,
        transportDetails: MomentoErrorTransportDetails? = nil
    ) {
        super.init(
            message: message,
            errorCode: MomentoErrorCode.BAD_REQUEST_ERROR,
            innerException: innerException,
            transportDetails: transportDetails,
            messageWrapper: "The request was invalid; please contact us at support@momentohq.com"
        )
    }
}

/// Request was cancelled by the server
public class CancelledError: SdkError {
    init(
        message: String, innerException: Error? = nil,
        transportDetails: MomentoErrorTransportDetails? = nil
    ) {
        super.init(
            message: message,
            errorCode: MomentoErrorCode.CANCELLED_ERROR,
            innerException: innerException,
            transportDetails: transportDetails,
            messageWrapper:
                "The request was cancelled by the server; please contact us at support@momentohq.com"
        )
    }
}

/// System is not in a state required for the operation's execution
public class FailedPreconditionError: SdkError {
    init(
        message: String, innerException: Error? = nil,
        transportDetails: MomentoErrorTransportDetails? = nil
    ) {
        super.init(
            message: message,
            errorCode: MomentoErrorCode.FAILED_PRECONDITION_ERROR,
            innerException: innerException,
            transportDetails: transportDetails,
            messageWrapper: "System is not in a state required for the operation's execution"
        )
    }
}

/// An unexpected error occurred while trying to fulfill the request
public class InternalServerError: SdkError {
    init(
        message: String, innerException: Error? = nil,
        transportDetails: MomentoErrorTransportDetails? = nil
    ) {
        super.init(
            message: message,
            errorCode: MomentoErrorCode.INTERNAL_SERVER_ERROR,
            innerException: innerException,
            transportDetails: transportDetails,
            messageWrapper:
                "An unexpected error occurred while trying to fulfill the request; please contact us at support@momentohq.com"
        )
    }
}

/// Invalid argument passed to Momento client
public class InvalidArgumentError: SdkError {
    init(
        message: String, innerException: Error? = nil,
        transportDetails: MomentoErrorTransportDetails? = nil
    ) {
        super.init(
            message: message,
            errorCode: MomentoErrorCode.INVALID_ARGUMENT_ERROR,
            innerException: innerException,
            transportDetails: transportDetails,
            messageWrapper: "Invalid argument passed to Momento client"
        )
    }
}

/// Request rate, bandwidth, or object size exceeded the limits for the account
public class LimitExceededError: SdkError {
    init(
        message: String, innerException: Error? = nil,
        transportDetails: MomentoErrorTransportDetails? = nil, metadata: HPACKHeaders? = nil
    ) {
        super.init(
            message: message,
            errorCode: MomentoErrorCode.LIMIT_EXCEEDED_ERROR,
            innerException: innerException,
            transportDetails: transportDetails,
            messageWrapper: generateMessageFromMetadata(metadata: metadata, message: message)
        )
    }
}

func generateMessageFromMetadata(metadata: HPACKHeaders?, message: String) -> String {
    if let nonNilMetadata = metadata {
        let errMetadata = nonNilMetadata.first(name: "err") ?? ""
        return fromErrorCause(errorCause: errMetadata, message: message).rawValue
    }
    return fromErrorString(message: message).rawValue
}

func fromErrorCause(errorCause: String, message: String) -> LimitExceededMessageWrapper {
    switch errorCause {
    case "topic_subscriptions_limit_exceeded":
        return LimitExceededMessageWrapper.TOPIC_SUBSCRIPTIONS_LIMIT_EXCEEDED
    case "operations_rate_limit_exceeded":
        return LimitExceededMessageWrapper.OPERATIONS_RATE_LIMIT_EXCEEDED
    case "throughput_rate_limit_exceeded":
        return LimitExceededMessageWrapper.THROUGHPUT_RATE_LIMIT_EXCEEDED
    case "request_size_limit_exceeded":
        return LimitExceededMessageWrapper.REQUEST_SIZE_LIMIT_EXCEEDED
    case "item_size_limit_exceeded":
        return LimitExceededMessageWrapper.ITEM_SIZE_LIMIT_EXCEEDED
    case "element_size_limit_exceeded":
        return LimitExceededMessageWrapper.ELEMENT_SIZE_LIMIT_EXCEEDED
    default:
        return fromErrorString(message: message)
    }
}

func fromErrorString(message: String) -> LimitExceededMessageWrapper {
    let lowerCasedMessage: String = message.lowercased()
    if lowerCasedMessage.contains("subscribers") {
        return LimitExceededMessageWrapper.TOPIC_SUBSCRIPTIONS_LIMIT_EXCEEDED
    } else if lowerCasedMessage.contains("operations") {
        return LimitExceededMessageWrapper.OPERATIONS_RATE_LIMIT_EXCEEDED
    } else if lowerCasedMessage.contains("throughput") {
        return LimitExceededMessageWrapper.THROUGHPUT_RATE_LIMIT_EXCEEDED
    } else if lowerCasedMessage.contains("request limit") {
        return LimitExceededMessageWrapper.REQUEST_SIZE_LIMIT_EXCEEDED
    } else if lowerCasedMessage.contains("item size") {
        return LimitExceededMessageWrapper.ITEM_SIZE_LIMIT_EXCEEDED
    } else if lowerCasedMessage.contains("element size") {
        return LimitExceededMessageWrapper.ELEMENT_SIZE_LIMIT_EXCEEDED
    }
    return LimitExceededMessageWrapper.UNKNOWN_LIMIT_EXCEEDED
}

enum LimitExceededMessageWrapper: String {
    case TOPIC_SUBSCRIPTIONS_LIMIT_EXCEEDED = "Topic subscriptions limit exceeded for this account"
    case OPERATIONS_RATE_LIMIT_EXCEEDED = "Request rate limit exceeded for this account"
    case THROUGHPUT_RATE_LIMIT_EXCEEDED = "Bandwidth limit exceeded for this account"
    case REQUEST_SIZE_LIMIT_EXCEEDED = "Request size limit exceeded for this account"
    case ITEM_SIZE_LIMIT_EXCEEDED = "Item size limit exceeded for this account"
    case ELEMENT_SIZE_LIMIT_EXCEEDED = "Element size limit exceeded for this account"
    case UNKNOWN_LIMIT_EXCEEDED = "Limit exceeded for this account"
}

/// Cache with specified name doesn't exist
public class NotFoundError: SdkError {
    init(
        message: String, innerException: Error? = nil,
        transportDetails: MomentoErrorTransportDetails? = nil
    ) {
        super.init(
            message: message,
            errorCode: MomentoErrorCode.NOT_FOUND_ERROR,
            innerException: innerException,
            transportDetails: transportDetails,
            messageWrapper:
                "A cache with the specified name does not exist. To resolve this error, make sure you have created the cache before attempting to use it"
        )
    }
}

/// Insufficient permissions to perform operation
public class PermissionDeniedError: SdkError {
    init(
        message: String, innerException: Error? = nil,
        transportDetails: MomentoErrorTransportDetails? = nil
    ) {
        super.init(
            message: message,
            errorCode: MomentoErrorCode.PERMISSION_ERROR,
            innerException: innerException,
            transportDetails: transportDetails,
            messageWrapper: "Insufficient permissions to perform an operation on a cache"
        )
    }
}

/// Client's configured timeout was exceeded
public class TimeoutError: SdkError {
    init(
        message: String, innerException: Error? = nil,
        transportDetails: MomentoErrorTransportDetails? = nil
    ) {
        super.init(
            message: message,
            errorCode: MomentoErrorCode.TIMEOUT_ERROR,
            innerException: innerException,
            transportDetails: transportDetails,
            messageWrapper:
                "The client's configured timeout was exceeded; you may need to use a Configuration with more lenient timeouts"
        )
    }
}

/// Server was unable to handle the request
public class ServerUnavailableError: SdkError {
    init(
        message: String, innerException: Error? = nil,
        transportDetails: MomentoErrorTransportDetails? = nil
    ) {
        super.init(
            message: message,
            errorCode: MomentoErrorCode.SERVER_UNAVAILABLE,
            innerException: innerException,
            transportDetails: transportDetails,
            messageWrapper:
                "The server was unable to handle the request; consider retrying. If the error persists, please contact us at support@momentohq.com"
        )
    }
}

/// Unknown error has occurred
public class UnknownError: SdkError {
    init(
        message: String, innerException: Error? = nil,
        transportDetails: MomentoErrorTransportDetails? = nil
    ) {
        super.init(
            message: message,
            errorCode: MomentoErrorCode.UNKNOWN_ERROR,
            innerException: innerException,
            transportDetails: transportDetails,
            messageWrapper: "Unknown error has occurred"
        )
    }
}

/// Service returned an unknown response
public class UnknownServiceError: SdkError {
    init(
        message: String, innerException: Error? = nil,
        transportDetails: MomentoErrorTransportDetails? = nil
    ) {
        super.init(
            message: message,
            errorCode: MomentoErrorCode.BAD_REQUEST_ERROR,
            innerException: innerException,
            transportDetails: transportDetails,
            messageWrapper:
                "Service returned an unknown response; please contact us at support@momentohq.com"
        )
    }
}

func grpcStatusToSdkError(grpcStatus: GRPCStatus, metadata: HPACKHeaders? = nil) -> SdkError {
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
        return PermissionDeniedError(message: message, innerException: grpcStatus)
    case .resourceExhausted:
        return LimitExceededError(message: message, innerException: grpcStatus, metadata: metadata)
    case .unauthenticated:
        return AuthenticationError(message: message, innerException: grpcStatus)
    case .unavailable:
        return ServerUnavailableError(message: message, innerException: grpcStatus)
    case .unimplemented:
        return BadRequestError(message: message, innerException: grpcStatus)
    case .unknown:
        return UnknownServiceError(message: message, innerException: grpcStatus)
    default:
        return UnknownError(message: "Unknown error", innerException: grpcStatus)
    }
}

func processError<Request: Message & Sendable, Response: Message & Sendable>(
    err: GRPCStatus,
    call: UnaryCall<Request, Response>
) async -> SdkError {
    do {
        let trailers = try await call.trailingMetadata.get()
        return grpcStatusToSdkError(grpcStatus: err, metadata: trailers)
    } catch {
        return grpcStatusToSdkError(grpcStatus: err)
    }
}
