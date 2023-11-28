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
                .foregroundStyle(Color(red: 196/225, green: 241/225, blue: 53/225))
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
                .foregroundStyle(Color(red: 196/225, green: 241/225, blue: 53/225))
            List {
                ForEach(store.messages) { msg in
                    Text(msg.text)
                }
            }
            .listStyle(InsetGroupedListStyle())
            .background(Color(red: 37/225, green: 57/225, blue: 43/225))
        }
        .padding()
        .task {
            await store.receiveMessages()
        }
        .background(Color(red: 37/225, green: 57/225, blue: 43/225))
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
