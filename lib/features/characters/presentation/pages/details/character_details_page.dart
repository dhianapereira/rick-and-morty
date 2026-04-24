import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:rickandmorty/features/characters/domain/entities/character_details.dart';
import 'package:rickandmorty/features/characters/domain/entities/character_place.dart';
import 'package:rickandmorty/features/characters/presentation/controllers/character_details_controller.dart';
import 'package:rickandmorty/features/characters/presentation/controllers/character_details_state.dart';
import 'package:rickandmorty/l10n/l10n_extension.dart';
import 'package:rickandmorty/shared/shared.dart';

class CharacterDetailsPage extends StatefulWidget {
  const CharacterDetailsPage({required this.characterId, super.key});

  final int characterId;

  @override
  State<CharacterDetailsPage> createState() => _CharacterDetailsPageState();
}

class _CharacterDetailsPageState extends State<CharacterDetailsPage> {
  late final CharacterDetailsController _controller;

  @override
  void initState() {
    super.initState();
    _controller = GetIt.I<CharacterDetailsController>(
      param1: widget.characterId,
    );
    _controller.load();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<CharacterDetailsState>(
      valueListenable: _controller,
      builder: (_, CharacterDetailsState state, _) {
        final String title =
            state.details?.name ??
            context.l10n.characterDetailsTitle(widget.characterId);

        return Scaffold(
          appBar: AppBar(title: Text(title)),
          body: switch ((state.isLoading, state.hasContent, state.hasError)) {
            (true, false, _) => const Center(
              child: CircularProgressIndicator(),
            ),
            (_, false, true) => _CharacterDetailsErrorState(
              message: state.errorMessage!,
              onRetry: _controller.retry,
            ),
            _ => _CharacterDetailsContent(details: state.details!),
          },
        );
      },
    );
  }
}

class _CharacterDetailsContent extends StatelessWidget {
  const _CharacterDetailsContent({required this.details});

  final CharacterDetails details;

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      key: PageStorageKey<int>(details.id),
      slivers: <Widget>[
        SliverPadding(
          padding: AppSpacing.pagePadding,
          sliver: SliverList.list(
            children: <Widget>[
              _CharacterHeroCard(details: details),
              const SizedBox(height: AppSpacing.lg),
              _CharacterQuickFacts(details: details),
              const SizedBox(height: AppSpacing.lg),
              _CharacterPlacesSection(details: details),
              const SizedBox(height: AppSpacing.lg),
              _CharacterEpisodesSection(details: details),
            ],
          ),
        ),
      ],
    );
  }
}

class _CharacterHeroCard extends StatelessWidget {
  const _CharacterHeroCard({required this.details});

  final CharacterDetails details;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
        border: Border.all(color: theme.colorScheme.outlineVariant),
      ),
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              child: Image.network(
                details.imageUrl,
                width: 112,
                height: 112,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) {
                  return Container(
                    width: 112,
                    height: 112,
                    color: theme.colorScheme.surfaceContainerHighest,
                    alignment: Alignment.center,
                    child: Icon(
                      Icons.person_rounded,
                      size: 40,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  );
                },
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _StatusBadge(status: details.status),
                  const SizedBox(height: AppSpacing.sm),
                  Text(details.name, style: theme.textTheme.headlineMedium),
                  const SizedBox(height: AppSpacing.xs),
                  Text(
                    details.species,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  if (details.type.isNotEmpty) ...<Widget>[
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      details.type,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CharacterQuickFacts extends StatelessWidget {
  const _CharacterQuickFacts({required this.details});

  final CharacterDetails details;

  @override
  Widget build(BuildContext context) {
    final DateFormat formatter = DateFormat.yMMMd();

    return Wrap(
      spacing: AppSpacing.sm,
      runSpacing: AppSpacing.sm,
      children: <Widget>[
        _CharacterInfoCard(
          label: context.l10n.characterGenderLabel,
          value: details.gender,
        ),
        _CharacterInfoCard(
          label: context.l10n.characterEpisodesLabel,
          value: details.episodeCount.toString(),
        ),
        _CharacterInfoCard(
          label: context.l10n.characterCreatedAtLabel,
          value: formatter.format(details.createdAt),
        ),
        _CharacterInfoCard(
          label: context.l10n.characterStatusLabel,
          value: details.status,
        ),
      ],
    );
  }
}

class _CharacterPlacesSection extends StatelessWidget {
  const _CharacterPlacesSection({required this.details});

  final CharacterDetails details;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          context.l10n.characterPlacesTitle,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: AppSpacing.md),
        _CharacterPlaceCard(
          label: context.l10n.characterOriginLabel,
          place: details.origin,
        ),
        const SizedBox(height: AppSpacing.sm),
        _CharacterPlaceCard(
          label: context.l10n.characterLocationLabel,
          place: details.location,
        ),
      ],
    );
  }
}

class _CharacterEpisodesSection extends StatelessWidget {
  const _CharacterEpisodesSection({required this.details});

  final CharacterDetails details;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          context.l10n.characterEpisodesTitle,
          style: theme.textTheme.headlineMedium,
        ),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.xs,
          runSpacing: AppSpacing.xs,
          children: details.episodeUrls
              .map(_extractEpisodeId)
              .map(
                (int episodeId) =>
                    Chip(label: Text(context.l10n.episodeTitle(episodeId))),
              )
              .toList(growable: false),
        ),
      ],
    );
  }

  int _extractEpisodeId(String episodeUrl) {
    return int.parse(Uri.parse(episodeUrl).pathSegments.last);
  }
}

class _CharacterInfoCard extends StatelessWidget {
  const _CharacterInfoCard({required this.label, required this.value});

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

class _CharacterPlaceCard extends StatelessWidget {
  const _CharacterPlaceCard({required this.label, required this.place});

  final String label;
  final CharacterPlace place;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Padding(
        padding: AppSpacing.cardPadding,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(Icons.public_rounded, color: theme.colorScheme.primary),
            const SizedBox(width: AppSpacing.sm),
            Expanded(
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
                  Text(place.name, style: theme.textTheme.titleMedium),
                  if (place.hasDetails) ...<Widget>[
                    const SizedBox(height: AppSpacing.xxs),
                    Text(
                      place.url,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.colorScheme.scrim.withValues(alpha: 0.72),
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        border: Border.all(color: _statusColor.withValues(alpha: 0.42)),
      ),
      child: Padding(
        padding: AppSpacing.chipPadding,
        child: Text(
          status,
          style: theme.textTheme.labelMedium?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  Color get _statusColor {
    return switch (status.toLowerCase()) {
      'alive' => AppColors.statusAlive,
      'dead' => AppColors.statusDead,
      _ => AppColors.statusUnknown,
    };
  }
}

class _CharacterDetailsErrorState extends StatelessWidget {
  const _CharacterDetailsErrorState({
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
                    Icons.person_off_rounded,
                    size: 40,
                    color: AppColors.secondary,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    context.l10n.unableToLoadCharacterDetailsTitle,
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
