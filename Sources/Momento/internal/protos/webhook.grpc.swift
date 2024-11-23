//
// DO NOT EDIT.
// swift-format-ignore-file
//
// Generated by the protocol buffer compiler.
// Source: webhook.proto
//
import GRPC
import NIO
import NIOConcurrencyHelpers
import SwiftProtobuf


/// A Webhook is a mechanism to consume messages on a Topic.
/// The primary purpose of webhooks in Momento is to enable
/// Lambda to be a subscriber to the messages sent on a topic.
/// Secondarily, webhooks open us up to a whole lot of integrations
/// (slack, discord, event bridge, etc).
///
/// Usage: instantiate `Webhook_WebhookClient`, then call methods of this protocol to make API calls.
public protocol Webhook_WebhookClientProtocol: GRPCClient {
  var serviceName: String { get }
  var interceptors: Webhook_WebhookClientInterceptorFactoryProtocol? { get }

  func putWebhook(
    _ request: Webhook__PutWebhookRequest,
    callOptions: CallOptions?
  ) -> UnaryCall<Webhook__PutWebhookRequest, Webhook__PutWebhookResponse>

  func deleteWebhook(
    _ request: Webhook__DeleteWebhookRequest,
    callOptions: CallOptions?
  ) -> UnaryCall<Webhook__DeleteWebhookRequest, Webhook__DeleteWebhookResponse>

  func listWebhooks(
    _ request: Webhook__ListWebhookRequest,
    callOptions: CallOptions?
  ) -> UnaryCall<Webhook__ListWebhookRequest, Webhook__ListWebhooksResponse>

  func getWebhookSecret(
    _ request: Webhook__GetWebhookSecretRequest,
    callOptions: CallOptions?
  ) -> UnaryCall<Webhook__GetWebhookSecretRequest, Webhook__GetWebhookSecretResponse>

  func rotateWebhookSecret(
    _ request: Webhook__RotateWebhookSecretRequest,
    callOptions: CallOptions?
  ) -> UnaryCall<Webhook__RotateWebhookSecretRequest, Webhook__RotateWebhookSecretResponse>
}

extension Webhook_WebhookClientProtocol {
  public var serviceName: String {
    return "webhook.Webhook"
  }

  /// Unary call to PutWebhook
  ///
  /// - Parameters:
  ///   - request: Request to send to PutWebhook.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  public func putWebhook(
    _ request: Webhook__PutWebhookRequest,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<Webhook__PutWebhookRequest, Webhook__PutWebhookResponse> {
    return self.makeUnaryCall(
      path: Webhook_WebhookClientMetadata.Methods.putWebhook.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makePutWebhookInterceptors() ?? []
    )
  }

  /// Unary call to DeleteWebhook
  ///
  /// - Parameters:
  ///   - request: Request to send to DeleteWebhook.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  public func deleteWebhook(
    _ request: Webhook__DeleteWebhookRequest,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<Webhook__DeleteWebhookRequest, Webhook__DeleteWebhookResponse> {
    return self.makeUnaryCall(
      path: Webhook_WebhookClientMetadata.Methods.deleteWebhook.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeDeleteWebhookInterceptors() ?? []
    )
  }

  /// Unary call to ListWebhooks
  ///
  /// - Parameters:
  ///   - request: Request to send to ListWebhooks.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  public func listWebhooks(
    _ request: Webhook__ListWebhookRequest,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<Webhook__ListWebhookRequest, Webhook__ListWebhooksResponse> {
    return self.makeUnaryCall(
      path: Webhook_WebhookClientMetadata.Methods.listWebhooks.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeListWebhooksInterceptors() ?? []
    )
  }

  /// Unary call to GetWebhookSecret
  ///
  /// - Parameters:
  ///   - request: Request to send to GetWebhookSecret.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  public func getWebhookSecret(
    _ request: Webhook__GetWebhookSecretRequest,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<Webhook__GetWebhookSecretRequest, Webhook__GetWebhookSecretResponse> {
    return self.makeUnaryCall(
      path: Webhook_WebhookClientMetadata.Methods.getWebhookSecret.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeGetWebhookSecretInterceptors() ?? []
    )
  }

