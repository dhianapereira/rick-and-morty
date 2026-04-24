import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rickandmorty/features/characters/domain/entities/character_details.dart';
import 'package:rickandmorty/features/characters/domain/entities/character_place.dart';
import 'package:rickandmorty/features/characters/domain/exceptions/character_exception.dart';
import 'package:rickandmorty/features/characters/domain/repositories/character_details_repository.dart';
import 'package:rickandmorty/features/characters/presentation/controllers/character_details_controller.dart';

class _MockCharacterDetailsRepository extends Mock
    implements CharacterDetailsRepository {}

void main() {
  late CharacterDetailsRepository repository;
  late CharacterDetailsController sut;

  setUp(() {
    repository = _MockCharacterDetailsRepository();
    sut = CharacterDetailsController(repository: repository, characterId: 1);
  });

  test('Should expose character details when loading succeeds', () async {
    when(() => repository.fetchDetails(1)).thenAnswer((_) async => _details());

    await sut.load();

    expect(sut.value.details?.id, 1);
    expect(sut.value.details?.name, 'Rick Sanchez');
    expect(sut.value.isLoading, isFalse);
  });

  test(
    'Should expose error message when repository throws exception',
    () async {
      when(
        () => repository.fetchDetails(1),
      ).thenThrow(const CharacterException('Unable to load character.'));

      await sut.load();

      expect(sut.value.hasError, isTrue);
      expect(sut.value.errorMessage, 'Unable to load character.');
    },
  );
}

CharacterDetails _details() {
  return CharacterDetails(
    id: 1,
    name: 'Rick Sanchez',
    status: 'Alive',
    species: 'Human',
    type: '',
    gender: 'Male',
    origin: const CharacterPlace(
      name: 'Earth (C-137)',
      url: 'https://rickandmortyapi.com/api/location/1',
    ),
    location: const CharacterPlace(
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
  );
}
