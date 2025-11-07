import Momento

func getTopicClient() -> TopicClient {
    var creds: CredentialProviderProtocol
    do {
        creds = try CredentialProvider.fromEnvironmentVariable(envVariableName: "MOMENTO_API_KEY")
    } catch {
        fatalError("Error establishing credential provider: \(error)")
    }
    return TopicClient(
        configuration: TopicClientConfigurations.iOS.latest(), credentialProvider: creds)
}

func main() async {
    print("Running Momento Topics example!")
    let cacheName = "cache"
    let topicName = "topic"

    // Start a subscriber task to listen for messages
    let subscribeTask = Task {
        let client = getTopicClient()

        let subscribeResponse = await client.subscribe(cacheName: cacheName, topicName: topicName)
        let subscription =
            switch subscribeResponse {
            case .error(let err): fatalError("Error subscribing to topic: \(err)")
            case .subscription(let sub): sub
            }
        print("Subscribed to the topic")

        // Receive messages from the subscription as they arrive
        for try await item in subscription.stream {
            var value: String = ""
            switch item {
            case .itemText(let textItem):
                value = textItem.value
                print("Subscriber recieved text message: \(value)")
                if value == "topics" {
                    print("Received final message, unsubscribing")
                    subscription.unsubscribe()
                    client.close()
                }
            case .itemBinary(let binaryItem):
                value = String(decoding: binaryItem.value, as: UTF8.self)
                print("Subscriber recieved binary message: \(value)")
            case .error(let err):
                print("Subscriber received error: \(err)")
                print("Unsubscribing due to error")
                subscription.unsubscribe()
                client.close()
            }
        }
    }

    // Start a publisher task to send messages
    let publishTask = Task {
        let client = getTopicClient()

        print("Publishing a message every second")
        let messages = ["hello", "and", "welcome", "to", "momento", "topics"]
        for message in messages {
            // Sleep for 1 second
            try! await Task.sleep(nanoseconds: 1_000_000_000)

            // Publish the message
            let publishResponse = await client.publish(
                cacheName: cacheName, topicName: topicName, value: message)

            // Check the response type (error or success?)
            switch publishResponse {
            case .error(let err):
                print("Publish error: \(err)")
                return
            case .success(_):
                print("Successfully published: \(message)")
            }
        }
        client.close()
    }

    do {
        let _: [Any] = await [publishTask.value, try subscribeTask.value]
    } catch {
        print("Error in subscribe task: \(error)")
    }
    print("successful end of example")
}

await main()
