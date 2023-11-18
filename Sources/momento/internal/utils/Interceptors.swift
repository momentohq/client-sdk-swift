import Foundation
import GRPC
import NIO
import NIOHPACK

// Adds the `authorization` header to outgoing requests
final class AuthHeaderInterceptor<Request, Response>: ClientInterceptor<Request, Response> {

    private let apiKey: String

    init(apiKey: String) {
        self.apiKey = apiKey
    }

    override func send(
        _ part: GRPCClientRequestPart<Request>,
        promise: EventLoopPromise<Void>?,
        context: ClientInterceptorContext<Request, Response>
    ) {
        guard case .metadata(var headers) = part else {
            return context.send(part, promise: promise)
        }

        headers.add(name: "authorization", value: apiKey)
        context.send(.metadata(headers), promise: promise)
    }
}

// Interceptor factory class for the PubsubClient
final class PubsubClientInterceptorFactory: CacheClient_Pubsub_PubsubClientInterceptorFactoryProtocol {
    
    private let apiKey: String
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    func makePublishInterceptors() -> [ClientInterceptor<CacheClient_Pubsub__PublishRequest, CacheClient_Pubsub__Empty>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }

    func makeSubscribeInterceptors() -> [ClientInterceptor<CacheClient_Pubsub__SubscriptionRequest, CacheClient_Pubsub__SubscriptionItem>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
}

// Interceptor factory class for the CacheControlClient
final class ControlClientInterceptorFactory: ControlClient_ScsControlClientInterceptorFactoryProtocol {
    
    private let apiKey: String
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    func makeCreateCacheInterceptors() -> [GRPC.ClientInterceptor<ControlClient__CreateCacheRequest, ControlClient__CreateCacheResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeDeleteCacheInterceptors() -> [GRPC.ClientInterceptor<ControlClient__DeleteCacheRequest, ControlClient__DeleteCacheResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeListCachesInterceptors() -> [GRPC.ClientInterceptor<ControlClient__ListCachesRequest, ControlClient__ListCachesResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeFlushCacheInterceptors() -> [GRPC.ClientInterceptor<ControlClient__FlushCacheRequest, ControlClient__FlushCacheResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeCreateSigningKeyInterceptors() -> [GRPC.ClientInterceptor<ControlClient__CreateSigningKeyRequest, ControlClient__CreateSigningKeyResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeRevokeSigningKeyInterceptors() -> [GRPC.ClientInterceptor<ControlClient__RevokeSigningKeyRequest, ControlClient__RevokeSigningKeyResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeListSigningKeysInterceptors() -> [GRPC.ClientInterceptor<ControlClient__ListSigningKeysRequest, ControlClient__ListSigningKeysResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeCreateIndexInterceptors() -> [GRPC.ClientInterceptor<ControlClient__CreateIndexRequest, ControlClient__CreateIndexResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeDeleteIndexInterceptors() -> [GRPC.ClientInterceptor<ControlClient__DeleteIndexRequest, ControlClient__DeleteIndexResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeListIndexesInterceptors() -> [GRPC.ClientInterceptor<ControlClient__ListIndexesRequest, ControlClient__ListIndexesResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
}
