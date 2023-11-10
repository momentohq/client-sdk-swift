protocol PubsubClientProtocol {
    var logger: MomentoLoggerProtocol { get }
    var configuration: TopicClientConfiguration { get }
//    pb.pubsub client
//    credential provider
    
    func publish() async throws -> String
    func subscribe() async throws -> String
}
