/// Prebuilt configurations for Momento Topics clients
public enum TopicConfigurations {

    public enum Default {

        public static func latest() -> TopicClientConfiguration {
            return TopicClientConfiguration(
                transportStrategy: StaticTransportStrategy(
                    grpcConfig: StaticGrpcConfiguration(deadline: 15.0)
                )
            )
        }

        public static func v1()  -> TopicClientConfiguration {
            return latest()
        }

    }

}
