// swift-tools-version: 5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "momento",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "momento",
            targets: ["momento"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-protobuf.git", from: "1.6.0"),
        .package(url: "https://github.com/grpc/grpc-swift.git", from: "1.15.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "momento",
            dependencies: [
                .product(name: "SwiftProtobuf", package: "swift-protobuf"),
                .product(name: "GRPC", package: "grpc-swift")],
            exclude: [
                "internal/protos/auth.proto",
                "internal/protos/cacheclient.proto",
                "internal/protos/cacheping.proto",
                "internal/protos/cachepubsub.proto",
                "internal/protos/controlclient.proto",
                "internal/protos/extensions.proto",
                "internal/protos/leaderboard.proto",
                "internal/protos/permissionmessages.proto",
                "internal/protos/token.proto",
                "internal/protos/vectorindex.proto",
                "internal/protos/webhook.proto"
            ]
        ),
        .testTarget(
            name: "momentoTests",
            dependencies: ["momento", .product(name: "SwiftProtobuf", package: "swift-protobuf"), .product(name: "GRPC", package: "grpc-swift")]
        )
    ]
)
