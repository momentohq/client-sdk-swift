// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "momento-cache-example",
    platforms: [.macOS(.v10_15), .iOS(.v13)],
    products: [
        .executable(
            name: "momento-cache-example",
            targets: ["momento-cache-example"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/momentohq/client-sdk-swift", exact: "0.4.0")
    ],
    targets: [
        .executableTarget(
            name: "momento-cache-example",
            dependencies: [
                .product(name: "Momento", package: "client-sdk-swift"),
            ],
            path: "Sources"
        ),
    ]
)
