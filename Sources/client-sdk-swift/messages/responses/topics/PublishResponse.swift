public protocol PublishResponse {}

public class PublishSuccess: PublishResponse {}

public class PublishError: ErrorResponseBase & PublishResponse {}
