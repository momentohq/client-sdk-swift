class PubsubClient: PubsubClientProtocol {
    var logger: MomentoLoggerProtocol
    var configuration: TopicClientConfiguration
//    var client: CacheClient_Pubsub_PubsubNIOClient
//    var credentialProvider
    
    init(logger: MomentoLoggerProtocol, configuration: TopicClientConfiguration) {
        self.logger = logger
        self.configuration = configuration
//        self.client = CacheClient_Pubsub_PubsubNIOClient(channel: GRPCChannel())
    }
    
    func publish() async -> String {
        return "calling client.publish"
    }
    
    func subscribe() async -> String {
        return "calling client.subscribe"
    }
    
    
}
