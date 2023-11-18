// Prebuilt configurations for Momento Cache clients

public enum CacheConfigurations {

    public enum Default {

        public static func latest() -> CacheClientConfiguration {
            return CacheClientConfiguration(
                loggerFactory: DefaultMomentoLoggerFactory(),
                transportStrategy: StaticTransportStrategy(
                    grpcConfig: StaticGrpcConfiguration(deadline: 15.0)
                )
            )
        }

        public static func v1()  -> CacheClientConfiguration {
            return latest()
        }

    }

}
