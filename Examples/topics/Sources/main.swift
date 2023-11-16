import momento

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

    let client = TopicClient(configuration: TopicConfigurations.Default.latest(), credentialProvider: creds)

    let subscribeResponse = await client.subscribe(cacheName: cacheName, topicName: topicName)
    
    switch subscribeResponse {
    case is TopicSubscribeError:
        print("Subscribe error: \((subscribeResponse as! TopicSubscribeError).description)")
        return
    case is TopicSubscribeSuccess:
        print("Successful subscription!")
    default:
        print("Unknown subscribe response: \(subscribeResponse)")
        return
    }
    
    let receiveTask = Task {
        let subscription = (subscribeResponse as! TopicSubscribeSuccess).subscription
        do {
            for try await item in subscription {
                var value: String = ""
                switch item {
                case is TopicSubscriptionItemText:
                    value = (item as! TopicSubscriptionItemText).value
                    print("Subscriber recieved text message: \(value)")
                case is TopicSubscriptionItemBinary:
                    let binaryValue = (item as! TopicSubscriptionItemBinary).value
                    value = String(decoding: binaryValue, as: UTF8.self)
                    print("Subscriber recieved binary message: \(value)")
                default:
                    print("received unknown item type: \(item)")
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
        case is TopicPublishError:
            print("Publish error: \((publishResponse as! TopicPublishError).description)")
            return
        case is TopicPublishSuccess:
            print("Successfully published: \(message)")
        default:
            print("Unknown publish response: \(publishResponse)")
            return
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
