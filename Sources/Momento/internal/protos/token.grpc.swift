//
// DO NOT EDIT.
// swift-format-ignore-file
//
// Generated by the protocol buffer compiler.
// Source: token.proto
//
import GRPC
import NIO
import NIOConcurrencyHelpers
import SwiftProtobuf


/// Usage: instantiate `Token_TokenClient`, then call methods of this protocol to make API calls.
public protocol Token_TokenClientProtocol: GRPCClient {
  var serviceName: String { get }
  var interceptors: Token_TokenClientInterceptorFactoryProtocol? { get }

  func generateDisposableToken(
    _ request: Token__GenerateDisposableTokenRequest,
    callOptions: CallOptions?
  ) -> UnaryCall<Token__GenerateDisposableTokenRequest, Token__GenerateDisposableTokenResponse>
}

extension Token_TokenClientProtocol {
  public var serviceName: String {
    return "token.Token"
  }

  /// Unary call to GenerateDisposableToken
  ///
  /// - Parameters:
  ///   - request: Request to send to GenerateDisposableToken.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  public func generateDisposableToken(
    _ request: Token__GenerateDisposableTokenRequest,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<Token__GenerateDisposableTokenRequest, Token__GenerateDisposableTokenResponse> {
    return self.makeUnaryCall(
      path: Token_TokenClientMetadata.Methods.generateDisposableToken.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeGenerateDisposableTokenInterceptors() ?? []
    )
  }
}

@available(*, deprecated)
extension Token_TokenClient: @unchecked Sendable {}

@available(*, deprecated, renamed: "Token_TokenNIOClient")
public final class Token_TokenClient: Token_TokenClientProtocol {
  private let lock = Lock()
  private var _defaultCallOptions: CallOptions
  private var _interceptors: Token_TokenClientInterceptorFactoryProtocol?
  public let channel: GRPCChannel
  public var defaultCallOptions: CallOptions {
    get { self.lock.withLock { return self._defaultCallOptions } }
    set { self.lock.withLockVoid { self._defaultCallOptions = newValue } }
  }
  public var interceptors: Token_TokenClientInterceptorFactoryProtocol? {
    get { self.lock.withLock { return self._interceptors } }
    set { self.lock.withLockVoid { self._interceptors = newValue } }
  }

  /// Creates a client for the token.Token service.
  ///
  /// - Parameters:
  ///   - channel: `GRPCChannel` to the service host.
  ///   - defaultCallOptions: Options to use for each service call if the user doesn't provide them.
  ///   - interceptors: A factory providing interceptors for each RPC.
  public init(
    channel: GRPCChannel,
    defaultCallOptions: CallOptions = CallOptions(),
    interceptors: Token_TokenClientInterceptorFactoryProtocol? = nil
  ) {
    self.channel = channel
    self._defaultCallOptions = defaultCallOptions
    self._interceptors = interceptors
  }
}

public struct Token_TokenNIOClient: Token_TokenClientProtocol {
  public var channel: GRPCChannel
  public var defaultCallOptions: CallOptions
  public var interceptors: Token_TokenClientInterceptorFactoryProtocol?

  /// Creates a client for the token.Token service.
  ///
  /// - Parameters:
  ///   - channel: `GRPCChannel` to the service host.
  ///   - defaultCallOptions: Options to use for each service call if the user doesn't provide them.
  ///   - interceptors: A factory providing interceptors for each RPC.
  public init(
    channel: GRPCChannel,
    defaultCallOptions: CallOptions = CallOptions(),
    interceptors: Token_TokenClientInterceptorFactoryProtocol? = nil
  ) {
    self.channel = channel
    self.defaultCallOptions = defaultCallOptions
    self.interceptors = interceptors
  }
}

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
public protocol Token_TokenAsyncClientProtocol: GRPCClient {
  static var serviceDescriptor: GRPCServiceDescriptor { get }
  var interceptors: Token_TokenClientInterceptorFactoryProtocol? { get }

  func makeGenerateDisposableTokenCall(
    _ request: Token__GenerateDisposableTokenRequest,
    callOptions: CallOptions?
  ) -> GRPCAsyncUnaryCall<Token__GenerateDisposableTokenRequest, Token__GenerateDisposableTokenResponse>
}

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
extension Token_TokenAsyncClientProtocol {
  public static var serviceDescriptor: GRPCServiceDescriptor {
    return Token_TokenClientMetadata.serviceDescriptor
  }

  public var interceptors: Token_TokenClientInterceptorFactoryProtocol? {
    return nil
  }

  public func makeGenerateDisposableTokenCall(
    _ request: Token__GenerateDisposableTokenRequest,
    callOptions: CallOptions? = nil
  ) -> GRPCAsyncUnaryCall<Token__GenerateDisposableTokenRequest, Token__GenerateDisposableTokenResponse> {
    return self.makeAsyncUnaryCall(
      path: Token_TokenClientMetadata.Methods.generateDisposableToken.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeGenerateDisposableTokenInterceptors() ?? []
    )
  }
}

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
extension Token_TokenAsyncClientProtocol {
  public func generateDisposableToken(
    _ request: Token__GenerateDisposableTokenRequest,
    callOptions: CallOptions? = nil
  ) async throws -> Token__GenerateDisposableTokenResponse {
    return try await self.performAsyncUnaryCall(
      path: Token_TokenClientMetadata.Methods.generateDisposableToken.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeGenerateDisposableTokenInterceptors() ?? []
    )
  }
}

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
public struct Token_TokenAsyncClient: Token_TokenAsyncClientProtocol {
  public var channel: GRPCChannel
  public var defaultCallOptions: CallOptions
  public var interceptors: Token_TokenClientInterceptorFactoryProtocol?

