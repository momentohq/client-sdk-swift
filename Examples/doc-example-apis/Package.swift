// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "doc-example-apis",
    dependencies: [
        // TODO: use released version
        .package(name: "Momento", path: "../..")
    ],
    targets: [
        .executableTarget(
            name: "doc-example-apis",
            dependencies: [
                // TODO: use released version
                // .product(name: "Momento", package: "client-sdk-swift")
                "Momento"
            ],
            path: "Sources"
        ),
    ]
)
