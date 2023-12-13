import SwiftUI
import Momento

class Momento: ObservableObject {
    private let momentoApiKey: String = ""
    
    public var topicClient: TopicClientProtocol
    public let cacheName: String = "cache"
    public let topicName: String = "demo"
    
    init() {
        if momentoApiKey.isEmpty {
            fatalError("Missing Momento API key in app initiation")
        }
        do {
            let credProvider = try CredentialProvider.fromString(apiKey: self.momentoApiKey)
            self.topicClient = TopicClient(
                configuration: TopicClientConfigurations.iOS.latest().withClientTimeout(timeout: 600),
                credentialProvider: credProvider
            )
        } catch {
            fatalError("Unable to instantiate TopicClient")
        }
    }
}

@main
struct MomentoDemoChatApp: App {
    private var momento: Momento = Momento()
    
    var body: some Scene {
        WindowGroup {
            ContentView(momentoClient: momento)
        }
    }
}
