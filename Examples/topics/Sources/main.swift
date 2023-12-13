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
    
    let subscription: TopicSubscription?
    switch subscribeResponse {
    case .error(let err):
        print("Subscribe error: \(err)")
        return
    case .subscription(let sub):
        print("Successful subscription!")
        subscription = sub
    }

    let receiveTask = Task {
        do {
            for try await item in subscription!.stream {
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

                // we can exit the loop once we receive the last message
                if value == "topics" {
                    return
                }
            }
        } catch {
            print("Error while awaiting subscription item: \(error)")
            return
        }
    }

    let messages = ["hello", "welcome", "to", "momento", "topics"]
    for message in messages {
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
    
    // timeout in 10 seconds
    let timeoutTask = Task {
        try await Task.sleep(nanoseconds: 10_000_000_000)
        receiveTask.cancel()
    }

    // set up safeguard mechanism to stop the example if not all
    // messages are received within 10 seconds
    await withTaskCancellationHandler {
        await receiveTask.value
        timeoutTask.cancel()
        return
    } onCancel: {
        receiveTask.cancel()
        timeoutTask.cancel()
    }

    client.close()
    print("Closed topic client, successful end of example")
}

await main()
