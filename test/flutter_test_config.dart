import 'dart:async';
import 'dart:io';

import 'package:alchemist/alchemist.dart';
import 'package:flutter_test/flutter_test.dart';

Future<void> testExecutable(FutureOr<void> Function() testMain) {
  TestWidgetsFlutterBinding.ensureInitialized();

  return AlchemistConfig.runWithConfig(
    config: AlchemistConfig(
      platformGoldensConfig: PlatformGoldensConfig(
        platforms: _platforms,
        diffThreshold: 0.003,
      ),
      ciGoldensConfig: CiGoldensConfig(diffThreshold: 0.001),
    ),
    run: () async {
      await testMain();
    },
  );
}

Set<HostPlatform> get _platforms {
  if (_isRunningOnGitHubActions) {
    return <HostPlatform>{};
  }

  return <HostPlatform>{HostPlatform.linux};
}

bool get _isRunningOnGitHubActions {
  return Platform.environment['GITHUB_ACTIONS'] == 'true';
}
