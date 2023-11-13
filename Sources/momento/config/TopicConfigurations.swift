// Prebuilt configurations for Momento Topics clients

public class Default: TopicClientConfiguration {
    static func latest() -> TopicClientConfiguration {
        return TopicClientConfiguration(
            loggerFactory: DefaultMomentoLoggerFactory(),
            transportStrategy: StaticTransportStrategy(
                grpcConfig: StaticGrpcConfiguration(deadline: 15.0)
            )
        )
    }
}
