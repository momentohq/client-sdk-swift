import Foundation

public protocol TopicClientProtocol {
    func publish() async -> String
    func subscribe() async -> String
}
