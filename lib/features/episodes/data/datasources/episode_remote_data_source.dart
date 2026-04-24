import 'package:rickandmorty/features/episodes/data/models/episode_api_page_model.dart';
import 'package:rickandmorty/features/episodes/domain/exceptions/episode_exception.dart';
import 'package:rickandmorty/shared/http/client_http.dart';
import 'package:rickandmorty/shared/http/http_request.dart';
import 'package:rickandmorty/shared/http/http_result.dart';

abstract interface class EpisodeRemoteDataSource {
  Future<EpisodeApiPageModel> fetchPage(int page);
}

class RickAndMortyEpisodeRemoteDataSource implements EpisodeRemoteDataSource {
  RickAndMortyEpisodeRemoteDataSource({required ClientHttp clientHttp})
    : _clientHttp = clientHttp;

  final ClientHttp _clientHttp;

  @override
  Future<EpisodeApiPageModel> fetchPage(int page) async {
    final HttpResult<Map<String, dynamic>> result = await _clientHttp
        .send<Map<String, dynamic>>(
          HttpRequest(
            path: '/api/episode',
            queryParameters: <String, dynamic>{'page': page},
          ),
          decoder: (dynamic data) =>
              Map<String, dynamic>.from(data as Map<dynamic, dynamic>),
        );

    return switch (result) {
      HttpSuccess<Map<String, dynamic>> success => EpisodeApiPageModel.fromMap(
        success.data,
      ),
      HttpFailureResult<Map<String, dynamic>> failure => throw EpisodeException(
        failure.failure.message,
      ),
    };
  }
}
