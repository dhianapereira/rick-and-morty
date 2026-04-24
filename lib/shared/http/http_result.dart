import 'package:rickandmorty/shared/http/http_failure.dart';

sealed class HttpResult<T> {
  const HttpResult();

  bool get isSuccess => this is HttpSuccess<T>;
  bool get isFailure => this is HttpFailureResult<T>;
}

class HttpSuccess<T> extends HttpResult<T> {
  const HttpSuccess({required this.data, required this.statusCode});

  final T data;
  final int statusCode;
}

class HttpFailureResult<T> extends HttpResult<T> {
  const HttpFailureResult({required this.failure});

  final HttpFailure failure;
}
