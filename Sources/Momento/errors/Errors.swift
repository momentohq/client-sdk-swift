import GRPC
import NIOHPACK
import SwiftProtobuf

public enum MomentoErrorCode: String, Sendable {
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

struct MomentoGrpcErrorDetails: Sendable {
    let code: GRPCStatus
    let details: String
    // TODO: metadata?
}

struct MomentoErrorTransportDetails: Sendable {
    let grpc: MomentoGrpcErrorDetails
}

public protocol ErrorResponseBaseProtocol: Error, Sendable {
    /// Detailed information about the error
    var message: String { get }
    /// Error code corresponding to one of the values of `MomentoErrorCode`
    var errorCode: MomentoErrorCode { get }
    /// Original `Error`, if any, from which the `SdkError` was created
    var innerException: Error? { get }
    /// Description of the error
    func description() -> String
}

extension ErrorResponseBaseProtocol {
    public func description() -> String {
        return "[\(self.errorCode)] \(self.message)"
    }
}

/// Resource with specified name already exists
public struct AlreadyExistsError: ErrorResponseBaseProtocol, Sendable {
    public var message: String
    public var errorCode = MomentoErrorCode.BAD_REQUEST_ERROR
    public var innerException: (any Error)?
    public var messageWrapper =
        "A cache with the specified name already exists. To resolve this error, either delete the existing cache and make a new one, or use a different name"
    private var transportDetails: MomentoErrorTransportDetails?

    init(
        message: String, innerException: Error? = nil,
        transportDetails: MomentoErrorTransportDetails? = nil
    ) {
        self.message = message
        self.innerException = innerException
        self.transportDetails = transportDetails

    }
}

/// Invalid authentication credentials to connect to service
public struct AuthenticationError: ErrorResponseBaseProtocol, Sendable {
    public var message: String
    public var errorCode = MomentoErrorCode.AUTHENTICATION_ERROR
    public var innerException: (any Error)?
    public var messageWrapper = "Invalid authentication credentials to connect to cache service"
    private var transportDetails: MomentoErrorTransportDetails?

    init(
        message: String, innerException: Error? = nil,
        transportDetails: MomentoErrorTransportDetails? = nil
    ) {
        self.message = message
        self.innerException = innerException
        self.transportDetails = transportDetails
    }
}

/// Request was invalid
public struct BadRequestError: ErrorResponseBaseProtocol, Sendable {
    public var message: String
    public var errorCode = MomentoErrorCode.BAD_REQUEST_ERROR
    public var innerException: (any Error)?
    public var messageWrapper =
        "The request was invalid; please contact us at support@momentohq.com"
    private var transportDetails: MomentoErrorTransportDetails?

    init(
        message: String, innerException: Error? = nil,
        transportDetails: MomentoErrorTransportDetails? = nil
    ) {
        self.message = message
        self.innerException = innerException
        self.transportDetails = transportDetails
    }
}

/// Request was cancelled by the server
public struct CancelledError: ErrorResponseBaseProtocol, Sendable {
    public var message: String
    public var errorCode = MomentoErrorCode.CANCELLED_ERROR
    public var innerException: (any Error)?
    public var messageWrapper =
        "The request was cancelled by the server; please contact us at support@momentohq.com"
    private var transportDetails: MomentoErrorTransportDetails?

    init(
        message: String, innerException: Error? = nil,
        transportDetails: MomentoErrorTransportDetails? = nil
    ) {
        self.message = message
        self.innerException = innerException
        self.transportDetails = transportDetails
    }
}

/// System is not in a state required for the operation's execution
public struct FailedPreconditionError: ErrorResponseBaseProtocol, Sendable {
    public var message: String
    public var errorCode = MomentoErrorCode.FAILED_PRECONDITION_ERROR
    public var innerException: (any Error)?
    public var messageWrapper =
        "System is not in a state required for the operation's execution"
    private var transportDetails: MomentoErrorTransportDetails?

