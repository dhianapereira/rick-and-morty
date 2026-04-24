import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rickandmorty/shared/http/client_http.dart';
import 'package:rickandmorty/shared/http/http_failure.dart';
import 'package:rickandmorty/shared/http/http_request.dart';
import 'package:rickandmorty/shared/http/http_result.dart';

void main() {
  test(
    'Should return success result when request completes with success code',
    () async {
      final Dio dio = Dio()
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest:
                (RequestOptions options, RequestInterceptorHandler handler) {
                  handler.resolve(
                    Response<Map<String, dynamic>>(
                      requestOptions: options,
                      statusCode: 200,
                      data: const <String, dynamic>{
                        'results': <String>['rick'],
                      },
                    ),
                  );
                },
          ),
        );

      final ClientHttp client = ClientHttp(dio: dio);
      final HttpResult<Map<String, dynamic>> result = await client
          .send<Map<String, dynamic>>(const HttpRequest(path: '/episode'));

      expect(result, isA<HttpSuccess<Map<String, dynamic>>>());

      final HttpSuccess<Map<String, dynamic>> success =
          result as HttpSuccess<Map<String, dynamic>>;

      expect(success.statusCode, 200);
      expect(success.data['results'], <String>['rick']);
    },
  );

  test(
    'Should preserve get contract and query parameters when request is executed',
    () async {
      late RequestOptions capturedOptions;

      final Dio dio = Dio()
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest:
                (RequestOptions options, RequestInterceptorHandler handler) {
                  capturedOptions = options;

                  handler.resolve(
                    Response<String>(
                      requestOptions: options,
                      statusCode: 200,
                      data: 'ok',
                    ),
                  );
                },
          ),
        );

      final ClientHttp client = ClientHttp(dio: dio);

      await client.send<String>(
        const HttpRequest(
          path: '/episode',
          queryParameters: <String, dynamic>{'page': 2, 'name': 'pilot'},
        ),
      );

      expect(capturedOptions.method, 'GET');
      expect(capturedOptions.path, '/episode');
      expect(capturedOptions.queryParameters, <String, dynamic>{
        'page': 2,
        'name': 'pilot',
      });
    },
  );

  test('Should return not found failure when response status is 404', () async {
    final Dio dio = Dio()
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest:
              (RequestOptions options, RequestInterceptorHandler handler) {
                handler.resolve(
                  Response<Map<String, dynamic>>(
                    requestOptions: options,
                    statusCode: 404,
                    data: const <String, dynamic>{'error': 'Episode not found'},
                  ),
                );
              },
        ),
      );

    final ClientHttp client = ClientHttp(dio: dio);
    final HttpResult<Map<String, dynamic>> result = await client
        .send<Map<String, dynamic>>(const HttpRequest(path: '/episode/999'));

    expect(result, isA<HttpFailureResult<Map<String, dynamic>>>());

    final HttpFailure failure =
        (result as HttpFailureResult<Map<String, dynamic>>).failure;

    expect(failure.type, HttpFailureType.notFound);
    expect(failure.statusCode, 404);
    expect(failure.message, 'Episode not found');
  });

  test(
    'Should return timeout failure when dio throws timeout exception',
    () async {
      final Dio dio = Dio()
        ..interceptors.add(
          InterceptorsWrapper(
            onRequest:
                (RequestOptions options, RequestInterceptorHandler handler) {
                  handler.reject(
                    DioException.connectionTimeout(
                      timeout: const Duration(seconds: 10),
                      requestOptions: options,
                    ),
                  );
                },
          ),
        );

      final ClientHttp client = ClientHttp(dio: dio);
      final HttpResult<String> result = await client.send<String>(
        const HttpRequest(path: '/episode'),
      );

      expect(result, isA<HttpFailureResult<String>>());

      final HttpFailure failure = (result as HttpFailureResult<String>).failure;

      expect(failure.type, HttpFailureType.timeout);
      expect(failure.message, 'The request timed out.');
    },
  );

  test('Should return cancelled failure when dio cancels request', () async {
    final Dio dio = Dio()
      ..interceptors.add(
        InterceptorsWrapper(
          onRequest:
              (RequestOptions options, RequestInterceptorHandler handler) {
                handler.reject(
                  DioException.requestCancelled(
                    requestOptions: options,
                    reason: 'cancelled',
                  ),
                );
              },
        ),
      );

    final ClientHttp client = ClientHttp(dio: dio);
    final HttpResult<String> result = await client.send<String>(
      const HttpRequest(path: '/episode'),
    );

    expect(result, isA<HttpFailureResult<String>>());

    final HttpFailure failure = (result as HttpFailureResult<String>).failure;

    expect(failure.type, HttpFailureType.cancelled);
    expect(failure.message, 'The request was cancelled.');
  });
}
