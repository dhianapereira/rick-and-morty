import 'package:rickandmorty/features/characters/data/datasources/character_remote_data_source.dart';
import 'package:rickandmorty/features/characters/domain/entities/character_details.dart';
import 'package:rickandmorty/features/characters/domain/repositories/character_details_repository.dart';

class CharacterDetailsRepositoryImpl implements CharacterDetailsRepository {
  CharacterDetailsRepositoryImpl({
    required CharacterRemoteDataSource remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final CharacterRemoteDataSource _remoteDataSource;

  @override
  Future<CharacterDetails> fetchDetails(int characterId) async {
    final character = await _remoteDataSource.fetchById(characterId);
    return character.toDetailsEntity();
  }
}
