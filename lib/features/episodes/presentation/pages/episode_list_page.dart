import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:rickandmorty/application/router/app_router.dart';
import 'package:rickandmorty/features/episodes/domain/entities/episode.dart';
import 'package:rickandmorty/features/episodes/presentation/controllers/episode_list_controller.dart';
import 'package:rickandmorty/features/episodes/presentation/controllers/episode_list_state.dart';
import 'package:rickandmorty/shared/shared.dart';
import 'package:rickandmorty/l10n/l10n_extension.dart';

class EpisodeListPage extends StatefulWidget {
  const EpisodeListPage({super.key});

  @override
  State<EpisodeListPage> createState() => _EpisodeListPageState();
}

class _EpisodeListPageState extends State<EpisodeListPage> {
  final _controller = GetIt.I<EpisodeListController>();

  @override
  void initState() {
    super.initState();
    _controller.loadInitialPage();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<EpisodeListState>(
      valueListenable: _controller,
      builder: (_, state, _) {
        return Padding(
          padding: AppSpacing.pagePadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              _EpisodeListHeader(state: state),
              const SizedBox(height: AppSpacing.lg),
              Expanded(
                child: _EpisodeListContent(
                  state: state,
                  onRetry: _controller.retry,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              _EpisodePaginationControls(
                state: state,
                onPreviousPage: _controller.loadPreviousPage,
                onNextPage: _controller.loadNextPage,
              ),
            ],
          ),
        );
      },
    );
  }
}

class _EpisodeListHeader extends StatelessWidget {
  const _EpisodeListHeader({required this.state});

  final EpisodeListState state;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final l10n = context.l10n;
    final ColorScheme colorScheme = theme.colorScheme;
    final bool isDark = theme.brightness == Brightness.dark;

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            isDark
                ? AppColors.surfaceContainerHigh
                : colorScheme.surfaceContainer,
            isDark
                ? AppColors.episodeSearchBackground
                : colorScheme.surfaceContainerHighest,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(l10n.episodesTitle, style: theme.textTheme.headlineMedium),
            const SizedBox(height: AppSpacing.xs),
            Text(
              state.hasContent
                  ? l10n.episodesRangeDescription(
                      state.startEpisodeNumber,
                      state.endEpisodeNumber,
                      state.totalEpisodes,
                    )
                  : l10n.episodesInitialDescription,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            if (state.isLoading && state.hasContent) ...<Widget>[
              const SizedBox(height: AppSpacing.sm),
              const LinearProgressIndicator(
                minHeight: 3,
                borderRadius: BorderRadius.all(
                  Radius.circular(AppSpacing.radiusFull),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _EpisodeListContent extends StatelessWidget {
  const _EpisodeListContent({required this.state, required this.onRetry});

  final EpisodeListState state;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    if (state.isLoading && !state.hasContent) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.hasError && !state.hasContent) {
      return _EpisodeErrorState(message: state.errorMessage!, onRetry: onRetry);
    }

    return ListView.builder(
      key: const PageStorageKey<String>('episode-list'),
      itemCount: state.episodes.length,
      itemBuilder: (BuildContext context, int index) {
        final Episode episode = state.episodes[index];

        return Padding(
          padding: EdgeInsets.only(
            bottom: index == state.episodes.length - 1 ? 0 : AppSpacing.sm,
          ),
          child: _EpisodeListItem(episode: episode),
        );
      },
    );
  }
}

class _EpisodeListItem extends StatelessWidget {
  const _EpisodeListItem({required this.episode});

  final Episode episode;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        onTap: () => context.go(AppRouter.episodeDetailsLocation(episode.id)),
        child: Padding(
          padding: AppSpacing.cardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: AppSpacing.chipPadding,
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer,
                  borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                ),
                child: Text(
                  episode.code,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: AppColors.onPrimaryContainer,
                  ),
                ),
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(episode.name, style: theme.textTheme.titleLarge),
              const SizedBox(height: AppSpacing.xs),
              Text(
                episode.airDate,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EpisodeErrorState extends StatelessWidget {
  const _EpisodeErrorState({required this.message, required this.onRetry});

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final l10n = context.l10n;

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 420),
        child: Card(
          child: Padding(
            padding: AppSpacing.cardPadding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Icon(
                  Icons.wifi_tethering_error_rounded,
                  size: 40,
                  color: AppColors.secondary,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  l10n.unableToLoadEpisodesTitle,
                  style: theme.textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  message,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppSpacing.lg),
                FilledButton(
                  onPressed: onRetry,
                  child: Text(l10n.tryAgainLabel),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EpisodePaginationControls extends StatelessWidget {
  const _EpisodePaginationControls({
    required this.state,
    required this.onPreviousPage,
    required this.onNextPage,
  });

  final EpisodeListState state;
  final Future<void> Function() onPreviousPage;
  final Future<void> Function() onNextPage;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final l10n = context.l10n;

    return Row(
      children: <Widget>[
        Expanded(
          child: OutlinedButton.icon(
            onPressed: state.hasPreviousPage && !state.isLoading
                ? onPreviousPage
                : null,
            icon: const Icon(Icons.arrow_back_rounded),
            label: Text(l10n.previousPageLabel),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Center(
            child: Text(
              l10n.pageIndicatorLabel(state.currentPage, state.totalPages),
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: FilledButton.icon(
            onPressed: state.hasNextPage && !state.isLoading
                ? onNextPage
                : null,
            icon: const Icon(Icons.arrow_forward_rounded),
            label: Text(l10n.nextPageLabel),
          ),
        ),
      ],
    );
  }
}