  /// Unary call to RotateWebhookSecret
  ///
  /// - Parameters:
  ///   - request: Request to send to RotateWebhookSecret.
  ///   - callOptions: Call options.
  /// - Returns: A `UnaryCall` with futures for the metadata, status and response.
  public func rotateWebhookSecret(
    _ request: Webhook__RotateWebhookSecretRequest,
    callOptions: CallOptions? = nil
  ) -> UnaryCall<Webhook__RotateWebhookSecretRequest, Webhook__RotateWebhookSecretResponse> {
    return self.makeUnaryCall(
      path: Webhook_WebhookClientMetadata.Methods.rotateWebhookSecret.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeRotateWebhookSecretInterceptors() ?? []
    )
  }
}

@available(*, deprecated)
extension Webhook_WebhookClient: @unchecked Sendable {}

@available(*, deprecated, renamed: "Webhook_WebhookNIOClient")
public final class Webhook_WebhookClient: Webhook_WebhookClientProtocol {
  private let lock = Lock()
  private var _defaultCallOptions: CallOptions
  private var _interceptors: Webhook_WebhookClientInterceptorFactoryProtocol?
  public let channel: GRPCChannel
  public var defaultCallOptions: CallOptions {
    get { self.lock.withLock { return self._defaultCallOptions } }
    set { self.lock.withLockVoid { self._defaultCallOptions = newValue } }
  }
  public var interceptors: Webhook_WebhookClientInterceptorFactoryProtocol? {
    get { self.lock.withLock { return self._interceptors } }
    set { self.lock.withLockVoid { self._interceptors = newValue } }
  }

  /// Creates a client for the webhook.Webhook service.
  ///
  /// - Parameters:
  ///   - channel: `GRPCChannel` to the service host.
  ///   - defaultCallOptions: Options to use for each service call if the user doesn't provide them.
  ///   - interceptors: A factory providing interceptors for each RPC.
  public init(
    channel: GRPCChannel,
    defaultCallOptions: CallOptions = CallOptions(),
    interceptors: Webhook_WebhookClientInterceptorFactoryProtocol? = nil
  ) {
    self.channel = channel
    self._defaultCallOptions = defaultCallOptions
    self._interceptors = interceptors
  }
}

public struct Webhook_WebhookNIOClient: Webhook_WebhookClientProtocol {
  public var channel: GRPCChannel
  public var defaultCallOptions: CallOptions
  public var interceptors: Webhook_WebhookClientInterceptorFactoryProtocol?

  /// Creates a client for the webhook.Webhook service.
  ///
  /// - Parameters:
  ///   - channel: `GRPCChannel` to the service host.
  ///   - defaultCallOptions: Options to use for each service call if the user doesn't provide them.
  ///   - interceptors: A factory providing interceptors for each RPC.
  public init(
    channel: GRPCChannel,
    defaultCallOptions: CallOptions = CallOptions(),
    interceptors: Webhook_WebhookClientInterceptorFactoryProtocol? = nil
  ) {
    self.channel = channel
    self.defaultCallOptions = defaultCallOptions
    self.interceptors = interceptors
  }
}

/// A Webhook is a mechanism to consume messages on a Topic.
/// The primary purpose of webhooks in Momento is to enable
/// Lambda to be a subscriber to the messages sent on a topic.
/// Secondarily, webhooks open us up to a whole lot of integrations
/// (slack, discord, event bridge, etc).
@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
public protocol Webhook_WebhookAsyncClientProtocol: GRPCClient {
  static var serviceDescriptor: GRPCServiceDescriptor { get }
  var interceptors: Webhook_WebhookClientInterceptorFactoryProtocol? { get }

  func makePutWebhookCall(
    _ request: Webhook__PutWebhookRequest,
    callOptions: CallOptions?
  ) -> GRPCAsyncUnaryCall<Webhook__PutWebhookRequest, Webhook__PutWebhookResponse>

  func makeDeleteWebhookCall(
    _ request: Webhook__DeleteWebhookRequest,
    callOptions: CallOptions?
  ) -> GRPCAsyncUnaryCall<Webhook__DeleteWebhookRequest, Webhook__DeleteWebhookResponse>

