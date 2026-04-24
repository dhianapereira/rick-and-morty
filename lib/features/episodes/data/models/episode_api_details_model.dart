class EpisodeApiDetailsModel {
  const EpisodeApiDetailsModel({
    required this.id,
    required this.name,
    required this.code,
    required this.airDate,
    required this.createdAt,
    required this.characterUrls,
  });

  factory EpisodeApiDetailsModel.fromMap(Map<String, dynamic> map) {
    return EpisodeApiDetailsModel(
      id: map['id'] as int,
      name: map['name'] as String,
      code: map['episode'] as String,
      airDate: map['air_date'] as String,
      createdAt: DateTime.parse(map['created'] as String),
      characterUrls: List<String>.from(map['characters'] as List<dynamic>),
    );
  }

  final int id;
  final String name;
  final String code;
  final String airDate;
  final DateTime createdAt;
  final List<String> characterUrls;
}
