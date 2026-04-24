import 'dart:async';

import 'package:dio/dio.dart';
import 'package:rickandmorty/shared/http/http_failure.dart';
import 'package:rickandmorty/shared/http/http_request.dart';
import 'package:rickandmorty/shared/http/http_result.dart';

typedef ResponseDecoder<T> = T Function(dynamic data);

class ClientHttp {
  ClientHttp({
    Dio? dio,
    BaseOptions? options,
    Iterable<Interceptor> interceptors = const <Interceptor>[],
  }) : _dio = dio ?? Dio(_defaultOptions(options)) {
    _dio.interceptors.addAll(interceptors);
  }

  final Dio _dio;

  static BaseOptions _defaultOptions(BaseOptions? options) {
    if (options != null) {
      return options;
    }

    return BaseOptions(
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      sendTimeout: const Duration(seconds: 10),
      responseType: ResponseType.json,
      validateStatus: (_) => true,
      headers: const <String, dynamic>{'accept': 'application/json'},
    );
  }

  Future<HttpResult<T>> send<T>(
    HttpRequest request, {
    ResponseDecoder<T>? decoder,
  }) async {
    try {
      final Response<dynamic> response = await _dio.request<dynamic>(
        request.path,
        queryParameters: request.queryParameters,
        cancelToken: request.cancelToken,
        options: Options(method: 'GET', headers: request.headers),
      );

      final int statusCode = response.statusCode ?? 0;

      if (!_isSuccessStatusCode(statusCode)) {
        return HttpFailureResult<T>(
          failure: _mapResponseFailure(
            statusCode: statusCode,
            data: response.data,
          ),
        );
      }

      return HttpSuccess<T>(
        data: _decodeResponse<T>(response.data, decoder),
        statusCode: statusCode,
      );
    } on DioException catch (exception) {
      return HttpFailureResult<T>(failure: _mapDioFailure(exception));
    } on TimeoutException {
      return HttpFailureResult<T>(
        failure: HttpFailure(
          type: HttpFailureType.timeout,
          message: 'The request timed out.',
        ),
      );
    } catch (_) {
      return HttpFailureResult<T>(
        failure: HttpFailure(
          type: HttpFailureType.unknown,
          message: 'An unexpected error happened.',
        ),
      );
    }
  }

  bool _isSuccessStatusCode(int statusCode) {
    return statusCode >= 200 && statusCode < 300;
  }

  T _decodeResponse<T>(dynamic data, ResponseDecoder<T>? decoder) {
    if (decoder != null) {
      return decoder(data);
    }

    return data as T;
  }

  HttpFailure _mapDioFailure(DioException exception) {
    return switch (exception.type) {
      DioExceptionType.cancel => const HttpFailure(
        type: HttpFailureType.cancelled,
        message: 'The request was cancelled.',
      ),
      DioExceptionType.connectionTimeout ||
      DioExceptionType.receiveTimeout ||
      DioExceptionType.sendTimeout => const HttpFailure(
        type: HttpFailureType.timeout,
        message: 'The request timed out.',
      ),
      DioExceptionType.connectionError => const HttpFailure(
        type: HttpFailureType.network,
        message: 'A network error happened.',
      ),
      DioExceptionType.badResponse => _mapResponseFailure(
        statusCode: exception.response?.statusCode ?? 0,
        data: exception.response?.data,
      ),
      DioExceptionType.badCertificate ||
      DioExceptionType.unknown => HttpFailure(
        type: HttpFailureType.unknown,
        message: exception.message ?? 'An unexpected error happened.',
        statusCode: exception.response?.statusCode,
      ),
    };
  }

  HttpFailure _mapResponseFailure({required int statusCode, dynamic data}) {
    final String message = _resolveFailureMessage(data, statusCode);
    return switch (statusCode) {
      400 => HttpFailure(
        type: HttpFailureType.badRequest,
        message: message,
        statusCode: statusCode,
      ),
      401 => HttpFailure(
        type: HttpFailureType.unauthorized,
        message: message,
        statusCode: statusCode,
      ),
      403 => HttpFailure(
        type: HttpFailureType.forbidden,
        message: message,
        statusCode: statusCode,
      ),
      404 => HttpFailure(
        type: HttpFailureType.notFound,
        message: message,
        statusCode: statusCode,
      ),
      409 => HttpFailure(
        type: HttpFailureType.conflict,
        message: message,
        statusCode: statusCode,
      ),
      422 => HttpFailure(
        type: HttpFailureType.validation,
        message: message,
        statusCode: statusCode,
      ),
      _ => HttpFailure(
        type: HttpFailureType.server,
        message: message,
        statusCode: statusCode,
      ),
    };
  }

  String _resolveFailureMessage(dynamic data, int statusCode) {
    if (data is Map<String, dynamic>) {
      final dynamic directMessage = data['message'];

      if (directMessage is String && directMessage.isNotEmpty) {
        return directMessage;
      }

      final dynamic error = data['error'];

      if (error is String && error.isNotEmpty) {
        return error;
      }
    }

    return 'Request failed with status code $statusCode.';
  }
}
