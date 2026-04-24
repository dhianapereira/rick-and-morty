import 'package:flutter/material.dart';
import 'package:rickandmorty/features/characters/presentation/widgets/episode_characters_section.dart';
import 'package:rickandmorty/shared/shared.dart';
import 'package:rickandmorty/l10n/l10n_extension.dart';

class EpisodeDetailsPage extends StatelessWidget {
  const EpisodeDetailsPage({required this.episodeId, super.key});

  final int episodeId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.pagePadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(context.l10n.episodeTitle(episodeId)),
          const SizedBox(height: AppSpacing.lg),
          const EpisodeCharactersSection(),
        ],
      ),
    );
  }
}
