/// Prebuilt configurations for Momento Topics clients
public enum TopicClientConfigurations {

    public enum iOS {
        public static func latest() -> TopicClientConfiguration {
            return TopicClientConfiguration(
                transportStrategy: StaticTransportStrategy(
                    grpcConfig: StaticGrpcConfiguration(deadline: 15.0)
                )
            )
        }
    }
    
    public enum macOS {
        public static func latest() -> TopicClientConfiguration {
            return TopicClientConfiguration(
                transportStrategy: StaticTransportStrategy(
                    grpcConfig: StaticGrpcConfiguration(deadline: 15.0)
                )
            )
        }
    }

}
