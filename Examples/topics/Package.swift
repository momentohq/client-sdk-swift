// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "momento-topics-example",
    platforms: [.macOS(.v10_15), .iOS(.v13)],
    products: [
        .executable(
            name: "momento-topics-example",
            targets: ["momento-topics-example"]
        ),
    ],
    dependencies: [
        .package(name: "client-sdk-swift", path: "../.."),
    ],
    targets: [
        .executableTarget(
            name: "momento-topics-example",
            dependencies: [
                "client-sdk-swift",
            ],
            path: "Sources"
        ),
    ]
)
