/// Prebuilt configurations for Momento Cache clients
public enum CacheClientConfigurations {

    public enum iOS {
        /// Provides the latest recommended configuration for the `CacheClient` on iOS platforms
        public static func latest() -> CacheClientConfiguration {
            return CacheClientConfiguration(
                transportStrategy: StaticTransportStrategy(
                    grpcConfig: StaticGrpcConfiguration(deadline: 15.0)
                )
            )
        }
    }
    
    public enum macOS {
        /// Provides the latest recommended configuration for the `CacheClient` on macOS platforms
        public static func latest() -> CacheClientConfiguration {
            return CacheClientConfiguration(
                transportStrategy: StaticTransportStrategy(
                    grpcConfig: StaticGrpcConfiguration(deadline: 15.0)
                )
            )
        }
    }

}
