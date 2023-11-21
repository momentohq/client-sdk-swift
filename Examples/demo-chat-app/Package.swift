// swift-tools-version: 5.6
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
// TODO: update @available(macOS 10.15, *) tags in momento library to @available(macOS 10.15, iOS 13, *) and cut another release before consuming from the url
//        .package(url: "https://github.com/momentohq/client-sdk-swift", exact: "0.2.0"),
        .package(name: "momento", path: "../.."),
    ],
    targets: [
        .target(
            name: "demo-chat-app",
            dependencies: [
//                .product(name: "momento", package: "client-sdk-swift"),
                "momento"
            ],
            path: "Sources"
        ),
    ]
)
