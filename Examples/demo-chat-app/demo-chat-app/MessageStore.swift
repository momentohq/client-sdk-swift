import SwiftUI
import CoreData
import momento

struct ReceivedMessage: Identifiable {
    let id = UUID()
    let text: String
}

public class MessageStore: ObservableObject {
    @State private var momentoClient: Momento
    @Published var messages: [ReceivedMessage] = [ReceivedMessage(text: "Welcome to Momento Topics!")]
    private var subscription: TopicSubscribeSuccess? = nil
    
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
            case let subResp as TopicSubscribeSuccess:
                self.subscription = subResp
                print("Successful subscription")
            default:
                fatalError("Unable to establish Topics subscription")
            }
        }
        
        do {
            for try await item in self.subscription!.subscription {
                var value: String = ""
                switch item {
                case let textItem as TopicSubscriptionItemText:
                    value = textItem.value
                    print("Subscriber recieved text message: \(value)")
                    messages.append(ReceivedMessage(text: value))
                case let binaryItem as TopicSubscriptionItemBinary:
                    value = String(decoding: binaryItem.value, as: UTF8.self)
                    print("Subscriber recieved binary message: \(value)")
                    messages.append(ReceivedMessage(text: value))
                default:
                    print("received unknown item type: \(item)")
                }
            }
        } catch {
            print("Error while awaiting subscription item: \(error)")
        }
    }
}
