// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "momento-quickstart",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13),
        .visionOS(.v1),
    ],
    products: [
        .executable(
            name: "momento-quickstart",
            targets: ["momento-quickstart"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/momentohq/client-sdk-swift", exact: "0.8.0")
    ],
    targets: [
        .executableTarget(
            name: "momento-quickstart",
            dependencies: [
                .product(name: "Momento", package: "client-sdk-swift")
            ],
            path: "Sources"
        )
    ]
)
