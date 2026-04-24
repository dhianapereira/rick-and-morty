import 'package:rickandmorty/features/characters/domain/entities/character.dart';

class CharacterApiModel {
  const CharacterApiModel({
    required this.id,
    required this.name,
    required this.status,
    required this.species,
    required this.imageUrl,
  });

  factory CharacterApiModel.fromMap(Map<String, dynamic> map) {
    return CharacterApiModel(
      id: map['id'] as int,
      name: map['name'] as String,
      status: map['status'] as String,
      species: map['species'] as String,
      imageUrl: map['image'] as String,
    );
  }

  final int id;
  final String name;
  final String status;
  final String species;
  final String imageUrl;

  Character toEntity() {
    return Character(
      id: id,
      name: name,
      status: status,
      species: species,
      imageUrl: imageUrl,
    );
  }
}
