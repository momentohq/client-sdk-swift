let defaultLoggerFactory = DefaultMomentoLoggerFactory()

public class Default: TopicClientConfiguration {
    static func latest() -> TopicClientConfiguration {
        return TopicClientConfiguration(loggerFactory: defaultLoggerFactory, transportStrategy: StaticTransportStrategy(grpcConfig: StaticGrpcConfiguration(deadline: 15.0)))
    }
}
