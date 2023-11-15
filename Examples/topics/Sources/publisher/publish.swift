import momento

func main() async {
    print("Running Momento Topics example publisher!")
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
    
    client.close()
    print("Closed topic client, successful end of publisher example")
}

await main()
