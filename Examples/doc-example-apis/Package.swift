// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "doc-example-apis",
    dependencies: [
        // TODO: use released version
        .package(name: "Momento", path: "../..")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .executableTarget(
            name: "doc-example-apis",
            dependencies: [
                // .product(name: "Momento", package: "client-sdk-swift")
                "Momento"
            ]
        ),
    ]
)
