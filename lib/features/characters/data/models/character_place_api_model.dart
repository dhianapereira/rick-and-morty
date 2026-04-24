import 'package:rickandmorty/features/characters/domain/entities/character_place.dart';

class CharacterPlaceApiModel {
  const CharacterPlaceApiModel({required this.name, required this.url});

  factory CharacterPlaceApiModel.fromMap(Map<String, dynamic> map) {
    return CharacterPlaceApiModel(
      name: map['name'] as String,
      url: map['url'] as String,
    );
  }

  final String name;
  final String url;

  CharacterPlace toEntity() {
    return CharacterPlace(name: name, url: url);
  }
}
