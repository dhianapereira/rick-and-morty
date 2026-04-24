enum HttpFailureType {
  badRequest,
  unauthorized,
  forbidden,
  notFound,
  conflict,
  validation,
  server,
  timeout,
  cancelled,
  network,
  unknown,
}

class HttpFailure {
  const HttpFailure({
    required this.type,
    required this.message,
    this.statusCode,
  });

  final HttpFailureType type;
  final String message;
  final int? statusCode;
}
