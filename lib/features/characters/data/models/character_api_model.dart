import 'package:rickandmorty/features/characters/domain/entities/character.dart';
import 'package:rickandmorty/features/characters/domain/entities/character_details.dart';
import 'package:rickandmorty/features/characters/data/models/character_place_api_model.dart';

class CharacterApiModel {
  const CharacterApiModel({
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

  factory CharacterApiModel.fromMap(Map<String, dynamic> map) {
    return CharacterApiModel(
      id: map['id'] as int,
      name: map['name'] as String,
      status: map['status'] as String,
      species: map['species'] as String,
      type: map['type'] as String,
      gender: map['gender'] as String,
      origin: CharacterPlaceApiModel.fromMap(
        Map<String, dynamic>.from(map['origin'] as Map<dynamic, dynamic>),
      ),
      location: CharacterPlaceApiModel.fromMap(
        Map<String, dynamic>.from(map['location'] as Map<dynamic, dynamic>),
      ),
      imageUrl: map['image'] as String,
      episodeUrls: List<String>.from(map['episode'] as List<dynamic>),
      url: map['url'] as String,
      createdAt: DateTime.parse(map['created'] as String),
    );
  }

  final int id;
  final String name;
  final String status;
  final String species;
  final String type;
  final String gender;
  final CharacterPlaceApiModel origin;
  final CharacterPlaceApiModel location;
  final String imageUrl;
  final List<String> episodeUrls;
  final String url;
  final DateTime createdAt;

  Character toEntity() {
    return Character(
      id: id,
      name: name,
      status: status,
      species: species,
      imageUrl: imageUrl,
    );
  }

  CharacterDetails toDetailsEntity() {
    return CharacterDetails(
      id: id,
      name: name,
      status: status,
      species: species,
      type: type,
      gender: gender,
      origin: origin.toEntity(),
      location: location.toEntity(),
      imageUrl: imageUrl,
      episodeUrls: episodeUrls,
      url: url,
      createdAt: createdAt,
    );
  }
}
