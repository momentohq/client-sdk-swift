import Momento

func main() async {
    print("Running Momento Topics example!")
    let cacheName = "my-cache"
    let topicName = "my-topic"

    var creds: CredentialProviderProtocol
    do {
        creds = try CredentialProvider.fromEnvironmentVariable(envVariableName: "MOMENTO_API_KEY")
    } catch {
        print("Error establishing credential provider: \(error)")
        return
    }

    let client = TopicClient(configuration: TopicClientConfigurations.iOS.latest(), credentialProvider: creds)

    let subscribeResponse = await client.subscribe(cacheName: cacheName, topicName: topicName)
    #if swift(>=5.9)
    let subscription = switch subscribeResponse {
        case .error(let err): fatalError("Error subscribing to topic: \(err)")
        case .subscription(let sub): sub
    }
    #else 
    let subscription: TopicSubscription
    switch subscribeResponse {
        case .error(let err):
            fatalError("Error subscribing to topic: \(err)")
        case .subscription(let sub):
            subscription = sub
    }
    #endif
    print("Subscribed to the topic")

    Task {
        print("Publishing a message every 2 seconds")
        let messages = ["hello", "and", "welcome", "to", "momento", "topics"]
        for message in messages {
            // Sleep for 2 seconds
            try! await Task.sleep(nanoseconds: 2_000_000_000)

            // Publish the message
            let publishResponse = await client.publish(cacheName: cacheName, topicName: topicName, value: message)

            // Check the response type (error or success?)
            switch publishResponse {
            case .error(let err):
                print("Publish error: \(err)")
                return
            case .success(_):
                print("Successfully published: \(message)")
            }
        }
    }

    // Unsubscribe to stop looping over subscription in 10 seconds
    Task {
        try await Task.sleep(nanoseconds: 10_000_000_000)
        print("Unsubscribing from topic")
        subscription.unsubscribe()
    }

    // Receive messages from the subscription as they arrive
    for try await item in subscription.stream {
        var value: String = ""
        switch item {
        case .itemText(let textItem):
            value = textItem.value
            print("Subscriber recieved text message: \(value)")
        case .itemBinary(let binaryItem):
            value = String(decoding: binaryItem.value, as: UTF8.self)
            print("Subscriber recieved binary message: \(value)")
        case .error(let err):
            print("Subscriber received error: \(err)")
        }
    }

    client.close()
    print("Closed topic client, successful end of example")
}

await main()
