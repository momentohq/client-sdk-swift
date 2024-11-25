import GRPC
import NIO
import NIOHPACK

// Adds the `authorization` header to outgoing requests
final class AuthHeaderInterceptor<Request, Response>: ClientInterceptor<Request, Response>, @unchecked Sendable {

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
    
    func makeCreateCacheInterceptors() -> [ClientInterceptor<ControlClient__CreateCacheRequest, ControlClient__CreateCacheResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeDeleteCacheInterceptors() -> [ClientInterceptor<ControlClient__DeleteCacheRequest, ControlClient__DeleteCacheResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeListCachesInterceptors() -> [ClientInterceptor<ControlClient__ListCachesRequest, ControlClient__ListCachesResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeFlushCacheInterceptors() -> [ClientInterceptor<ControlClient__FlushCacheRequest, ControlClient__FlushCacheResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeCreateSigningKeyInterceptors() -> [ClientInterceptor<ControlClient__CreateSigningKeyRequest, ControlClient__CreateSigningKeyResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeRevokeSigningKeyInterceptors() -> [ClientInterceptor<ControlClient__RevokeSigningKeyRequest, ControlClient__RevokeSigningKeyResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeListSigningKeysInterceptors() -> [ClientInterceptor<ControlClient__ListSigningKeysRequest, ControlClient__ListSigningKeysResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeCreateIndexInterceptors() -> [ClientInterceptor<ControlClient__CreateIndexRequest, ControlClient__CreateIndexResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeDeleteIndexInterceptors() -> [ClientInterceptor<ControlClient__DeleteIndexRequest, ControlClient__DeleteIndexResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeListIndexesInterceptors() -> [ClientInterceptor<ControlClient__ListIndexesRequest, ControlClient__ListIndexesResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
}

// Interceptor factory class for the CacheDataClient
final class DataClientInterceptorFactory: CacheClient_ScsClientInterceptorFactoryProtocol {
    private let apiKey: String
    
    init(apiKey: String) {
        self.apiKey = apiKey
    }
    
    func makeGetInterceptors() -> [ClientInterceptor<CacheClient__GetRequest, CacheClient__GetResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeSetInterceptors() -> [ClientInterceptor<CacheClient__SetRequest, CacheClient__SetResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeSetIfNotExistsInterceptors() -> [ClientInterceptor<CacheClient__SetIfNotExistsRequest, CacheClient__SetIfNotExistsResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeDeleteInterceptors() -> [ClientInterceptor<CacheClient__DeleteRequest, CacheClient__DeleteResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeKeysExistInterceptors() -> [ClientInterceptor<CacheClient__KeysExistRequest, CacheClient__KeysExistResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeIncrementInterceptors() -> [ClientInterceptor<CacheClient__IncrementRequest, CacheClient__IncrementResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeUpdateTtlInterceptors() -> [ClientInterceptor<CacheClient__UpdateTtlRequest, CacheClient__UpdateTtlResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeItemGetTtlInterceptors() -> [ClientInterceptor<CacheClient__ItemGetTtlRequest, CacheClient__ItemGetTtlResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeItemGetTypeInterceptors() -> [ClientInterceptor<CacheClient__ItemGetTypeRequest, CacheClient__ItemGetTypeResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeDictionaryGetInterceptors() -> [ClientInterceptor<CacheClient__DictionaryGetRequest, CacheClient__DictionaryGetResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeDictionaryFetchInterceptors() -> [ClientInterceptor<CacheClient__DictionaryFetchRequest, CacheClient__DictionaryFetchResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeDictionarySetInterceptors() -> [ClientInterceptor<CacheClient__DictionarySetRequest, CacheClient__DictionarySetResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeDictionaryIncrementInterceptors() -> [ClientInterceptor<CacheClient__DictionaryIncrementRequest, CacheClient__DictionaryIncrementResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeDictionaryDeleteInterceptors() -> [ClientInterceptor<CacheClient__DictionaryDeleteRequest, CacheClient__DictionaryDeleteResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeDictionaryLengthInterceptors() -> [ClientInterceptor<CacheClient__DictionaryLengthRequest, CacheClient__DictionaryLengthResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeSetFetchInterceptors() -> [ClientInterceptor<CacheClient__SetFetchRequest, CacheClient__SetFetchResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeSetUnionInterceptors() -> [ClientInterceptor<CacheClient__SetUnionRequest, CacheClient__SetUnionResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeSetDifferenceInterceptors() -> [ClientInterceptor<CacheClient__SetDifferenceRequest, CacheClient__SetDifferenceResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeSetContainsInterceptors() -> [ClientInterceptor<CacheClient__SetContainsRequest, CacheClient__SetContainsResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeSetLengthInterceptors() -> [ClientInterceptor<CacheClient__SetLengthRequest, CacheClient__SetLengthResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeSetPopInterceptors() -> [ClientInterceptor<CacheClient__SetPopRequest, CacheClient__SetPopResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeListPushFrontInterceptors() -> [ClientInterceptor<CacheClient__ListPushFrontRequest, CacheClient__ListPushFrontResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeListPushBackInterceptors() -> [ClientInterceptor<CacheClient__ListPushBackRequest, CacheClient__ListPushBackResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeListPopFrontInterceptors() -> [ClientInterceptor<CacheClient__ListPopFrontRequest, CacheClient__ListPopFrontResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeListPopBackInterceptors() -> [ClientInterceptor<CacheClient__ListPopBackRequest, CacheClient__ListPopBackResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeListEraseInterceptors() -> [ClientInterceptor<CacheClient__ListEraseRequest, CacheClient__ListEraseResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeListRemoveInterceptors() -> [ClientInterceptor<CacheClient__ListRemoveRequest, CacheClient__ListRemoveResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeListFetchInterceptors() -> [ClientInterceptor<CacheClient__ListFetchRequest, CacheClient__ListFetchResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeListLengthInterceptors() -> [ClientInterceptor<CacheClient__ListLengthRequest, CacheClient__ListLengthResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeListConcatenateFrontInterceptors() -> [ClientInterceptor<CacheClient__ListConcatenateFrontRequest, CacheClient__ListConcatenateFrontResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeListConcatenateBackInterceptors() -> [ClientInterceptor<CacheClient__ListConcatenateBackRequest, CacheClient__ListConcatenateBackResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeListRetainInterceptors() -> [ClientInterceptor<CacheClient__ListRetainRequest, CacheClient__ListRetainResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeSortedSetPutInterceptors() -> [ClientInterceptor<CacheClient__SortedSetPutRequest, CacheClient__SortedSetPutResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeSortedSetFetchInterceptors() -> [ClientInterceptor<CacheClient__SortedSetFetchRequest, CacheClient__SortedSetFetchResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeSortedSetGetScoreInterceptors() -> [ClientInterceptor<CacheClient__SortedSetGetScoreRequest, CacheClient__SortedSetGetScoreResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeSortedSetRemoveInterceptors() -> [ClientInterceptor<CacheClient__SortedSetRemoveRequest, CacheClient__SortedSetRemoveResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeSortedSetIncrementInterceptors() -> [ClientInterceptor<CacheClient__SortedSetIncrementRequest, CacheClient__SortedSetIncrementResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeSortedSetGetRankInterceptors() -> [ClientInterceptor<CacheClient__SortedSetGetRankRequest, CacheClient__SortedSetGetRankResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeSortedSetLengthInterceptors() -> [ClientInterceptor<CacheClient__SortedSetLengthRequest, CacheClient__SortedSetLengthResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
    
    func makeSortedSetLengthByScoreInterceptors() -> [ClientInterceptor<CacheClient__SortedSetLengthByScoreRequest, CacheClient__SortedSetLengthByScoreResponse>] {
        [AuthHeaderInterceptor(apiKey: apiKey)]
    }
}