  public init(
    channel: GRPCChannel,
    defaultCallOptions: CallOptions = CallOptions(),
    interceptors: Token_TokenClientInterceptorFactoryProtocol? = nil
  ) {
    self.channel = channel
    self.defaultCallOptions = defaultCallOptions
    self.interceptors = interceptors
  }
}

public protocol Token_TokenClientInterceptorFactoryProtocol: Sendable {

  /// - Returns: Interceptors to use when invoking 'generateDisposableToken'.
  func makeGenerateDisposableTokenInterceptors() -> [ClientInterceptor<Token__GenerateDisposableTokenRequest, Token__GenerateDisposableTokenResponse>]
}

public enum Token_TokenClientMetadata {
  public static let serviceDescriptor = GRPCServiceDescriptor(
    name: "Token",
    fullName: "token.Token",
    methods: [
      Token_TokenClientMetadata.Methods.generateDisposableToken,
    ]
  )

  public enum Methods {
    public static let generateDisposableToken = GRPCMethodDescriptor(
      name: "GenerateDisposableToken",
      path: "/token.Token/GenerateDisposableToken",
      type: GRPCCallType.unary
    )
  }
}

/// To build a server, implement a class that conforms to this protocol.
public protocol Token_TokenProvider: CallHandlerProvider {
  var interceptors: Token_TokenServerInterceptorFactoryProtocol? { get }

  func generateDisposableToken(request: Token__GenerateDisposableTokenRequest, context: StatusOnlyCallContext) -> EventLoopFuture<Token__GenerateDisposableTokenResponse>
}

extension Token_TokenProvider {
  public var serviceName: Substring {
    return Token_TokenServerMetadata.serviceDescriptor.fullName[...]
  }

  /// Determines, calls and returns the appropriate request handler, depending on the request's method.
  /// Returns nil for methods not handled by this service.
  public func handle(
    method name: Substring,
    context: CallHandlerContext
  ) -> GRPCServerHandlerProtocol? {
    switch name {
    case "GenerateDisposableToken":
      return UnaryServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Token__GenerateDisposableTokenRequest>(),
        responseSerializer: ProtobufSerializer<Token__GenerateDisposableTokenResponse>(),
        interceptors: self.interceptors?.makeGenerateDisposableTokenInterceptors() ?? [],
        userFunction: self.generateDisposableToken(request:context:)
      )

    default:
      return nil
    }
  }
}

/// To implement a server, implement an object which conforms to this protocol.
@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
public protocol Token_TokenAsyncProvider: CallHandlerProvider, Sendable {
  static var serviceDescriptor: GRPCServiceDescriptor { get }
  var interceptors: Token_TokenServerInterceptorFactoryProtocol? { get }

  func generateDisposableToken(
    request: Token__GenerateDisposableTokenRequest,
    context: GRPCAsyncServerCallContext
  ) async throws -> Token__GenerateDisposableTokenResponse
}

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
extension Token_TokenAsyncProvider {
  public static var serviceDescriptor: GRPCServiceDescriptor {
    return Token_TokenServerMetadata.serviceDescriptor
  }

  public var serviceName: Substring {
    return Token_TokenServerMetadata.serviceDescriptor.fullName[...]
  }

  public var interceptors: Token_TokenServerInterceptorFactoryProtocol? {
    return nil
  }

  public func handle(
    method name: Substring,
    context: CallHandlerContext
  ) -> GRPCServerHandlerProtocol? {
    switch name {
    case "GenerateDisposableToken":
      return GRPCAsyncServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Token__GenerateDisposableTokenRequest>(),
        responseSerializer: ProtobufSerializer<Token__GenerateDisposableTokenResponse>(),
        interceptors: self.interceptors?.makeGenerateDisposableTokenInterceptors() ?? [],
        wrapping: { try await self.generateDisposableToken(request: $0, context: $1) }
      )

    default:
      return nil
    }
  }
}

public protocol Token_TokenServerInterceptorFactoryProtocol: Sendable {

  /// - Returns: Interceptors to use when handling 'generateDisposableToken'.
  ///   Defaults to calling `self.makeInterceptors()`.
  func makeGenerateDisposableTokenInterceptors() -> [ServerInterceptor<Token__GenerateDisposableTokenRequest, Token__GenerateDisposableTokenResponse>]
}

public enum Token_TokenServerMetadata {
  public static let serviceDescriptor = GRPCServiceDescriptor(
    name: "Token",
    fullName: "token.Token",
    methods: [
      Token_TokenServerMetadata.Methods.generateDisposableToken,
    ]
  )

  public enum Methods {
    public static let generateDisposableToken = GRPCMethodDescriptor(
      name: "GenerateDisposableToken",
      path: "/token.Token/GenerateDisposableToken",
      type: GRPCCallType.unary
    )
  }
}
