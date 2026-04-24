import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:rickandmorty/application/config/app_environment.dart';
import 'package:rickandmorty/application/theme/theme_controller.dart';
import 'package:rickandmorty/application/theme/theme_local_data_source.dart';
import 'package:rickandmorty/features/characters/data/datasources/character_remote_data_source.dart';
import 'package:rickandmorty/features/characters/data/repositories/character_details_repository_impl.dart';
import 'package:rickandmorty/features/characters/domain/repositories/character_details_repository.dart';
import 'package:rickandmorty/features/characters/presentation/controllers/character_details_controller.dart';
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
import 'package:shared_preferences/shared_preferences.dart';

class AppBindings {
  const AppBindings._();

  static Future<void> setup() async {
    if (GetIt.I.isRegistered<ClientHttp>()) {
      return;
    }

    if (AppEnvironment.apiBaseUrl.isEmpty) {
      throw StateError(
        'RICK_AND_MORTY_API_BASE_URL is not configured. '
        'Run the app with --dart-define-from-file=env/development.json.',
      );
    }

    final Database database = await _openDatabase();
    final SharedPreferencesAsync sharedPreferences = SharedPreferencesAsync();

    GetIt.I.registerSingleton<Database>(database);
    GetIt.I.registerSingleton<SharedPreferencesAsync>(sharedPreferences);
    GetIt.I.registerLazySingleton<ClientHttp>(
      () =>
          ClientHttp(options: BaseOptions(baseUrl: AppEnvironment.apiBaseUrl)),
    );
    GetIt.I.registerLazySingleton<ThemeLocalDataSource>(
      () => SharedPreferencesThemeLocalDataSource(
        preferences: GetIt.I<SharedPreferencesAsync>(),
      ),
    );
    GetIt.I.registerLazySingleton<EpisodeLocalDataSource>(
      () => SembastEpisodeLocalDataSource(database: GetIt.I<Database>()),
    );
    GetIt.I.registerLazySingleton<EpisodeRemoteDataSource>(
      () => RickAndMortyEpisodeRemoteDataSource(
        clientHttp: GetIt.I<ClientHttp>(),
      ),
    );
    GetIt.I.registerLazySingleton<EpisodeDetailsRemoteDataSource>(
      () =>
          ApiEpisodeDetailsRemoteDataSource(clientHttp: GetIt.I<ClientHttp>()),
    );
    GetIt.I.registerLazySingleton<CharacterRemoteDataSource>(
      () => ApiCharacterRemoteDataSource(clientHttp: GetIt.I<ClientHttp>()),
    );
    GetIt.I.registerLazySingleton<CharacterDetailsRepository>(
      () => CharacterDetailsRepositoryImpl(
        remoteDataSource: GetIt.I<CharacterRemoteDataSource>(),
      ),
    );
    GetIt.I.registerLazySingleton<EpisodeRepository>(
      () => RickAndMortyEpisodeRepository(
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
    GetIt.I.registerFactoryParam<CharacterDetailsController, int, void>(
      (int characterId, _) => CharacterDetailsController(
        repository: GetIt.I<CharacterDetailsRepository>(),
        characterId: characterId,
      ),
    );
    GetIt.I.registerSingleton<ThemeController>(
      ThemeController(localDataSource: GetIt.I<ThemeLocalDataSource>()),
    );
    await GetIt.I<ThemeController>().loadThemePreference();
  }

  static Future<Database> _openDatabase() async {
    final String directory = (await getApplicationDocumentsDirectory()).path;
    final String databasePath = path.join(directory, 'rick_and_morty.db');

    return databaseFactoryIo.openDatabase(databasePath);
  }
}
