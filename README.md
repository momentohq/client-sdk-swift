<head>
  <meta name="Momento Go Client Library Documentation" content="Go client software development kit for Momento Cache">
</head>
<img src="https://docs.momentohq.com/img/logo.svg" alt="logo" width="400"/>

[![project status](https://momentohq.github.io/standards-and-practices/badges/project-status-official.svg)](https://github.com/momentohq/standards-and-practices/blob/main/docs/momento-on-github.md)
[![project stability](https://momentohq.github.io/standards-and-practices/badges/project-stability-alpha.svg)](https://github.com/momentohq/standards-and-practices/blob/main/docs/momento-on-github.md)

# Momento Swift SDK

To get started with Momento you will need a Momento API key. You can get one from the [Momento Console](https://console.gomomento.com).

* Website: [https://www.gomomento.com/](https://www.gomomento.com/)
* Momento Documentation: [https://docs.momentohq.com/](https://docs.momentohq.com/)
* Getting Started: [https://docs.momentohq.com/getting-started](https://docs.momentohq.com/getting-started)
* Discuss: [Momento Discord](https://discord.gg/3HkAKjUZGq)

## Packages

The Momento Swift SDK is available here on github: [momentohq/client-sdk-swift](https://github.com/momentohq/client-sdk-swift). Add the following to the `dependencies` section of your `Package.swift` file to include the SDK in your project:

```bash
.package(url: "https://github.com/momentohq/client-sdk-swift", exact: "0.2.1")
```

Your target dependencies will refer to the Momento SDK like so:

```bash
dependencies: [
    .product(name: "momento", package: "client-sdk-swift"),
],
```

## Usage

Check out our [topics example](./Examples/topics/README.md) directory for a complete example of using the Momento Swift SDK to implement a publish and subscribe system.

## Getting Started and Documentation

General documentation on Momento and the Momento SDKs is available on the [Momento Docs website](https://docs.momentohq.com/). Specific usage examples for the Swift SDK will be available there as well soon!

## Examples

Check out full working code in the [topics example](./Examples/topics/README.md) directory of this repository!

## Logging

We are using [swift-log](https://github.com/apple/swift-log) to create Loggers that use the default logging backend, which simply prints to stdout.
To change the logging backend and set your preferred logging level, call [`LoggingSystem.bootstrap(...)`](https://github.com/apple/swift-log/#default-logger-behavior) once at the beginning of your program ([example](https://github.com/sushichop/Puppy#use-with-appleswift-log)).

## Developing

If you are interested in contributing to the SDK, please see the [CONTRIBUTING](./CONTRIBUTING.md) docs.

----------------------------------------------------------------------------------------
For more info, visit our website at [https://gomomento.com](https://gomomento.com)!
