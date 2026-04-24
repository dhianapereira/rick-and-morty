import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:rickandmorty/application/router/app_router.dart';
import 'package:rickandmorty/features/characters/domain/entities/character.dart';
import 'package:rickandmorty/features/characters/presentation/widgets/character_list_item.dart';
import 'package:rickandmorty/features/episodes/domain/entities/episode_details.dart';
import 'package:rickandmorty/features/episodes/presentation/controllers/episode_details_controller.dart';
import 'package:rickandmorty/features/episodes/presentation/controllers/episode_details_state.dart';
import 'package:rickandmorty/l10n/l10n_extension.dart';
import 'package:rickandmorty/shared/shared.dart';

class EpisodeDetailsPage extends StatefulWidget {
  const EpisodeDetailsPage({required this.episodeId, super.key});

  final int episodeId;

  @override
  State<EpisodeDetailsPage> createState() => _EpisodeDetailsPageState();
}

class _EpisodeDetailsPageState extends State<EpisodeDetailsPage> {
  late final EpisodeDetailsController _controller;

  @override
  void initState() {
    super.initState();
    _controller = GetIt.I<EpisodeDetailsController>(param1: widget.episodeId);
    _controller.load();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<EpisodeDetailsState>(
      valueListenable: _controller,
      builder:
          (BuildContext context, EpisodeDetailsState state, Widget? child) {
            final String title = context.l10n.episodeTitle(widget.episodeId);

            if (state.isLoading && !state.hasContent) {
              return Scaffold(
                appBar: AppBar(title: Text(title)),
                body: const Center(child: CircularProgressIndicator()),
              );
            }

            if (state.hasError && !state.hasContent) {
              return Scaffold(
                appBar: AppBar(title: Text(title)),
                body: _EpisodeDetailsErrorState(
                  message: state.errorMessage!,
                  onRetry: _controller.retry,
                ),
              );
            }

            final EpisodeDetails details = state.details!;

            return Scaffold(
              appBar: AppBar(title: Text(title)),
              body: CustomScrollView(
                key: PageStorageKey<int>(details.id),
                slivers: <Widget>[
                  SliverPadding(
                    padding: AppSpacing.pagePadding,
                    sliver: SliverList.list(
                      children: <Widget>[
                        _EpisodeHeroCard(details: details),
                        const SizedBox(height: AppSpacing.lg),
                        _EpisodeMetadataSection(details: details),
                        const SizedBox(height: AppSpacing.xl),
                        _EpisodeCharactersHeader(
                          count: details.characters.length,
                        ),
                        const SizedBox(height: AppSpacing.md),
                      ],
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      0,
                      AppSpacing.lg,
                      AppSpacing.lg,
                    ),
                    sliver: SliverGrid(
                      delegate: SliverChildBuilderDelegate((
                        BuildContext context,
                        int index,
                      ) {
                        final Character character = details.characters[index];

                        return CharacterListItem(
                          character: character,
                          onTap: () => context.push(
                            AppRouter.characterDetailsLocation(character.id),
                          ),
                        );
                      }, childCount: details.characters.length),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: AppSpacing.md,
                            crossAxisSpacing: AppSpacing.md,
                            childAspectRatio: 0.72,
                          ),
                    ),
                  ),
                ],
              ),
            );
          },
    );
  }
}

class _EpisodeHeroCard extends StatelessWidget {
  const _EpisodeHeroCard({required this.details});

  final EpisodeDetails details;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: <Color>[
            theme.colorScheme.surfaceContainerHighest,
            theme.colorScheme.surfaceContainer,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            DecoratedBox(
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
              ),
              child: Padding(
                padding: AppSpacing.chipPadding,
                child: Text(
                  details.code,
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Text(details.name, style: theme.textTheme.headlineMedium),
            const SizedBox(height: AppSpacing.sm),
            Text(
              context.l10n.episodeDetailsDescription(details.characters.length),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _EpisodeMetadataSection extends StatelessWidget {
  const _EpisodeMetadataSection({required this.details});

  final EpisodeDetails details;

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat.yMMMd();

    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: <Widget>[
        _EpisodeMetadataCard(
          label: context.l10n.episodeCodeLabel,
          value: details.code,
        ),
        _EpisodeMetadataCard(
          label: context.l10n.episodeAirDateLabel,
          value: details.airDate,
        ),
        _EpisodeMetadataCard(
          label: context.l10n.episodeCreatedAtLabel,
          value: formatter.format(details.createdAt),
        ),
        _EpisodeMetadataCard(
          label: context.l10n.episodeCharactersCountLabel,
          value: details.characters.length.toString(),
        ),
      ],
    );
  }
}

class _EpisodeMetadataCard extends StatelessWidget {
  const _EpisodeMetadataCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return SizedBox(
      width: 160,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        child: Padding(
          padding: AppSpacing.cardPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(value, style: theme.textTheme.titleMedium),
            ],
          ),
        ),
      ),
    );
  }
}

class _EpisodeCharactersHeader extends StatelessWidget {
  const _EpisodeCharactersHeader({required this.count});

  final int count;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Row(
      children: <Widget>[
        Expanded(
          child: Text(
            context.l10n.charactersTitle,
            style: theme.textTheme.headlineMedium,
          ),
        ),
        Text(
          context.l10n.episodeCharactersCountValue(count),
          style: theme.textTheme.labelLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _EpisodeDetailsErrorState extends StatelessWidget {
  const _EpisodeDetailsErrorState({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: AppSpacing.pagePadding,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Card(
            child: Padding(
              padding: AppSpacing.cardPadding,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Icon(
                    Icons.tv_off_rounded,
                    size: 40,
                    color: AppColors.secondary,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    context.l10n.unableToLoadEpisodeDetailsTitle,
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
                    child: Text(context.l10n.tryAgainLabel),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