  func makeListWebhooksCall(
    _ request: Webhook__ListWebhookRequest,
    callOptions: CallOptions?
  ) -> GRPCAsyncUnaryCall<Webhook__ListWebhookRequest, Webhook__ListWebhooksResponse>

  func makeGetWebhookSecretCall(
    _ request: Webhook__GetWebhookSecretRequest,
    callOptions: CallOptions?
  ) -> GRPCAsyncUnaryCall<Webhook__GetWebhookSecretRequest, Webhook__GetWebhookSecretResponse>

  func makeRotateWebhookSecretCall(
    _ request: Webhook__RotateWebhookSecretRequest,
    callOptions: CallOptions?
  ) -> GRPCAsyncUnaryCall<Webhook__RotateWebhookSecretRequest, Webhook__RotateWebhookSecretResponse>
}

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
extension Webhook_WebhookAsyncClientProtocol {
  public static var serviceDescriptor: GRPCServiceDescriptor {
    return Webhook_WebhookClientMetadata.serviceDescriptor
  }

  public var interceptors: Webhook_WebhookClientInterceptorFactoryProtocol? {
    return nil
  }

  public func makePutWebhookCall(
    _ request: Webhook__PutWebhookRequest,
    callOptions: CallOptions? = nil
  ) -> GRPCAsyncUnaryCall<Webhook__PutWebhookRequest, Webhook__PutWebhookResponse> {
    return self.makeAsyncUnaryCall(
      path: Webhook_WebhookClientMetadata.Methods.putWebhook.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makePutWebhookInterceptors() ?? []
    )
  }

  public func makeDeleteWebhookCall(
    _ request: Webhook__DeleteWebhookRequest,
    callOptions: CallOptions? = nil
  ) -> GRPCAsyncUnaryCall<Webhook__DeleteWebhookRequest, Webhook__DeleteWebhookResponse> {
    return self.makeAsyncUnaryCall(
      path: Webhook_WebhookClientMetadata.Methods.deleteWebhook.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeDeleteWebhookInterceptors() ?? []
    )
  }

  public func makeListWebhooksCall(
    _ request: Webhook__ListWebhookRequest,
    callOptions: CallOptions? = nil
  ) -> GRPCAsyncUnaryCall<Webhook__ListWebhookRequest, Webhook__ListWebhooksResponse> {
    return self.makeAsyncUnaryCall(
      path: Webhook_WebhookClientMetadata.Methods.listWebhooks.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeListWebhooksInterceptors() ?? []
    )
  }

  public func makeGetWebhookSecretCall(
    _ request: Webhook__GetWebhookSecretRequest,
    callOptions: CallOptions? = nil
  ) -> GRPCAsyncUnaryCall<Webhook__GetWebhookSecretRequest, Webhook__GetWebhookSecretResponse> {
    return self.makeAsyncUnaryCall(
      path: Webhook_WebhookClientMetadata.Methods.getWebhookSecret.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeGetWebhookSecretInterceptors() ?? []
    )
  }

  public func makeRotateWebhookSecretCall(
    _ request: Webhook__RotateWebhookSecretRequest,
    callOptions: CallOptions? = nil
  ) -> GRPCAsyncUnaryCall<Webhook__RotateWebhookSecretRequest, Webhook__RotateWebhookSecretResponse> {
    return self.makeAsyncUnaryCall(
      path: Webhook_WebhookClientMetadata.Methods.rotateWebhookSecret.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeRotateWebhookSecretInterceptors() ?? []
    )
  }
}

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
extension Webhook_WebhookAsyncClientProtocol {
  public func putWebhook(
    _ request: Webhook__PutWebhookRequest,
    callOptions: CallOptions? = nil
  ) async throws -> Webhook__PutWebhookResponse {
    return try await self.performAsyncUnaryCall(
      path: Webhook_WebhookClientMetadata.Methods.putWebhook.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makePutWebhookInterceptors() ?? []
    )
  }

