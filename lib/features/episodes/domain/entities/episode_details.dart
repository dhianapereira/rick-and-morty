import 'package:rickandmorty/features/characters/domain/entities/character.dart';

class EpisodeDetails {
  const EpisodeDetails({
    required this.id,
    required this.name,
    required this.code,
    required this.airDate,
    required this.createdAt,
    required this.characters,
  });

  final int id;
  final String name;
  final String code;
  final String airDate;
  final DateTime createdAt;
  final List<Character> characters;
}
