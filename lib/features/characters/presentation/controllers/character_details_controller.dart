import 'package:flutter/foundation.dart';
import 'package:rickandmorty/features/characters/domain/entities/character_details.dart';
import 'package:rickandmorty/features/characters/domain/exceptions/character_exception.dart';
import 'package:rickandmorty/features/characters/domain/repositories/character_details_repository.dart';
import 'package:rickandmorty/features/characters/presentation/controllers/character_details_state.dart';

class CharacterDetailsController extends ValueNotifier<CharacterDetailsState> {
  CharacterDetailsController({
    required CharacterDetailsRepository repository,
    required int characterId,
  }) : _repository = repository,
       _characterId = characterId,
       super(const CharacterDetailsState());

  final CharacterDetailsRepository _repository;
  final int _characterId;

  Future<void> load() async {
    if (value.isLoading) {
      return;
    }

    if (value.details?.id == _characterId) {
      return;
    }

    value = value.copyWith(isLoading: true, errorMessage: null);

    try {
      final CharacterDetails details = await _repository.fetchDetails(
        _characterId,
      );
      value = value.copyWith(
        isLoading: false,
        details: details,
        errorMessage: null,
      );
    } on CharacterException catch (exception) {
      value = value.copyWith(isLoading: false, errorMessage: exception.message);
    } catch (_) {
      value = value.copyWith(
        isLoading: false,
        errorMessage: 'Failed to load character details.',
      );
    }
  }

  Future<void> retry() {
    return load();
  }
}
