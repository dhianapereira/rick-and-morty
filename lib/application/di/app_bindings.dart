import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:rickandmorty/application/config/app_environment.dart';
import 'package:rickandmorty/features/episodes/data/datasources/episode_remote_data_source.dart';
import 'package:rickandmorty/features/episodes/data/repositories/rick_and_morty_episode_repository.dart';
import 'package:rickandmorty/features/episodes/domain/repositories/episode_repository.dart';
import 'package:rickandmorty/features/episodes/presentation/controllers/episode_list_controller.dart';
import 'package:rickandmorty/shared/http/client_http.dart';

class AppBindings {
  const AppBindings._();

  static void setup() {
    if (GetIt.I.isRegistered<ClientHttp>()) {
      return;
    }

    if (AppEnvironment.apiBaseUrl.isEmpty) {
      throw StateError(
        'RICK_AND_MORTY_API_BASE_URL is not configured. '
        'Run the app with --dart-define-from-file=env/development.json.',
      );
    }

    GetIt.I.registerLazySingleton<ClientHttp>(
      () =>
          ClientHttp(options: BaseOptions(baseUrl: AppEnvironment.apiBaseUrl)),
    );
    GetIt.I.registerLazySingleton<EpisodeRemoteDataSource>(
      () => RickAndMortyEpisodeRemoteDataSource(
        clientHttp: GetIt.I<ClientHttp>(),
      ),
    );
    GetIt.I.registerLazySingleton<EpisodeRepository>(
      () => RickAndMortyEpisodeRepository(
        remoteDataSource: GetIt.I<EpisodeRemoteDataSource>(),
      ),
    );
    GetIt.I.registerFactory<EpisodeListController>(
      () => EpisodeListController(repository: GetIt.I<EpisodeRepository>()),
    );
  }
}