    init(
        message: String, innerException: Error? = nil,
        transportDetails: MomentoErrorTransportDetails? = nil
    ) {
        self.message = message
        self.innerException = innerException
        self.transportDetails = transportDetails
    }
}

/// An unexpected error occurred while trying to fulfill the request
public struct InternalServerError: ErrorResponseBaseProtocol, Sendable {
    public var message: String
    public var errorCode = MomentoErrorCode.INTERNAL_SERVER_ERROR
    public var innerException: (any Error)?
    public var messageWrapper =
        "An unexpected error occurred while trying to fulfill the request; please contact us at support@momentohq.com"
    private var transportDetails: MomentoErrorTransportDetails?

    init(
        message: String, innerException: Error? = nil,
        transportDetails: MomentoErrorTransportDetails? = nil
    ) {
        self.message = message
        self.innerException = innerException
        self.transportDetails = transportDetails
    }
}

/// Invalid argument passed to Momento client
public struct InvalidArgumentError: ErrorResponseBaseProtocol, Sendable {
    public var message: String
    public var errorCode = MomentoErrorCode.INVALID_ARGUMENT_ERROR
    public var innerException: (any Error)?
    public var messageWrapper =
        "Invalid argument passed to Momento client"
    private var transportDetails: MomentoErrorTransportDetails?

    init(
        message: String, innerException: Error? = nil,
        transportDetails: MomentoErrorTransportDetails? = nil
    ) {
        self.message = message
        self.innerException = innerException
        self.transportDetails = transportDetails
    }
}

/// Request rate, bandwidth, or object size exceeded the limits for the account
public struct LimitExceededError: ErrorResponseBaseProtocol, Sendable {
    public var message: String
    public var errorCode = MomentoErrorCode.LIMIT_EXCEEDED_ERROR
    public var innerException: (any Error)?
    public var messageWrapper =
        "Invalid argument passed to Momento client"
    private var transportDetails: MomentoErrorTransportDetails?

