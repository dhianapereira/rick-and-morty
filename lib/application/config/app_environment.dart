class AppEnvironment {
  const AppEnvironment._();

  static const String apiBaseUrl = String.fromEnvironment(
    'RICK_AND_MORTY_API_BASE_URL',
  );
}
