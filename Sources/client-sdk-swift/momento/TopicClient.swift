import Foundation

class TopicClient: TopicClientProtocol {
    func publish() async -> String {
        return "publishing"
    }
    
    func subscribe() async -> String {
        return "subscribing"
    }
}
