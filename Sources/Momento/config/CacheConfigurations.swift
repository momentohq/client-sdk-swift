/// Prebuilt configurations for Momento Cache clients
public enum CacheClientConfigurations {

    public enum iOS {
        public static func latest() -> CacheClientConfiguration {
            return CacheClientConfiguration(
                transportStrategy: StaticTransportStrategy(
                    grpcConfig: StaticGrpcConfiguration(deadline: 15.0)
                )
            )
        }
    }
    
    public enum macOS {
        public static func latest() -> CacheClientConfiguration {
            return CacheClientConfiguration(
                transportStrategy: StaticTransportStrategy(
                    grpcConfig: StaticGrpcConfiguration(deadline: 15.0)
                )
            )
        }
    }

}
