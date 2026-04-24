import 'package:rickandmorty/features/characters/domain/entities/character_details.dart';

class CharacterDetailsState {
  const CharacterDetailsState({
    this.isLoading = false,
    this.details,
    this.errorMessage,
  });

  final bool isLoading;
  final CharacterDetails? details;
  final String? errorMessage;

  bool get hasContent => details != null;
  bool get hasError => errorMessage != null;

  CharacterDetailsState copyWith({
    bool? isLoading,
    Object? details = _noValue,
    Object? errorMessage = _noValue,
  }) {
    return CharacterDetailsState(
      isLoading: isLoading ?? this.isLoading,
      details: details == _noValue
          ? this.details
          : details as CharacterDetails?,
      errorMessage: errorMessage == _noValue
          ? this.errorMessage
          : errorMessage as String?,
    );
  }

  static const Object _noValue = Object();
}