    init(
        message: String, innerException: Error? = nil,
        transportDetails: MomentoErrorTransportDetails? = nil, metadata: HPACKHeaders? = nil
    ) {
        self.message = message
        self.innerException = innerException
        self.transportDetails = transportDetails
        self.messageWrapper = generateMessageFromMetadata(metadata: metadata, message: message)
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
public struct NotFoundError: ErrorResponseBaseProtocol, Sendable {
    public var message: String
    public var errorCode = MomentoErrorCode.NOT_FOUND_ERROR
    public var innerException: (any Error)?
    public var messageWrapper =
        "A cache with the specified name does not exist. To resolve this error, make sure you have created the cache before attempting to use it"
    private var transportDetails: MomentoErrorTransportDetails?

    init(
        message: String, innerException: Error? = nil,
        transportDetails: MomentoErrorTransportDetails? = nil
    ) {
        self.message = message
        self.innerException = innerException
        self.transportDetails = transportDetails
    }
}

/// Insufficient permissions to perform operation
public struct PermissionDeniedError: ErrorResponseBaseProtocol, Sendable {
    public var message: String
    public var errorCode = MomentoErrorCode.PERMISSION_ERROR
    public var innerException: (any Error)?
    public var messageWrapper = "Insufficient permissions to perform an operation on a cache"
    private var transportDetails: MomentoErrorTransportDetails?

    init(
        message: String, innerException: Error? = nil,
        transportDetails: MomentoErrorTransportDetails? = nil
    ) {
        self.message = message
        self.innerException = innerException
        self.transportDetails = transportDetails
    }
}

/// Client's configured timeout was exceeded
public struct TimeoutError: ErrorResponseBaseProtocol, Sendable {
    public var message: String
    public var errorCode = MomentoErrorCode.TIMEOUT_ERROR
    public var innerException: (any Error)?
    public var messageWrapper =
        "The client's configured timeout was exceeded; you may need to use a Configuration with more lenient timeouts"
    private var transportDetails: MomentoErrorTransportDetails?

    init(
        message: String, innerException: Error? = nil,
        transportDetails: MomentoErrorTransportDetails? = nil
    ) {
        self.message = message
        self.innerException = innerException
        self.transportDetails = transportDetails
    }
}

/// Server was unable to handle the request
public struct ServerUnavailableError: ErrorResponseBaseProtocol, Sendable {
    public var message: String
    public var errorCode = MomentoErrorCode.SERVER_UNAVAILABLE
    public var innerException: (any Error)?
    public var messageWrapper =
        "The server was unable to handle the request; consider retrying. If the error persists, please contact us at support@momentohq.com"
    private var transportDetails: MomentoErrorTransportDetails?

    init(
        message: String, innerException: Error? = nil,
        transportDetails: MomentoErrorTransportDetails? = nil
    ) {
        self.message = message
        self.innerException = innerException
        self.transportDetails = transportDetails
    }
}

/// Unknown error has occurred
public struct UnknownError: ErrorResponseBaseProtocol, Sendable {
    public var message: String
    public var errorCode = MomentoErrorCode.UNKNOWN_ERROR
    public var innerException: (any Error)?
    public var messageWrapper = "Unknown error has occurred"
    private var transportDetails: MomentoErrorTransportDetails?

    init(
        message: String, innerException: Error? = nil,
        transportDetails: MomentoErrorTransportDetails? = nil
    ) {
        self.message = message
        self.innerException = innerException
        self.transportDetails = transportDetails
    }
}

/// Service returned an unknown response
public struct UnknownServiceError: ErrorResponseBaseProtocol, Sendable {
    public var message: String
    public var errorCode = MomentoErrorCode.UNKNOWN_SERVICE_ERROR
    public var innerException: (any Error)?
    public var messageWrapper =
        "Service returned an unknown response; please contact us at support@momentohq.com"
    private var transportDetails: MomentoErrorTransportDetails?

    init(
        message: String, innerException: Error? = nil,
        transportDetails: MomentoErrorTransportDetails? = nil
    ) {
        self.message = message
        self.innerException = innerException
        self.transportDetails = transportDetails
    }
}

func grpcStatusToSdkError(grpcStatus: GRPCStatus, metadata: HPACKHeaders? = nil) -> SdkError {
    let message = grpcStatus.message ?? "No message"
    switch grpcStatus.code {
    case .aborted:
        return SdkError.InternalServerError(
            InternalServerError(message: message, innerException: grpcStatus))
    case .alreadyExists:
        return SdkError.AlreadyExistsError(
            AlreadyExistsError(message: message, innerException: grpcStatus))
    case .cancelled:
        return SdkError.CancelledError(
            CancelledError(message: message, innerException: grpcStatus))
    case .dataLoss:
        return SdkError.InternalServerError(
            InternalServerError(message: message, innerException: grpcStatus))
    case .deadlineExceeded:
        return SdkError.TimeoutError(
            TimeoutError(message: message, innerException: grpcStatus))
    case .failedPrecondition:
        return SdkError.FailedPreconditionError(
            FailedPreconditionError(message: message, innerException: grpcStatus))
    case .internalError:
        return SdkError.InternalServerError(
            InternalServerError(message: message, innerException: grpcStatus))
    case .invalidArgument:
        return SdkError.InvalidArgumentError(
            InvalidArgumentError(message: message, innerException: grpcStatus))
    case .notFound:
        return SdkError.NotFoundError(
            NotFoundError(message: message, innerException: grpcStatus))
    case .outOfRange:
        return SdkError.BadRequestError(
            BadRequestError(message: message, innerException: grpcStatus))
    case .permissionDenied:
        return SdkError.PermissionDeniedError(
            PermissionDeniedError(message: message, innerException: grpcStatus))
    case .resourceExhausted:
        return SdkError.LimitExceededError(
            LimitExceededError(message: message, innerException: grpcStatus, metadata: metadata))
    case .unauthenticated:
        return SdkError.AuthenticationError(
            AuthenticationError(message: message, innerException: grpcStatus))
    case .unavailable:
        return SdkError.ServerUnavailableError(
            ServerUnavailableError(message: message, innerException: grpcStatus))
    case .unimplemented:
        return SdkError.BadRequestError(
            BadRequestError(message: message, innerException: grpcStatus))
    case .unknown:
        return SdkError.UnknownServiceError(
            UnknownServiceError(message: message, innerException: grpcStatus))
    default:
        return SdkError.UnknownError(
            UnknownError(message: "Unknown error", innerException: grpcStatus))
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

public enum SdkError: Error, Sendable {
    case AlreadyExistsError(AlreadyExistsError)
    case AuthenticationError(AuthenticationError)
    case BadRequestError(BadRequestError)
    case CancelledError(CancelledError)
    case FailedPreconditionError(FailedPreconditionError)
    case InternalServerError(InternalServerError)
    case InvalidArgumentError(InvalidArgumentError)
    case LimitExceededError(LimitExceededError)
    case NotFoundError(NotFoundError)
    case PermissionDeniedError(PermissionDeniedError)
    case TimeoutError(TimeoutError)
    case ServerUnavailableError(ServerUnavailableError)
    case UnknownError(UnknownError)
    case UnknownServiceError(UnknownServiceError)
}

extension SdkError: ErrorResponseBaseProtocol {
    public var message: String {
        switch self {
        case .AlreadyExistsError(let err):
            return err.message
        case .AuthenticationError(let err):
            return err.message
        case .BadRequestError(let err):
            return err.message
        case .CancelledError(let err):
            return err.message
        case .FailedPreconditionError(let err):
            return err.message
        case .InternalServerError(let err):
            return err.message
        case .InvalidArgumentError(let err):
            return err.message
        case .LimitExceededError(let err):
            return err.message
        case .NotFoundError(let err):
            return err.message
        case .PermissionDeniedError(let err):
            return err.message
        case .TimeoutError(let err):
            return err.message
        case .ServerUnavailableError(let err):
            return err.message
        case .UnknownError(let err):
            return err.message
        case .UnknownServiceError(let err):
            return err.message
        }
    }

    public var errorCode: MomentoErrorCode {
        switch self {
        case .AlreadyExistsError(let err):
            return err.errorCode
        case .AuthenticationError(let err):
            return err.errorCode
        case .BadRequestError(let err):
            return err.errorCode
        case .CancelledError(let err):
            return err.errorCode
        case .FailedPreconditionError(let err):
            return err.errorCode
        case .InternalServerError(let err):
            return err.errorCode
        case .InvalidArgumentError(let err):
            return err.errorCode
        case .LimitExceededError(let err):
            return err.errorCode
        case .NotFoundError(let err):
            return err.errorCode
        case .PermissionDeniedError(let err):
            return err.errorCode
        case .TimeoutError(let err):
            return err.errorCode
        case .ServerUnavailableError(let err):
            return err.errorCode
        case .UnknownError(let err):
            return err.errorCode
        case .UnknownServiceError(let err):
            return err.errorCode
        }
    }

    public var innerException: Error? {
        switch self {
        case .AlreadyExistsError(let err):
            return err.innerException
        case .AuthenticationError(let err):
            return err.innerException
        case .BadRequestError(let err):
            return err.innerException
        case .CancelledError(let err):
            return err.innerException
        case .FailedPreconditionError(let err):
            return err.innerException
        case .InternalServerError(let err):
            return err.innerException
        case .InvalidArgumentError(let err):
            return err.innerException
        case .LimitExceededError(let err):
            return err.innerException
        case .NotFoundError(let err):
            return err.innerException
        case .PermissionDeniedError(let err):
            return err.innerException
        case .TimeoutError(let err):
            return err.innerException
        case .ServerUnavailableError(let err):
            return err.innerException
        case .UnknownError(let err):
            return err.innerException
        case .UnknownServiceError(let err):
            return err.innerException
        }
    }
}