  public func deleteWebhook(
    _ request: Webhook__DeleteWebhookRequest,
    callOptions: CallOptions? = nil
  ) async throws -> Webhook__DeleteWebhookResponse {
    return try await self.performAsyncUnaryCall(
      path: Webhook_WebhookClientMetadata.Methods.deleteWebhook.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeDeleteWebhookInterceptors() ?? []
    )
  }

  public func listWebhooks(
    _ request: Webhook__ListWebhookRequest,
    callOptions: CallOptions? = nil
  ) async throws -> Webhook__ListWebhooksResponse {
    return try await self.performAsyncUnaryCall(
      path: Webhook_WebhookClientMetadata.Methods.listWebhooks.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeListWebhooksInterceptors() ?? []
    )
  }

  public func getWebhookSecret(
    _ request: Webhook__GetWebhookSecretRequest,
    callOptions: CallOptions? = nil
  ) async throws -> Webhook__GetWebhookSecretResponse {
    return try await self.performAsyncUnaryCall(
      path: Webhook_WebhookClientMetadata.Methods.getWebhookSecret.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeGetWebhookSecretInterceptors() ?? []
    )
  }

  public func rotateWebhookSecret(
    _ request: Webhook__RotateWebhookSecretRequest,
    callOptions: CallOptions? = nil
  ) async throws -> Webhook__RotateWebhookSecretResponse {
    return try await self.performAsyncUnaryCall(
      path: Webhook_WebhookClientMetadata.Methods.rotateWebhookSecret.path,
      request: request,
      callOptions: callOptions ?? self.defaultCallOptions,
      interceptors: self.interceptors?.makeRotateWebhookSecretInterceptors() ?? []
    )
  }
}

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
public struct Webhook_WebhookAsyncClient: Webhook_WebhookAsyncClientProtocol {
  public var channel: GRPCChannel
  public var defaultCallOptions: CallOptions
  public var interceptors: Webhook_WebhookClientInterceptorFactoryProtocol?

  public init(
    channel: GRPCChannel,
    defaultCallOptions: CallOptions = CallOptions(),
    interceptors: Webhook_WebhookClientInterceptorFactoryProtocol? = nil
  ) {
    self.channel = channel
    self.defaultCallOptions = defaultCallOptions
    self.interceptors = interceptors
  }
}

public protocol Webhook_WebhookClientInterceptorFactoryProtocol: Sendable {

  /// - Returns: Interceptors to use when invoking 'putWebhook'.
  func makePutWebhookInterceptors() -> [ClientInterceptor<Webhook__PutWebhookRequest, Webhook__PutWebhookResponse>]

  /// - Returns: Interceptors to use when invoking 'deleteWebhook'.
  func makeDeleteWebhookInterceptors() -> [ClientInterceptor<Webhook__DeleteWebhookRequest, Webhook__DeleteWebhookResponse>]

  /// - Returns: Interceptors to use when invoking 'listWebhooks'.
  func makeListWebhooksInterceptors() -> [ClientInterceptor<Webhook__ListWebhookRequest, Webhook__ListWebhooksResponse>]

  /// - Returns: Interceptors to use when invoking 'getWebhookSecret'.
  func makeGetWebhookSecretInterceptors() -> [ClientInterceptor<Webhook__GetWebhookSecretRequest, Webhook__GetWebhookSecretResponse>]

  /// - Returns: Interceptors to use when invoking 'rotateWebhookSecret'.
  func makeRotateWebhookSecretInterceptors() -> [ClientInterceptor<Webhook__RotateWebhookSecretRequest, Webhook__RotateWebhookSecretResponse>]
}

public enum Webhook_WebhookClientMetadata {
  public static let serviceDescriptor = GRPCServiceDescriptor(
    name: "Webhook",
    fullName: "webhook.Webhook",
    methods: [
      Webhook_WebhookClientMetadata.Methods.putWebhook,
      Webhook_WebhookClientMetadata.Methods.deleteWebhook,
      Webhook_WebhookClientMetadata.Methods.listWebhooks,
      Webhook_WebhookClientMetadata.Methods.getWebhookSecret,
      Webhook_WebhookClientMetadata.Methods.rotateWebhookSecret,
    ]
  )

