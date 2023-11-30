// swift-tools-version: 5.4
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Momento",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "Momento",
            targets: ["Momento"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-protobuf.git", from: "1.6.0"),
        .package(url: "https://github.com/grpc/grpc-swift.git", from: "1.15.0")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "Momento",
            dependencies: [
                .product(name: "SwiftProtobuf", package: "swift-protobuf"),
                .product(name: "GRPC", package: "grpc-swift")]
        ),
        .testTarget(
            name: "MomentoTests",
            dependencies: ["Momento", .product(name: "SwiftProtobuf", package: "swift-protobuf"), .product(name: "GRPC", package: "grpc-swift")]
        )
    ]
)
