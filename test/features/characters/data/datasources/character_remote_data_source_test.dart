import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rickandmorty/features/characters/data/datasources/character_remote_data_source.dart';
import 'package:rickandmorty/features/characters/data/models/character_api_model.dart';
import 'package:rickandmorty/shared/http/client_http.dart';
import 'package:rickandmorty/shared/http/http_failure.dart';
import 'package:rickandmorty/shared/http/http_request.dart';
import 'package:rickandmorty/shared/http/http_result.dart';

class _MockClientHttp extends Mock implements ClientHttp {}

void main() {
  late ClientHttp clientHttp;
  late CharacterRemoteDataSource sut;

  setUp(() {
    registerFallbackValue(const HttpRequest(path: '/api/character/1'));
    clientHttp = _MockClientHttp();
    sut = ApiCharacterRemoteDataSource(clientHttp: clientHttp);
  });

  test(
    'Should return character model when single character request succeeds',
    () async {
      when(
        () => clientHttp.send<Map<String, dynamic>>(
          any(),
          decoder: any(named: 'decoder'),
        ),
      ).thenAnswer(
        (_) async => HttpSuccess<Map<String, dynamic>>(
          data: <String, dynamic>{
            'id': 1,
            'name': 'Rick Sanchez',
            'status': 'Alive',
            'species': 'Human',
            'type': '',
            'gender': 'Male',
            'origin': <String, dynamic>{
              'name': 'Earth (C-137)',
              'url': 'https://rickandmortyapi.com/api/location/1',
            },
            'location': <String, dynamic>{
              'name': 'Citadel of Ricks',
              'url': 'https://rickandmortyapi.com/api/location/3',
            },
            'image': 'https://rickandmortyapi.com/api/character/avatar/1.jpeg',
            'episode': <String>['https://rickandmortyapi.com/api/episode/1'],
            'url': 'https://rickandmortyapi.com/api/character/1',
            'created': '2017-11-04T18:48:46.250Z',
          },
          statusCode: 200,
        ),
      );

      final result = await sut.fetchById(1);

      expect(result.id, 1);
      expect(result.name, 'Rick Sanchez');
      expect(result.episodeUrls.length, 1);
    },
  );

  test(
    'Should return character models when character batch request succeeds',
    () async {
      when(
        () => clientHttp.send<List<CharacterApiModel>>(
          any(),
          decoder: any(named: 'decoder'),
        ),
      ).thenAnswer(
        (_) async => HttpSuccess<List<CharacterApiModel>>(
          data: const <CharacterApiModel>[],
          statusCode: 200,
        ),
      );

      final result = await sut.fetchByIds(const <int>[1, 2, 3]);

      expect(result, isEmpty);
      verify(
        () => clientHttp.send<List<CharacterApiModel>>(
          any(
            that: isA<HttpRequest>().having(
              (HttpRequest request) => request.path,
              'path',
              '/api/character/1,2,3',
            ),
          ),
          decoder: any(named: 'decoder'),
        ),
      ).called(1);
    },
  );

  test('Should throw exception when character request fails', () async {
    when(
      () => clientHttp.send<List<CharacterApiModel>>(
        any(),
        decoder: any(named: 'decoder'),
      ),
    ).thenAnswer(
      (_) async => HttpFailureResult<List<CharacterApiModel>>(
        failure: const HttpFailure(
          type: HttpFailureType.notFound,
          message: 'Characters not found.',
        ),
      ),
    );

    expect(() => sut.fetchByIds(const <int>[1, 2]), throwsException);
  });
}
