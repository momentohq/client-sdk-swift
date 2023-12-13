import SwiftUI
import Momento

struct ContentView: View {
    @State private var momentoClient: Momento
    @State private var message: String = ""
    @State private var looping: Bool = false
    @ObservedObject var store: MessageStore
    
    public init(momentoClient: Momento) {
        self.store = MessageStore(momentoClient: momentoClient)
        self.momentoClient = momentoClient
    }
    
    var body: some View {
        VStack {
            Text("Publish New Messages")
                .font(.title)
                .foregroundStyle(Color(red: 196/225, green: 241/225, blue: 53/225))
            TextField("Enter your message here", text: $message)
                .border(.secondary)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .onSubmit {
                    Task {
                        await publish()
                        message = ""
                    }
                }
            if looping == false {
                Button("Print as a loop") {
                    looping = true
                    print("Print as a loop")
                    Task {
                        while looping {
                            await publish()
                            // wait 1.5 seconds before publishing again
                            try! await Task.sleep(nanoseconds: 1_500_000_000)
                        }
                    }
                }
                .padding()
                .background(Color(red: 196/225, green: 241/225, blue: 53/225))
                .clipShape(Capsule())
                .foregroundColor(.black)
            } else {
                Button("Stop looping") {
                    looping = false
                    message = ""
                    print("Stop looping")
                }
                .padding()
                .background(Color(red: 196/225, green: 241/225, blue: 53/225))
                .clipShape(Capsule())
                .foregroundColor(.black)
            }
            
            Spacer()
            Divider()
            Spacer()
            
            Text("Received Messages")
                .font(.title)
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
        if message.isEmpty {
            return
        }
        
        print("Going to publish \(message)")
        let result = await momentoClient.topicClient.publish(
            cacheName: momentoClient.cacheName,
            topicName: momentoClient.topicName,
            value: message
        )
        switch result {
        case .success(_):
            print("Successful publish")
        case .error(let err):
            print("Error publishing: \(err)")
        }
    }
}
