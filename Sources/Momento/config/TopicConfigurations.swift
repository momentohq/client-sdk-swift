/// Prebuilt configurations for Momento Topics clients
public enum TopicConfigurations {

    public enum Default {

        /// Provides the latest recommended configuration for the `TopicClient`
        public static func latest() -> TopicClientConfiguration {
            return TopicClientConfiguration(
                transportStrategy: StaticTransportStrategy(
                    grpcConfig: StaticGrpcConfiguration(deadline: 15.0)
                )
            )
        }
        
        /// Provides the v1 recommended configuration for the `TopicClient`
        public static func v1()  -> TopicClientConfiguration {
            return latest()
        }

    }

}
