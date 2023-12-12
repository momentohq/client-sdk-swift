/// Prebuilt configurations for Momento Topics clients
public enum TopicClientConfigurations {

    public enum iOS {
        /// Provides the default configuration for the `TopicClient` on iOS platforms
        public static func defaultConfig() -> TopicClientConfiguration {
            return latest()
        }
        
        /// Provides the latest recommended configuration for the `TopicClient` on iOS platforms
        public static func latest() -> TopicClientConfiguration {
            return TopicClientConfiguration(
                transportStrategy: StaticTransportStrategy(
                    grpcConfig: StaticGrpcConfiguration(deadline: 15.0)
                )
            )
        }
    }
    
    public enum macOS {
        /// Provides the default configuration for the `TopicClient` on macOS platforms
        public static func defaultConfig() -> TopicClientConfiguration {
            return latest()
        }
        
        /// Provides the latest recommended configuration for the `TopicClient` on macOS platforms
        public static func latest() -> TopicClientConfiguration {
            return TopicClientConfiguration(
                transportStrategy: StaticTransportStrategy(
                    grpcConfig: StaticGrpcConfiguration(deadline: 15.0)
                )
            )
        }
    }

}
