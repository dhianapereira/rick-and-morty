import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:rickandmorty/application/config/app_environment.dart';
import 'package:rickandmorty/features/episodes/data/datasources/episode_local_data_source.dart';
import 'package:rickandmorty/features/episodes/data/datasources/episode_remote_data_source.dart';
import 'package:rickandmorty/features/episodes/data/repositories/rick_and_morty_episode_repository.dart';
import 'package:rickandmorty/features/episodes/domain/repositories/episode_repository.dart';
import 'package:rickandmorty/features/episodes/presentation/controllers/episode_list_controller.dart';
import 'package:rickandmorty/shared/http/client_http.dart';
import 'package:sembast/sembast_io.dart';

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

    GetIt.I.registerSingleton<Database>(database);
    GetIt.I.registerLazySingleton<ClientHttp>(
      () =>
          ClientHttp(options: BaseOptions(baseUrl: AppEnvironment.apiBaseUrl)),
    );
    GetIt.I.registerLazySingleton<EpisodeLocalDataSource>(
      () => SembastEpisodeLocalDataSource(database: GetIt.I<Database>()),
    );
    GetIt.I.registerLazySingleton<EpisodeRemoteDataSource>(
      () => RickAndMortyEpisodeRemoteDataSource(
        clientHttp: GetIt.I<ClientHttp>(),
      ),
    );
    GetIt.I.registerLazySingleton<EpisodeRepository>(
      () => RickAndMortyEpisodeRepository(
        localDataSource: GetIt.I<EpisodeLocalDataSource>(),
        remoteDataSource: GetIt.I<EpisodeRemoteDataSource>(),
      ),
    );
    GetIt.I.registerFactory<EpisodeListController>(
      () => EpisodeListController(repository: GetIt.I<EpisodeRepository>()),
    );
  }

  static Future<Database> _openDatabase() async {
    final String directory = (await getApplicationDocumentsDirectory()).path;
    final String databasePath = path.join(directory, 'rick_and_morty.db');

    return databaseFactoryIo.openDatabase(databasePath);
  }
}
