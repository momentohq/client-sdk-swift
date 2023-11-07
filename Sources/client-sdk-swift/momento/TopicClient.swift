import Foundation

public class TopicClient: TopicClientProtocol {    
    public func publish() async -> String {
        return "publishing"
    }
    
    public func subscribe() async -> String {
        return "subscribing"
    }
}
