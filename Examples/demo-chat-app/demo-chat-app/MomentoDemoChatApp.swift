import SwiftUI
import Momento

class Momento: ObservableObject {
    public var topicClient: TopicClientProtocol
    public let cacheName: String = "cache"
    public let topicName: String = "demo"
    
    init() {
        do {
            let credProvider = try CredentialProvider.fromEnvironmentVariable(envVariableName: "MOMENTO_API_KEY")
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
