// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "momento-cache-example",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13),
        .visionOS(.v1),
    ],
    products: [
        .executable(
            name: "momento-cache-example",
            targets: ["momento-cache-example"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/momentohq/client-sdk-swift", exact: "0.7.2")
    ],
    targets: [
        .executableTarget(
            name: "momento-cache-example",
            dependencies: [
                // .product(name: "Momento", package: "client-sdk-swift"),
                "Momento"
            ],
            path: "Sources"
        )
    ]
)
