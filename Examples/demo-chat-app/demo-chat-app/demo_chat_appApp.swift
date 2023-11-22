import SwiftUI
import momento

class Momento: ObservableObject {
    public var topicClient: TopicClientProtocol
    private let momentoApiKey: String = ""
    
    init() {
        if momentoApiKey.isEmpty {
            fatalError("Missing Momento API key in app initiation")
        }
        do {
            let credProvider = try CredentialProvider.fromString(authToken: self.momentoApiKey)
            self.topicClient = TopicClient(
                configuration: TopicConfigurations.Default.latest(),
                credentialProvider: credProvider
            )
        } catch {
            fatalError("Unable to instantiate TopicClient")
        }
    }
}

@main
struct demo_chat_appApp: App {
    let persistenceController = PersistenceController.shared
    
    @EnvironmentObject private var momento: Momento
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
