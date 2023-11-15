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

    let subscription = (subscribeResponse as! TopicSubscribeSuccess).subscription
    do {
        for try await item in subscription {
            let value = (item as! TopicSubscriptionItemText).value
            print("Subscriber received message: \(value)")
            
            // we can exit the loop once we receive the last message
            if value == "topics" {
                break
            }
        }
    } catch {
        print("Error while awaiting subscription item: \(error)")
        return
    }

    client.close()
    print("Closed topic client, successful end of example")
}

await main()
