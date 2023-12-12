public enum TopicPublishResponse {
    case success(TopicPublishSuccess)
    case error(TopicPublishError)
}

public class TopicPublishSuccess {}

public class TopicPublishError: ErrorResponseBase {}
