import 'package:dio/dio.dart';

class HttpRequest {
  const HttpRequest({
    required this.path,
    this.queryParameters,
    this.headers,
    this.cancelToken,
  });

  final String path;
  final Map<String, dynamic>? queryParameters;
  final Map<String, dynamic>? headers;
  final CancelToken? cancelToken;
}
