# Momento Topics Example

## Prerequisites

- A Momento API key is required, you can generate one using the [Momento Console](https://console.gomomento.com/api-keys). 
- A Momento service endpoint is required. You can find a [list of them here](https://docs.momentohq.com/platform/regions)
- A Momento Cache named `my-cache`. You can create a cache in the [Momento Console](https://console.gomomento.com/cache) as well.

## Running the example

Navigate to the `Examples/topics` folder, then run the example:

```
cd Examples/topics
MOMENTO_API_KEY=<your-api-key> MOMENTO_ENDPOINT=<endpoint> swift run
```
