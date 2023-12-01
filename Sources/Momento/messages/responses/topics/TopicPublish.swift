public protocol TopicPublishResponse {}

public class TopicPublishSuccess: TopicPublishResponse {}

public class TopicPublishError: ErrorResponseBase, TopicPublishResponse {}