  public enum Methods {
    public static let putWebhook = GRPCMethodDescriptor(
      name: "PutWebhook",
      path: "/webhook.Webhook/PutWebhook",
      type: GRPCCallType.unary
    )

    public static let deleteWebhook = GRPCMethodDescriptor(
      name: "DeleteWebhook",
      path: "/webhook.Webhook/DeleteWebhook",
      type: GRPCCallType.unary
    )

    public static let listWebhooks = GRPCMethodDescriptor(
      name: "ListWebhooks",
      path: "/webhook.Webhook/ListWebhooks",
      type: GRPCCallType.unary
    )

    public static let getWebhookSecret = GRPCMethodDescriptor(
      name: "GetWebhookSecret",
      path: "/webhook.Webhook/GetWebhookSecret",
      type: GRPCCallType.unary
    )

    public static let rotateWebhookSecret = GRPCMethodDescriptor(
      name: "RotateWebhookSecret",
      path: "/webhook.Webhook/RotateWebhookSecret",
      type: GRPCCallType.unary
    )
  }
}

/// A Webhook is a mechanism to consume messages on a Topic.
/// The primary purpose of webhooks in Momento is to enable
/// Lambda to be a subscriber to the messages sent on a topic.
/// Secondarily, webhooks open us up to a whole lot of integrations
/// (slack, discord, event bridge, etc).
///
/// To build a server, implement a class that conforms to this protocol.
public protocol Webhook_WebhookProvider: CallHandlerProvider {
  var interceptors: Webhook_WebhookServerInterceptorFactoryProtocol? { get }

  func putWebhook(request: Webhook__PutWebhookRequest, context: StatusOnlyCallContext) -> EventLoopFuture<Webhook__PutWebhookResponse>

  func deleteWebhook(request: Webhook__DeleteWebhookRequest, context: StatusOnlyCallContext) -> EventLoopFuture<Webhook__DeleteWebhookResponse>

  func listWebhooks(request: Webhook__ListWebhookRequest, context: StatusOnlyCallContext) -> EventLoopFuture<Webhook__ListWebhooksResponse>

  func getWebhookSecret(request: Webhook__GetWebhookSecretRequest, context: StatusOnlyCallContext) -> EventLoopFuture<Webhook__GetWebhookSecretResponse>

  func rotateWebhookSecret(request: Webhook__RotateWebhookSecretRequest, context: StatusOnlyCallContext) -> EventLoopFuture<Webhook__RotateWebhookSecretResponse>
}

extension Webhook_WebhookProvider {
  public var serviceName: Substring {
    return Webhook_WebhookServerMetadata.serviceDescriptor.fullName[...]
  }

  /// Determines, calls and returns the appropriate request handler, depending on the request's method.
  /// Returns nil for methods not handled by this service.
  public func handle(
    method name: Substring,
    context: CallHandlerContext
  ) -> GRPCServerHandlerProtocol? {
    switch name {
    case "PutWebhook":
      return UnaryServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Webhook__PutWebhookRequest>(),
        responseSerializer: ProtobufSerializer<Webhook__PutWebhookResponse>(),
        interceptors: self.interceptors?.makePutWebhookInterceptors() ?? [],
        userFunction: self.putWebhook(request:context:)
      )

    case "DeleteWebhook":
      return UnaryServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Webhook__DeleteWebhookRequest>(),
        responseSerializer: ProtobufSerializer<Webhook__DeleteWebhookResponse>(),
        interceptors: self.interceptors?.makeDeleteWebhookInterceptors() ?? [],
        userFunction: self.deleteWebhook(request:context:)
      )

