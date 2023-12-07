/// Prebuilt configurations for Momento Cache clients
public enum CacheConfigurations {

    public enum Default {

        /// Provides the latest recommended configuration for the `CacheClient`
        public static func latest() -> CacheClientConfiguration {
            return CacheClientConfiguration(
                transportStrategy: StaticTransportStrategy(
                    grpcConfig: StaticGrpcConfiguration(deadline: 15.0)
                )
            )
        }

        /// Provides v1 recommended configuration for the `CacheClient`
        public static func v1()  -> CacheClientConfiguration {
            return latest()
        }

    }

}
