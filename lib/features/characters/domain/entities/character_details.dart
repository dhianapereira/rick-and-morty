import 'package:rickandmorty/features/characters/domain/entities/character_place.dart';

class CharacterDetails {
  const CharacterDetails({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.type,
    required this.gender,
    required this.origin,
    required this.location,
    required this.imageUrl,
    required this.episodeUrls,
    required this.url,
    required this.createdAt,
  });

  final int id;
  final String name;
  final String status;
  final String species;
  final String type;
  final String gender;
  final CharacterPlace origin;
  final CharacterPlace location;
  final String imageUrl;
  final List<String> episodeUrls;
  final String url;
  final DateTime createdAt;

  int get episodeCount => episodeUrls.length;
}
