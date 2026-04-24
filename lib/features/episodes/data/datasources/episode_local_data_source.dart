import 'package:rickandmorty/features/episodes/data/models/episode_page_cache_model.dart';
import 'package:rickandmorty/features/episodes/domain/entities/episode_page.dart';
import 'package:sembast/sembast.dart';

abstract interface class EpisodeLocalDataSource {
  Future<EpisodePage?> fetchPage(int page);
  Future<List<EpisodePage>> fetchAllPages();
  Future<void> savePage(EpisodePage episodePage);
}

class SembastEpisodeLocalDataSource implements EpisodeLocalDataSource {
  SembastEpisodeLocalDataSource({required Database database})
    : _database = database;

  final Database _database;
  final StoreRef<int, Map<String, Object?>> _store = intMapStoreFactory.store(
    'episode_pages',
  );

  @override
  Future<EpisodePage?> fetchPage(int page) async {
    final Map<String, Object?>? cachedPage = await _store
        .record(page)
        .get(_database);

    if (cachedPage == null) {
      return null;
    }

    return EpisodePageCacheModel.fromMap(cachedPage).toEntity();
  }

  @override
  Future<List<EpisodePage>> fetchAllPages() async {
    final List<RecordSnapshot<int, Map<String, Object?>>> records = await _store
        .find(_database);

    return records
        .map(
          (RecordSnapshot<int, Map<String, Object?>> record) =>
              EpisodePageCacheModel.fromMap(record.value).toEntity(),
        )
        .toList(growable: false);
  }

  @override
  Future<void> savePage(EpisodePage episodePage) async {
    final EpisodePageCacheModel cacheModel = EpisodePageCacheModel.fromEntity(
      episodePage,
    );

    await _store
        .record(episodePage.currentPage)
        .put(_database, cacheModel.toMap());
  }
}
