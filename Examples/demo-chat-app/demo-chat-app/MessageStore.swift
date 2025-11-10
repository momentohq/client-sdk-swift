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
            #if swift(>=5.9)
            self.subscription = switch subResp {
                case .subscription(let sub): sub
                case .error(let err): fatalError("Unable to establish Topics subscription: \(err)")
            }
            #else 
            switch subscribeResponse {
                case .error(let err):
                    fatalError("Unable to establish Topics subscription: \(err)")
                case .subscription(let sub):
                    self.subscription = sub
            }
            #endif
        }
        
        for try await item in await self.subscription!.stream {
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
    }
}
