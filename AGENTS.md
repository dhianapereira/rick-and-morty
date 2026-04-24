# Project instructions

## Stack

- Flutter stable
- Dart
- `go_router` for navigation
- `GetIt` for dependency injection
- `ValueNotifier` for state management
- `Dio` for HTTP
- `sembast` for local NoSQL cache
- `shared_preferences` for persisted UI preferences
- `mocktail` for mocks
- `alchemist` for golden tests
- `very_good` CLI for randomized test execution

## Commands

- Install dependencies: `flutter pub get`
- Analyze: `flutter analyze`
- Format: `dart format .`
- Run tests: `very_good test --test-randomize-ordering-seed random`
- Update goldens locally: `very_good test --update-goldens`

## Architecture

- Follow the existing feature-first structure.
- Keep shared UI tokens and cross-feature utilities inside `lib/shared`.
- Keep feature code inside `lib/features/<feature_name>`.
- Use the current split: `domain`, `data`, and `presentation`.
- Keep API models and local persistence models separate when they represent different data sources.
- Do not create unnecessary abstractions or generic layers before they are justified by repetition.

## Dependency injection

- Use `GetIt` for dependency registration and resolution.
- Pages should resolve their controllers from `GetIt` instead of receiving controllers by constructor only for tests.
- In widget tests for pages, register mocks in `GetIt` during `setUp` and reset `GetIt` in `tearDown`.

## State management

- Keep state management consistent with the current codebase and use `ValueNotifier`.
- Avoid adding Provider, Riverpod, Bloc, Cubit, or other state libraries unless explicitly requested.
- Keep controllers focused on orchestration and state transitions.
- Do not place business logic inside widgets.

## Naming

- Write all code in English.
- Prefer clear, feature-oriented names.
- Do not prefix repository or datasource names with `RickAndMorty`.
- Prefer private constructors instead of `abstract final class`.

## Imports

- Prefer package imports in `lib` and `test`.
- Do not use relative imports unless there is a very specific local test utility reason already established in the project.

## UI and performance

- Prefer small widgets over large build methods.
- Use `const` constructors and `const` widgets whenever possible.
- Use builder-based lists and grids such as `ListView.builder` and `SliverChildBuilderDelegate` for dynamic collections.
- Resolve controllers once in the widget lifecycle when appropriate and avoid repeated lookups during build.
- Avoid unnecessary rebuilds, repaints, and object recreation inside build methods.
- Reuse theme tokens from `shared/theme`.
- Keep strings out of widgets and use `l10n`.
- Access localizations with `context.l10n`.

## Localization

- The project is configured for device locale resolution, but currently supports only `en`.
- Do not hardcode user-facing strings in widgets.
- Add new strings to the `.arb` files and use generated localizations.

## Testing

- Add or update tests whenever behavior changes.
- Use `mocktail` instead of fake repositories or fake controllers unless a real fake is clearly the better tool.
- Do not use `setUpAll`.
- Test names must follow `Should ... When ...`.
- Do not add AAA comments.
- Add unit tests for data and controller behavior.
- Add widget tests for user actions such as taps, retries, and navigation.
- Prefer testing page widgets through `GetIt` registration instead of passing test-only dependencies via constructors.

## Golden tests

- Use `alchemist` for page UI goldens.
- Focus golden tests on page-level UI states.
- Keep the `skip_very_good_optimization` tag exactly in the format expected by Very Good CLI when needed.
- Keep golden configuration centralized in `test/flutter_test_config.dart`.
- The repository keeps CI goldens as the source of truth.

## Data and cache

- Remote access should go through the shared HTTP client.
- Local cache should follow the current feature-level strategy instead of generic HTTP cache abstractions.
- Keep cache orchestration in repositories.
- Keep data-source responsibilities separated by feature. For example, character fetching belongs to the `characters` feature even if another feature consumes it.

## Packages

- Do not introduce new packages without a clear reason.
- If a new package is needed, prefer actively maintained libraries and keep the justification concise.
