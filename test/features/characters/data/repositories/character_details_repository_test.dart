import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rickandmorty/features/characters/data/datasources/character_remote_data_source.dart';
import 'package:rickandmorty/features/characters/data/models/character_api_model.dart';
import 'package:rickandmorty/features/characters/data/models/character_place_api_model.dart';
import 'package:rickandmorty/features/characters/data/repositories/character_details_repository_impl.dart';

class _MockCharacterRemoteDataSource extends Mock
    implements CharacterRemoteDataSource {}

void main() {
  late CharacterRemoteDataSource remoteDataSource;
  late CharacterDetailsRepositoryImpl sut;

  setUp(() {
    remoteDataSource = _MockCharacterRemoteDataSource();
    sut = CharacterDetailsRepositoryImpl(remoteDataSource: remoteDataSource);
  });

  test('Should map character details when details are requested', () async {
    when(() => remoteDataSource.fetchById(1)).thenAnswer(
      (_) async => CharacterApiModel(
        id: 1,
        name: 'Rick Sanchez',
        status: 'Alive',
        species: 'Human',
        type: '',
        gender: 'Male',
        origin: const CharacterPlaceApiModel(
          name: 'Earth (C-137)',
          url: 'https://rickandmortyapi.com/api/location/1',
        ),
        location: const CharacterPlaceApiModel(
          name: 'Citadel of Ricks',
          url: 'https://rickandmortyapi.com/api/location/3',
        ),
        imageUrl: 'https://rickandmortyapi.com/api/character/avatar/1.jpeg',
        episodeUrls: const <String>[
          'https://rickandmortyapi.com/api/episode/1',
          'https://rickandmortyapi.com/api/episode/2',
        ],
        url: 'https://rickandmortyapi.com/api/character/1',
        createdAt: DateTime.utc(2017, 11, 4),
      ),
    );

    final result = await sut.fetchDetails(1);

    expect(result.id, 1);
    expect(result.name, 'Rick Sanchez');
    expect(result.gender, 'Male');
    expect(result.origin.name, 'Earth (C-137)');
    expect(result.location.name, 'Citadel of Ricks');
    expect(result.episodeCount, 2);
    verify(() => remoteDataSource.fetchById(1)).called(1);
  });
}
