import client_sdk_swift

func main() async {
    print("Hello World")

    var creds: CredentialProviderProtocol
    do {
        creds = try CredentialProvider.fromEnvironmentVariable(envVariableName: "MOMENTO_API_KEY")
    } catch {
        print("Error establishing credential provider: \(error)")
        return
    }
    
    let client = TopicClient(configuration: TopicConfigurations.Default.latest(), credentialProvider: creds)
    
    let subscribeResponse = await client.subscribe(cacheName: "my-cache", topicName: "my-topic")
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
    
    let publishResponse = await client.publish(cacheName: "my-cache", topicName: "my-topic", value: "hello world")
    switch publishResponse {
    case is TopicPublishError:
        print("Publish error: \((publishResponse as! TopicPublishError).description)")
        return
    case is TopicPublishSuccess:
        print("Successful publish!")
    default:
        print("Unknown publish response: \(publishResponse)")
        return
    }
    
    let subscription = (subscribeResponse as! TopicSubscribeSuccess).subscription
    do {
        for try await item in subscription {
            print("Received subscription item: \(String(describing: item))")
            let value = (item as! TopicSubscriptionItemText).value
            print("Subscription item value: \(value)")
            break
        }
    } catch {
        print("Error while awaiting subscription item: \(error)")
        return
    }
    
    
    client.close()
    print("Closed topic client, successful end of example")
}

Task.init { await main() }
