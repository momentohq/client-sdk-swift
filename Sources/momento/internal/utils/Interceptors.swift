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

// Interceptor factory class for the CacheDataClient
final class DataClientInterceptorFactory: CacheClient_ScsClientInterceptorFactoryProtocol {
    private let apiKey: String
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    func makeGetInterceptors() -> [GRPC.ClientInterceptor<CacheClient__GetRequest, CacheClient__GetResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeSetInterceptors() -> [GRPC.ClientInterceptor<CacheClient__SetRequest, CacheClient__SetResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeSetIfNotExistsInterceptors() -> [GRPC.ClientInterceptor<CacheClient__SetIfNotExistsRequest, CacheClient__SetIfNotExistsResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeDeleteInterceptors() -> [GRPC.ClientInterceptor<CacheClient__DeleteRequest, CacheClient__DeleteResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeKeysExistInterceptors() -> [GRPC.ClientInterceptor<CacheClient__KeysExistRequest, CacheClient__KeysExistResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeIncrementInterceptors() -> [GRPC.ClientInterceptor<CacheClient__IncrementRequest, CacheClient__IncrementResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeUpdateTtlInterceptors() -> [GRPC.ClientInterceptor<CacheClient__UpdateTtlRequest, CacheClient__UpdateTtlResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeItemGetTtlInterceptors() -> [GRPC.ClientInterceptor<CacheClient__ItemGetTtlRequest, CacheClient__ItemGetTtlResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeItemGetTypeInterceptors() -> [GRPC.ClientInterceptor<CacheClient__ItemGetTypeRequest, CacheClient__ItemGetTypeResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeDictionaryGetInterceptors() -> [GRPC.ClientInterceptor<CacheClient__DictionaryGetRequest, CacheClient__DictionaryGetResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeDictionaryFetchInterceptors() -> [GRPC.ClientInterceptor<CacheClient__DictionaryFetchRequest, CacheClient__DictionaryFetchResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeDictionarySetInterceptors() -> [GRPC.ClientInterceptor<CacheClient__DictionarySetRequest, CacheClient__DictionarySetResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeDictionaryIncrementInterceptors() -> [GRPC.ClientInterceptor<CacheClient__DictionaryIncrementRequest, CacheClient__DictionaryIncrementResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeDictionaryDeleteInterceptors() -> [GRPC.ClientInterceptor<CacheClient__DictionaryDeleteRequest, CacheClient__DictionaryDeleteResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeDictionaryLengthInterceptors() -> [GRPC.ClientInterceptor<CacheClient__DictionaryLengthRequest, CacheClient__DictionaryLengthResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeSetFetchInterceptors() -> [GRPC.ClientInterceptor<CacheClient__SetFetchRequest, CacheClient__SetFetchResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeSetUnionInterceptors() -> [GRPC.ClientInterceptor<CacheClient__SetUnionRequest, CacheClient__SetUnionResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeSetDifferenceInterceptors() -> [GRPC.ClientInterceptor<CacheClient__SetDifferenceRequest, CacheClient__SetDifferenceResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeSetContainsInterceptors() -> [GRPC.ClientInterceptor<CacheClient__SetContainsRequest, CacheClient__SetContainsResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeSetLengthInterceptors() -> [GRPC.ClientInterceptor<CacheClient__SetLengthRequest, CacheClient__SetLengthResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeSetPopInterceptors() -> [GRPC.ClientInterceptor<CacheClient__SetPopRequest, CacheClient__SetPopResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeListPushFrontInterceptors() -> [GRPC.ClientInterceptor<CacheClient__ListPushFrontRequest, CacheClient__ListPushFrontResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeListPushBackInterceptors() -> [GRPC.ClientInterceptor<CacheClient__ListPushBackRequest, CacheClient__ListPushBackResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeListPopFrontInterceptors() -> [GRPC.ClientInterceptor<CacheClient__ListPopFrontRequest, CacheClient__ListPopFrontResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeListPopBackInterceptors() -> [GRPC.ClientInterceptor<CacheClient__ListPopBackRequest, CacheClient__ListPopBackResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeListEraseInterceptors() -> [GRPC.ClientInterceptor<CacheClient__ListEraseRequest, CacheClient__ListEraseResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeListRemoveInterceptors() -> [GRPC.ClientInterceptor<CacheClient__ListRemoveRequest, CacheClient__ListRemoveResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeListFetchInterceptors() -> [GRPC.ClientInterceptor<CacheClient__ListFetchRequest, CacheClient__ListFetchResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeListLengthInterceptors() -> [GRPC.ClientInterceptor<CacheClient__ListLengthRequest, CacheClient__ListLengthResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeListConcatenateFrontInterceptors() -> [GRPC.ClientInterceptor<CacheClient__ListConcatenateFrontRequest, CacheClient__ListConcatenateFrontResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeListConcatenateBackInterceptors() -> [GRPC.ClientInterceptor<CacheClient__ListConcatenateBackRequest, CacheClient__ListConcatenateBackResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeListRetainInterceptors() -> [GRPC.ClientInterceptor<CacheClient__ListRetainRequest, CacheClient__ListRetainResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeSortedSetPutInterceptors() -> [GRPC.ClientInterceptor<CacheClient__SortedSetPutRequest, CacheClient__SortedSetPutResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeSortedSetFetchInterceptors() -> [GRPC.ClientInterceptor<CacheClient__SortedSetFetchRequest, CacheClient__SortedSetFetchResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeSortedSetGetScoreInterceptors() -> [GRPC.ClientInterceptor<CacheClient__SortedSetGetScoreRequest, CacheClient__SortedSetGetScoreResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeSortedSetRemoveInterceptors() -> [GRPC.ClientInterceptor<CacheClient__SortedSetRemoveRequest, CacheClient__SortedSetRemoveResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeSortedSetIncrementInterceptors() -> [GRPC.ClientInterceptor<CacheClient__SortedSetIncrementRequest, CacheClient__SortedSetIncrementResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeSortedSetGetRankInterceptors() -> [GRPC.ClientInterceptor<CacheClient__SortedSetGetRankRequest, CacheClient__SortedSetGetRankResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeSortedSetLengthInterceptors() -> [GRPC.ClientInterceptor<CacheClient__SortedSetLengthRequest, CacheClient__SortedSetLengthResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeSortedSetLengthByScoreInterceptors() -> [GRPC.ClientInterceptor<CacheClient__SortedSetLengthByScoreRequest, CacheClient__SortedSetLengthByScoreResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
}
