import 'package:rickandmorty/features/episodes/domain/entities/episode.dart';

class EpisodeApiPageModel {
  const EpisodeApiPageModel({
    required this.totalEpisodes,
    required this.totalApiPages,
    required this.episodes,
  });

  factory EpisodeApiPageModel.fromMap(Map<String, dynamic> map) {
    final Map<String, dynamic> info = Map<String, dynamic>.from(
      map['info'] as Map<dynamic, dynamic>,
    );
    final List<dynamic> results = map['results'] as List<dynamic>;

    return EpisodeApiPageModel(
      totalEpisodes: info['count'] as int,
      totalApiPages: info['pages'] as int,
      episodes: results
          .map(
            (dynamic item) => EpisodeApiItemModel.fromMap(
              Map<String, dynamic>.from(item as Map<dynamic, dynamic>),
            ).toEntity(),
          )
          .toList(growable: false),
    );
  }

  final int totalEpisodes;
  final int totalApiPages;
  final List<Episode> episodes;
}

class EpisodeApiItemModel {
  const EpisodeApiItemModel({
    required this.id,
    required this.name,
    required this.code,
    required this.airDate,
  });

  factory EpisodeApiItemModel.fromMap(Map<String, dynamic> map) {
    return EpisodeApiItemModel(
      id: map['id'] as int,
      name: map['name'] as String,
      code: map['episode'] as String,
      airDate: map['air_date'] as String,
    );
  }

  final int id;
  final String name;
  final String code;
  final String airDate;

  Episode toEntity() {
    return Episode(id: id, name: name, code: code, airDate: airDate);
  }
}
