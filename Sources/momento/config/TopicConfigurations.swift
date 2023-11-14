// Prebuilt configurations for Momento Topics clients

enum TopicConfigurations {

    enum Default {

        static func latest() -> TopicClientConfiguration {
            return TopicClientConfiguration(
                loggerFactory: DefaultMomentoLoggerFactory(),
                transportStrategy: StaticTransportStrategy(
                    grpcConfig: StaticGrpcConfiguration(deadline: 15.0)
                )
            )
        }

        static func v1()  -> TopicClientConfiguration {
            return latest()
        }

    }

}
