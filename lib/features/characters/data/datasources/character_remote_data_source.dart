import 'package:rickandmorty/features/characters/data/models/character_api_model.dart';
import 'package:rickandmorty/features/characters/domain/exceptions/character_exception.dart';
import 'package:rickandmorty/shared/http/client_http.dart';
import 'package:rickandmorty/shared/http/http_request.dart';
import 'package:rickandmorty/shared/http/http_result.dart';

abstract interface class CharacterRemoteDataSource {
  Future<CharacterApiModel> fetchById(int characterId);
  Future<List<CharacterApiModel>> fetchByIds(List<int> characterIds);
}

class ApiCharacterRemoteDataSource implements CharacterRemoteDataSource {
  ApiCharacterRemoteDataSource({required ClientHttp clientHttp})
    : _clientHttp = clientHttp;

  final ClientHttp _clientHttp;

  @override
  Future<CharacterApiModel> fetchById(int characterId) async {
    final HttpResult<Map<String, dynamic>> result = await _clientHttp
        .send<Map<String, dynamic>>(
          HttpRequest(path: '/api/character/$characterId'),
          decoder: (dynamic data) =>
              Map<String, dynamic>.from(data as Map<dynamic, dynamic>),
        );

    return switch (result) {
      HttpSuccess<Map<String, dynamic>> success => CharacterApiModel.fromMap(
        success.data,
      ),
      HttpFailureResult<Map<String, dynamic>> failure =>
        throw CharacterException(failure.failure.message),
    };
  }

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
      HttpFailureResult<List<CharacterApiModel>> failure =>
        throw CharacterException(failure.failure.message),
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
