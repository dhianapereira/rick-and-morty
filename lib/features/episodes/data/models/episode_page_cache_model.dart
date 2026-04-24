import 'package:rickandmorty/features/episodes/domain/entities/episode.dart';
import 'package:rickandmorty/features/episodes/domain/entities/episode_page.dart';

class EpisodePageCacheModel {
  const EpisodePageCacheModel({
    required this.page,
    required this.totalPages,
    required this.totalEpisodes,
    required this.episodes,
  });

  factory EpisodePageCacheModel.fromEntity(EpisodePage episodePage) {
    return EpisodePageCacheModel(
      page: episodePage.currentPage,
      totalPages: episodePage.totalPages,
      totalEpisodes: episodePage.totalEpisodes,
      episodes: episodePage.episodes
          .map(CachedEpisodeModel.fromEntity)
          .toList(growable: false),
    );
  }

  factory EpisodePageCacheModel.fromMap(Map<String, Object?> map) {
    final List<Object?> rawEpisodes = map['episodes'] as List<Object?>;

    return EpisodePageCacheModel(
      page: map['page'] as int,
      totalPages: map['totalPages'] as int,
      totalEpisodes: map['totalEpisodes'] as int,
      episodes: rawEpisodes
          .map(
            (Object? item) => CachedEpisodeModel.fromMap(
              Map<String, Object?>.from(item! as Map),
            ),
          )
          .toList(growable: false),
    );
  }

  final int page;
  final int totalPages;
  final int totalEpisodes;
  final List<CachedEpisodeModel> episodes;

  Map<String, Object?> toMap() {
    return <String, Object?>{
      'page': page,
      'totalPages': totalPages,
      'totalEpisodes': totalEpisodes,
      'episodes': episodes
          .map((CachedEpisodeModel item) => item.toMap())
          .toList(growable: false),
    };
  }

  EpisodePage toEntity() {
    return EpisodePage(
      episodes: episodes
          .map((CachedEpisodeModel item) => item.toEntity())
          .toList(growable: false),
      currentPage: page,
      totalPages: totalPages,
      totalEpisodes: totalEpisodes,
    );
  }
}

class CachedEpisodeModel {
  const CachedEpisodeModel({
    required this.id,
    required this.name,
    required this.code,
    required this.airDate,
  });

  factory CachedEpisodeModel.fromEntity(Episode episode) {
    return CachedEpisodeModel(
      id: episode.id,
      name: episode.name,
      code: episode.code,
      airDate: episode.airDate,
    );
  }

  factory CachedEpisodeModel.fromMap(Map<String, Object?> map) {
    return CachedEpisodeModel(
      id: map['id'] as int,
      name: map['name'] as String,
      code: map['code'] as String,
      airDate: map['airDate'] as String,
    );
  }

  final int id;
  final String name;
  final String code;
  final String airDate;

  Map<String, Object?> toMap() {
    return <String, Object?>{
      'id': id,
      'name': name,
      'code': code,
      'airDate': airDate,
    };
  }

  Episode toEntity() {
    return Episode(id: id, name: name, code: code, airDate: airDate);
  }
}
