typedef FeatureInitializer = Future<void> Function();

class FeatureRegistry {
  FeatureRegistry._();

  static final FeatureRegistry instance = FeatureRegistry._();

  final Map<String, _FeatureRegistration> _registrations =
      <String, _FeatureRegistration>{};
  final Map<String, Future<void>> _inFlightInitializations =
      <String, Future<void>>{};
  final Set<String> _initializedFeatures = <String>{};

  void register({
    required String featureKey,
    required FeatureInitializer initializer,
    List<String> dependencies = const <String>[],
  }) {
    if (_registrations.containsKey(featureKey)) {
      return;
    }

    _registrations[featureKey] = _FeatureRegistration(
      initializer: initializer,
      dependencies: dependencies,
    );
  }

  void reset() {
    _registrations.clear();
    _inFlightInitializations.clear();
    _initializedFeatures.clear();
  }

  Future<void> initialize(String featureKey) {
    if (_initializedFeatures.contains(featureKey)) {
      return Future<void>.value();
    }

    final Future<void>? inFlight = _inFlightInitializations[featureKey];
    if (inFlight != null) {
      return inFlight;
    }

    final _FeatureRegistration? registration = _registrations[featureKey];
    if (registration == null) {
      return Future<void>.value();
    }

    final Future<void> initialization = _initializeFeature(
      featureKey,
      registration,
    );
    _inFlightInitializations[featureKey] = initialization;

    return initialization.whenComplete(() {
      _inFlightInitializations.remove(featureKey);
    });
  }

  Future<void> _initializeFeature(
    String featureKey,
    _FeatureRegistration registration,
  ) async {
    for (final String dependency in registration.dependencies) {
      await initialize(dependency);
    }

    await registration.initializer();
    _initializedFeatures.add(featureKey);
  }
}

class _FeatureRegistration {
  const _FeatureRegistration({
    required this.initializer,
    required this.dependencies,
  });

  final FeatureInitializer initializer;
  final List<String> dependencies;
}
