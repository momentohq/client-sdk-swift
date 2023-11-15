// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "momento-topics-example",
    platforms: [.macOS(.v10_15), .iOS(.v13)],
    products: [
        .executable(
            name: "publisher",
            targets: ["publisher"]
        ),
        .executable(
            name: "subscriber",
            targets: ["subscriber"]
        ),
    ],
    dependencies: [
        .package(name: "momento", path: "../.."),
    ],
    targets: [
        .executableTarget(
            name: "publisher",
            dependencies: [
                "momento",
            ],
            sources: ["publish.swift"]
        ),
        .executableTarget(
            name: "subscriber",
            dependencies: [
                "momento",
            ],
            sources: ["subscribe.swift"]
        ),
    ]
)
