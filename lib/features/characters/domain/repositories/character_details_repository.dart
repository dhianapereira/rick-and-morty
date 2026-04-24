import 'package:rickandmorty/features/characters/domain/entities/character_details.dart';

abstract interface class CharacterDetailsRepository {
  Future<CharacterDetails> fetchDetails(int characterId);
}
