import SwiftUI
import CoreData
import momento

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var message: String = ""
    @StateObject private var momentoClient = Momento()
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Divider()
            TextField("Enter your message:", text: $message)
                .border(.secondary)
                .onSubmit {
                    Task {
                        await publish()
                    }
                }
        }
        .padding()
    }
    
    private func publish() async {
        print("Going to publish \(message)")
        let result = await momentoClient.topicClient.publish(
            cacheName: "cache",
            topicName: "demo",
            value: message
        )
        switch result {
        case is TopicPublishSuccess:
            print("Successful publish")
        default:
            print("Error publishing: \(result)")
        }
        message = ""
    }
}
