import 'package:rickandmorty/features/episodes/domain/entities/episode_details.dart';

class EpisodeDetailsState {
  const EpisodeDetailsState({
    this.isLoading = false,
    this.details,
    this.errorMessage,
  });

  final bool isLoading;
  final EpisodeDetails? details;
  final String? errorMessage;

  bool get hasContent => details != null;
  bool get hasError => errorMessage != null;

  EpisodeDetailsState copyWith({
    bool? isLoading,
    Object? details = _noValue,
    Object? errorMessage = _noValue,
  }) {
    return EpisodeDetailsState(
      isLoading: isLoading ?? this.isLoading,
      details: details == _noValue ? this.details : details as EpisodeDetails?,
      errorMessage: errorMessage == _noValue
          ? this.errorMessage
          : errorMessage as String?,
    );
  }

  static const Object _noValue = Object();
}
