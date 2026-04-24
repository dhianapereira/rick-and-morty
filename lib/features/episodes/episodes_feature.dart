import 'package:get_it/get_it.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:rickandmorty/features/characters/characters_feature.dart';
import 'package:rickandmorty/features/characters/data/datasources/character_remote_data_source.dart';
import 'package:rickandmorty/features/episodes/data/datasources/episode_details_remote_data_source.dart';
import 'package:rickandmorty/features/episodes/data/datasources/episode_local_data_source.dart';
import 'package:rickandmorty/features/episodes/data/datasources/episode_remote_data_source.dart';
import 'package:rickandmorty/features/episodes/data/repositories/rick_and_morty_episode_details_repository.dart';
import 'package:rickandmorty/features/episodes/data/repositories/rick_and_morty_episode_repository.dart';
import 'package:rickandmorty/features/episodes/domain/repositories/episode_details_repository.dart';
import 'package:rickandmorty/features/episodes/domain/repositories/episode_repository.dart';
import 'package:rickandmorty/features/episodes/presentation/controllers/episode_details_controller.dart';
import 'package:rickandmorty/features/episodes/presentation/controllers/episode_list_controller.dart';
import 'package:rickandmorty/shared/http/client_http.dart';
import 'package:sembast/sembast_io.dart';

class EpisodesFeature {
  const EpisodesFeature._();

  static const String key = 'episodes';

  static Future<void> initialize() async {
    if (GetIt.I.isRegistered<EpisodeListController>()) {
      return;
    }

    if (!GetIt.I.isRegistered<CharacterRemoteDataSource>()) {
      await CharactersFeature.initialize();
    }

    final Database database = await _openDatabase();

    GetIt.I.registerSingleton<Database>(
      database,
      dispose: (Database value) => value.close(),
    );
    GetIt.I.registerLazySingleton<EpisodeLocalDataSource>(
      () => SembastEpisodeLocalDataSource(database: GetIt.I<Database>()),
    );
    GetIt.I.registerLazySingleton<EpisodeRemoteDataSource>(
      () => ApiEpisodeRemoteDataSource(clientHttp: GetIt.I<ClientHttp>()),
    );
    GetIt.I.registerLazySingleton<EpisodeDetailsRemoteDataSource>(
      () =>
          ApiEpisodeDetailsRemoteDataSource(clientHttp: GetIt.I<ClientHttp>()),
    );
    GetIt.I.registerLazySingleton<EpisodeRepository>(
      () => EpisodeRepositoryImpl(
        localDataSource: GetIt.I<EpisodeLocalDataSource>(),
        remoteDataSource: GetIt.I<EpisodeRemoteDataSource>(),
      ),
    );
    GetIt.I.registerLazySingleton<EpisodeDetailsRepository>(
      () => EpisodeDetailsRepositoryImpl(
        remoteDataSource: GetIt.I<EpisodeDetailsRemoteDataSource>(),
        characterRemoteDataSource: GetIt.I<CharacterRemoteDataSource>(),
      ),
    );
    GetIt.I.registerFactory<EpisodeListController>(
      () => EpisodeListController(repository: GetIt.I<EpisodeRepository>()),
    );
    GetIt.I.registerFactoryParam<EpisodeDetailsController, int, void>(
      (int episodeId, _) => EpisodeDetailsController(
        repository: GetIt.I<EpisodeDetailsRepository>(),
        episodeId: episodeId,
      ),
    );
  }

  static Future<Database> _openDatabase() async {
    final String directory = (await getApplicationDocumentsDirectory()).path;
    final String databasePath = path.join(directory, 'rick_and_morty.db');

    return databaseFactoryIo.openDatabase(databasePath);
  }
}
