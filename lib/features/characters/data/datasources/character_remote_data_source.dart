import 'package:rickandmorty/features/characters/data/models/character_api_model.dart';
import 'package:rickandmorty/shared/http/client_http.dart';
import 'package:rickandmorty/shared/http/http_request.dart';
import 'package:rickandmorty/shared/http/http_result.dart';

abstract interface class CharacterRemoteDataSource {
  Future<List<CharacterApiModel>> fetchByIds(List<int> characterIds);
}

class ApiCharacterRemoteDataSource implements CharacterRemoteDataSource {
  ApiCharacterRemoteDataSource({required ClientHttp clientHttp})
    : _clientHttp = clientHttp;

  final ClientHttp _clientHttp;

  @override
  Future<List<CharacterApiModel>> fetchByIds(List<int> characterIds) async {
    if (characterIds.isEmpty) {
      return const <CharacterApiModel>[];
    }

    final String idsPath = characterIds.join(',');
    final HttpResult<List<CharacterApiModel>> result = await _clientHttp
        .send<List<CharacterApiModel>>(
          HttpRequest(path: '/api/character/$idsPath'),
          decoder: _decodeCharacters,
        );

    return switch (result) {
      HttpSuccess<List<CharacterApiModel>> success => success.data,
      HttpFailureResult<List<CharacterApiModel>> failure => throw Exception(
        failure.failure.message,
      ),
    };
  }

  List<CharacterApiModel> _decodeCharacters(dynamic data) {
    if (data is List<dynamic>) {
      return data
          .map(
            (dynamic item) => CharacterApiModel.fromMap(
              Map<String, dynamic>.from(item as Map<dynamic, dynamic>),
            ),
          )
          .toList(growable: false);
    }

    return <CharacterApiModel>[
      CharacterApiModel.fromMap(
        Map<String, dynamic>.from(data as Map<dynamic, dynamic>),
      ),
    ];
  }
}
