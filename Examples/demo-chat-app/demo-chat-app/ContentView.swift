import SwiftUI
import momento

struct ContentView: View {
    @State private var momentoClient: Momento
    @State private var message: String = ""
    @ObservedObject var store: MessageStore
    
    public init(momentoClient: Momento) {
        self.store = MessageStore(momentoClient: momentoClient)
        self.momentoClient = momentoClient
    }
    
    var body: some View {
        VStack {
            Text("Publish New Messages")
                .font(.headline)
            TextField("Enter your message:", text: $message)
                .border(.secondary)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onSubmit {
                    Task {
                        await publish()
                    }
                }
            
            Spacer()
            Divider()
            Spacer()
            
            Text("Received Messages")
                .font(.headline)
            List {
                ForEach(store.messages) { msg in
                    Text(msg.text)
                }
            }
            .listStyle(InsetGroupedListStyle())
        }
        .padding()
        .task {
            await store.receiveMessages()
        }
    }
    
    private func publish() async {
        print("Going to publish \(message)")
        let result = await momentoClient.topicClient.publish(
            cacheName: momentoClient.cacheName,
            topicName: momentoClient.topicName,
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