    case "ListWebhooks":
      return UnaryServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Webhook__ListWebhookRequest>(),
        responseSerializer: ProtobufSerializer<Webhook__ListWebhooksResponse>(),
        interceptors: self.interceptors?.makeListWebhooksInterceptors() ?? [],
        userFunction: self.listWebhooks(request:context:)
      )

    case "GetWebhookSecret":
      return UnaryServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Webhook__GetWebhookSecretRequest>(),
        responseSerializer: ProtobufSerializer<Webhook__GetWebhookSecretResponse>(),
        interceptors: self.interceptors?.makeGetWebhookSecretInterceptors() ?? [],
        userFunction: self.getWebhookSecret(request:context:)
      )

    case "RotateWebhookSecret":
      return UnaryServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Webhook__RotateWebhookSecretRequest>(),
        responseSerializer: ProtobufSerializer<Webhook__RotateWebhookSecretResponse>(),
        interceptors: self.interceptors?.makeRotateWebhookSecretInterceptors() ?? [],
        userFunction: self.rotateWebhookSecret(request:context:)
      )

    default:
      return nil
    }
  }
}

/// A Webhook is a mechanism to consume messages on a Topic.
/// The primary purpose of webhooks in Momento is to enable
/// Lambda to be a subscriber to the messages sent on a topic.
/// Secondarily, webhooks open us up to a whole lot of integrations
/// (slack, discord, event bridge, etc).
///
/// To implement a server, implement an object which conforms to this protocol.
@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
public protocol Webhook_WebhookAsyncProvider: CallHandlerProvider, Sendable {
  static var serviceDescriptor: GRPCServiceDescriptor { get }
  var interceptors: Webhook_WebhookServerInterceptorFactoryProtocol? { get }

  func putWebhook(
    request: Webhook__PutWebhookRequest,
    context: GRPCAsyncServerCallContext
  ) async throws -> Webhook__PutWebhookResponse

  func deleteWebhook(
    request: Webhook__DeleteWebhookRequest,
    context: GRPCAsyncServerCallContext
  ) async throws -> Webhook__DeleteWebhookResponse

  func listWebhooks(
    request: Webhook__ListWebhookRequest,
    context: GRPCAsyncServerCallContext
  ) async throws -> Webhook__ListWebhooksResponse

  func getWebhookSecret(
    request: Webhook__GetWebhookSecretRequest,
    context: GRPCAsyncServerCallContext
  ) async throws -> Webhook__GetWebhookSecretResponse

  func rotateWebhookSecret(
    request: Webhook__RotateWebhookSecretRequest,
    context: GRPCAsyncServerCallContext
  ) async throws -> Webhook__RotateWebhookSecretResponse
}

@available(macOS 10.15, iOS 13, tvOS 13, watchOS 6, *)
extension Webhook_WebhookAsyncProvider {
  public static var serviceDescriptor: GRPCServiceDescriptor {
    return Webhook_WebhookServerMetadata.serviceDescriptor
  }

  public var serviceName: Substring {
    return Webhook_WebhookServerMetadata.serviceDescriptor.fullName[...]
  }

  public var interceptors: Webhook_WebhookServerInterceptorFactoryProtocol? {
    return nil
  }

  public func handle(
    method name: Substring,
    context: CallHandlerContext
  ) -> GRPCServerHandlerProtocol? {
    switch name {
    case "PutWebhook":
      return GRPCAsyncServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Webhook__PutWebhookRequest>(),
        responseSerializer: ProtobufSerializer<Webhook__PutWebhookResponse>(),
        interceptors: self.interceptors?.makePutWebhookInterceptors() ?? [],
        wrapping: { try await self.putWebhook(request: $0, context: $1) }
      )

    case "DeleteWebhook":
      return GRPCAsyncServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Webhook__DeleteWebhookRequest>(),
        responseSerializer: ProtobufSerializer<Webhook__DeleteWebhookResponse>(),
        interceptors: self.interceptors?.makeDeleteWebhookInterceptors() ?? [],
        wrapping: { try await self.deleteWebhook(request: $0, context: $1) }
      )

