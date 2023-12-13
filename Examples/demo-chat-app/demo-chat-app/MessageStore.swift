import SwiftUI
import CoreData
import Momento

struct ReceivedMessage: Identifiable {
    let id = UUID()
    let text: String
}

public class MessageStore: ObservableObject {
    @State private var momentoClient: Momento
    @Published var messages: [ReceivedMessage] = [ReceivedMessage(text: "Welcome to Momento Topics!")]
    private var subscription: TopicSubscription? = nil
    
    init(momentoClient: Momento) {
        self.momentoClient = momentoClient
    }
    
    @MainActor
    func receiveMessages() async {
        if self.subscription == nil {
            let subResp = await momentoClient.topicClient.subscribe(
                cacheName: momentoClient.cacheName,
                topicName: momentoClient.topicName
            )
            switch subResp {
            case .subscription(let subscription):
                self.subscription = subscription
                print("Successful subscription")
            case .error(let err):
                fatalError("Unable to establish Topics subscription: \(err)")
            }
        }
        
        do {
            for try await item in self.subscription!.stream {
                var value: String = ""
                switch item {
                case .itemText(let textItem):
                    value = textItem.value
                    print("Subscriber recieved text message: \(value)")
                    messages.append(ReceivedMessage(text: value))
                case .itemBinary(let binaryItem):
                    value = String(decoding: binaryItem.value, as: UTF8.self)
                    print("Subscriber recieved binary message: \(value)")
                    messages.append(ReceivedMessage(text: value))
                case .error(let err):
                    print("Subscriber received error: \(err)")
                }
            }
        } catch {
            print("Error while awaiting subscription item: \(error)")
        }
    }
}
