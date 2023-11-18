// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "demo-chat-app",
    platforms: [.iOS(.v13)],
    products: [
        .library(
            name: "demo-chat-app",
            targets: ["demo-chat-app"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/momentohq/client-sdk-swift", exact: "0.2.0")
    ],
    targets: [
        .target(
            name: "demo-chat-app",
            dependencies: [
                "momento",
            ],
            path: "Sources"
        ),
    ]
)
