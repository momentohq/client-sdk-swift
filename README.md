<head>
  <meta name="Momento Go Client Library Documentation" content="Go client software development kit for Momento Cache">
</head>
<img src="https://docs.momentohq.com/img/logo.svg" alt="logo" width="400"/>

[![project status](https://momentohq.github.io/standards-and-practices/badges/project-status-official.svg)](https://github.com/momentohq/standards-and-practices/blob/main/docs/momento-on-github.md)
[![project stability](https://momentohq.github.io/standards-and-practices/badges/project-stability-beta.svg)](https://github.com/momentohq/standards-and-practices/blob/main/docs/momento-on-github.md)

# Momento Swift SDK

To get started with Momento you will need a Momento API key. You can get one from the [Momento Console](https://console.gomomento.com).

* Website: [https://www.gomomento.com/](https://www.gomomento.com/)
* Momento Documentation: [https://docs.momentohq.com/](https://docs.momentohq.com/)
* Getting Started: [https://docs.momentohq.com/getting-started](https://docs.momentohq.com/getting-started)
* Discuss: [Momento Discord](https://discord.gg/3HkAKjUZGq)

## Packages

The Momento Swift SDK is available here on github: [momentohq/client-sdk-swift](https://github.com/momentohq/client-sdk-swift). 

Edit your `Package.swift` file to include the SDK in your project:

```swift
// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "momento-example",
    platforms: [.macOS(.v10_15), .iOS(.v13)],
    products: [
        .executable(
            name: "momento-example",
            targets: ["momento-example"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/momentohq/client-sdk-swift", exact: "0.3.2")
    ],
    targets: [
        .executableTarget(
            name: "momento-example",
            dependencies: [
                .product(name: "Momento", package: "client-sdk-swift"),
            ],
            path: "Sources"
        ),
    ]
)
```

## Usage

Check out our [topics example](./Examples/topics/README.md) directory for a complete example of using the Momento Swift SDK to implement a publish and subscribe system.

## Getting Started and Documentation

General documentation on Momento and the Momento SDKs is available on the [Momento Docs website](https://docs.momentohq.com/). Specific usage examples for the Swift SDK will be available there as well soon!

## Examples

Check out full working code in the [topics example](./Examples/topics/README.md) directory of this repository!

## Logging

We are using [swift-log](https://github.com/apple/swift-log) to create internal Loggers for producing Momento-related logs. 
The default logging backend provided by swift-log ([`StreamLogHandler`](https://github.com/apple/swift-log/#default-logger-behavior)) simply prints to stdout at a default logging level of `.info`.

To change the logging level and/or redirect logs to stderr, you would call  [`LoggingSystem.bootstrap(...)`](https://github.com/apple/swift-log/#default-logger-behavior) once at the beginning of your program like so:
```
LoggingSystem.bootstrap {
    var handler = StreamLogHandler.standardError(label: "momento-logger")
    handler.logLevel = .debug
    return handler
}
```

You can also use the `LoggingSystem.bootstrap` call to configure your preferred [swift-log compatible logging backend](https://github.com/apple/swift-log/#available-logging-backends-for-applications) or to use your [custom logging backend implementation](https://github.com/apple/swift-log/#on-the-implementation-of-a-logging-backend-a-loghandler).

## Developing

If you are interested in contributing to the SDK, please see the [CONTRIBUTING](./CONTRIBUTING.md) docs.

----------------------------------------------------------------------------------------
For more info, visit our website at [https://gomomento.com](https://gomomento.com)!