    case "ListWebhooks":
      return GRPCAsyncServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Webhook__ListWebhookRequest>(),
        responseSerializer: ProtobufSerializer<Webhook__ListWebhooksResponse>(),
        interceptors: self.interceptors?.makeListWebhooksInterceptors() ?? [],
        wrapping: { try await self.listWebhooks(request: $0, context: $1) }
      )

    case "GetWebhookSecret":
      return GRPCAsyncServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Webhook__GetWebhookSecretRequest>(),
        responseSerializer: ProtobufSerializer<Webhook__GetWebhookSecretResponse>(),
        interceptors: self.interceptors?.makeGetWebhookSecretInterceptors() ?? [],
        wrapping: { try await self.getWebhookSecret(request: $0, context: $1) }
      )

    case "RotateWebhookSecret":
      return GRPCAsyncServerHandler(
        context: context,
        requestDeserializer: ProtobufDeserializer<Webhook__RotateWebhookSecretRequest>(),
        responseSerializer: ProtobufSerializer<Webhook__RotateWebhookSecretResponse>(),
        interceptors: self.interceptors?.makeRotateWebhookSecretInterceptors() ?? [],
        wrapping: { try await self.rotateWebhookSecret(request: $0, context: $1) }
      )

    default:
      return nil
    }
  }
}

public protocol Webhook_WebhookServerInterceptorFactoryProtocol: Sendable {

  /// - Returns: Interceptors to use when handling 'putWebhook'.
  ///   Defaults to calling `self.makeInterceptors()`.
  func makePutWebhookInterceptors() -> [ServerInterceptor<Webhook__PutWebhookRequest, Webhook__PutWebhookResponse>]

  /// - Returns: Interceptors to use when handling 'deleteWebhook'.
  ///   Defaults to calling `self.makeInterceptors()`.
  func makeDeleteWebhookInterceptors() -> [ServerInterceptor<Webhook__DeleteWebhookRequest, Webhook__DeleteWebhookResponse>]

  /// - Returns: Interceptors to use when handling 'listWebhooks'.
  ///   Defaults to calling `self.makeInterceptors()`.
  func makeListWebhooksInterceptors() -> [ServerInterceptor<Webhook__ListWebhookRequest, Webhook__ListWebhooksResponse>]

  /// - Returns: Interceptors to use when handling 'getWebhookSecret'.
  ///   Defaults to calling `self.makeInterceptors()`.
  func makeGetWebhookSecretInterceptors() -> [ServerInterceptor<Webhook__GetWebhookSecretRequest, Webhook__GetWebhookSecretResponse>]

  /// - Returns: Interceptors to use when handling 'rotateWebhookSecret'.
  ///   Defaults to calling `self.makeInterceptors()`.
  func makeRotateWebhookSecretInterceptors() -> [ServerInterceptor<Webhook__RotateWebhookSecretRequest, Webhook__RotateWebhookSecretResponse>]
}

public enum Webhook_WebhookServerMetadata {
  public static let serviceDescriptor = GRPCServiceDescriptor(
    name: "Webhook",
    fullName: "webhook.Webhook",
    methods: [
      Webhook_WebhookServerMetadata.Methods.putWebhook,
      Webhook_WebhookServerMetadata.Methods.deleteWebhook,
      Webhook_WebhookServerMetadata.Methods.listWebhooks,
      Webhook_WebhookServerMetadata.Methods.getWebhookSecret,
      Webhook_WebhookServerMetadata.Methods.rotateWebhookSecret,
    ]
  )

  public enum Methods {
    public static let putWebhook = GRPCMethodDescriptor(
      name: "PutWebhook",
      path: "/webhook.Webhook/PutWebhook",
      type: GRPCCallType.unary
    )

    public static let deleteWebhook = GRPCMethodDescriptor(
      name: "DeleteWebhook",
      path: "/webhook.Webhook/DeleteWebhook",
      type: GRPCCallType.unary
    )

    public static let listWebhooks = GRPCMethodDescriptor(
      name: "ListWebhooks",
      path: "/webhook.Webhook/ListWebhooks",
      type: GRPCCallType.unary
    )

    public static let getWebhookSecret = GRPCMethodDescriptor(
      name: "GetWebhookSecret",
      path: "/webhook.Webhook/GetWebhookSecret",
      type: GRPCCallType.unary
    )

    public static let rotateWebhookSecret = GRPCMethodDescriptor(
      name: "RotateWebhookSecret",
      path: "/webhook.Webhook/RotateWebhookSecret",
      type: GRPCCallType.unary
    )
  }
}
