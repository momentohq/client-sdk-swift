# Momento Topics Example

## Prerequisites

- A Momento API key is required, you can generate one using the [Momento Console](https://console.gomomento.com). 
- A Momento Cache, which you can also create using the [Momento Console](https://console.gomomento.com). (The example expects a cache named `my-cache` to exist.)

## Running the example

In one terminal, compile and run the subscriber example:

```
cd Examples/topics
MOMENTO_API_KEY=<your-api-key> swift run subscriber
```

In another terminal, compile and run the publisher example:

```
cd Examples/topics
MOMENTO_API_KEY=<your-api-key> swift run publisher
```
