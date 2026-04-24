import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rickandmorty/features/episodes/data/datasources/episode_details_remote_data_source.dart';
import 'package:rickandmorty/features/episodes/domain/exceptions/episode_exception.dart';
import 'package:rickandmorty/shared/http/client_http.dart';
import 'package:rickandmorty/shared/http/http_failure.dart';
import 'package:rickandmorty/shared/http/http_request.dart';
import 'package:rickandmorty/shared/http/http_result.dart';

class _MockClientHttp extends Mock implements ClientHttp {}

void main() {
  late ClientHttp clientHttp;
  late EpisodeDetailsRemoteDataSource sut;

  setUp(() {
    registerFallbackValue(const HttpRequest(path: '/api/episode/1'));
    clientHttp = _MockClientHttp();
    sut = ApiEpisodeDetailsRemoteDataSource(clientHttp: clientHttp);
  });

  test(
    'Should return episode details model when episode request succeeds',
    () async {
      when(
        () => clientHttp.send<Map<String, dynamic>>(
          any(),
          decoder: any(named: 'decoder'),
        ),
      ).thenAnswer(
        (_) async => HttpSuccess<Map<String, dynamic>>(
          data: <String, dynamic>{
            'id': 28,
            'name': 'The Ricklantis Mixup',
            'air_date': 'September 10, 2017',
            'episode': 'S03E07',
            'created': '2017-11-10T12:56:36.618Z',
            'characters': <String>[
              'https://rickandmortyapi.com/api/character/1',
            ],
          },
          statusCode: 200,
        ),
      );

      final result = await sut.fetchEpisode(28);

      expect(result.id, 28);
      expect(result.code, 'S03E07');
      expect(result.characterUrls.length, 1);
    },
  );

  test('Should throw episode exception when episode request fails', () async {
    when(
      () => clientHttp.send<Map<String, dynamic>>(
        any(),
        decoder: any(named: 'decoder'),
      ),
    ).thenAnswer(
      (_) async => HttpFailureResult<Map<String, dynamic>>(
        failure: const HttpFailure(
          type: HttpFailureType.notFound,
          message: 'Episode not found.',
        ),
      ),
    );

    expect(() => sut.fetchEpisode(999), throwsA(isA<EpisodeException>()));
  });
}
