protocol PubsubClientProtocol {
    var logger: MomentoLoggerProtocol { get }
    var configuration: TopicClientConfiguration { get }
//    pb.pubsub client
//    credential provider
    
    func publish() async -> String
    func subscribe() async throws -> String
}
