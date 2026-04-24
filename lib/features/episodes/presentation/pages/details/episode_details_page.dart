import 'package:flutter/material.dart';
import 'package:rickandmorty/features/characters/presentation/widgets/episode_characters_section.dart';
import 'package:rickandmorty/shared/shared.dart';

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
          Text('Episode $episodeId'),
          const SizedBox(height: AppSpacing.lg),
          const EpisodeCharactersSection(),
        ],
      ),
    );
  }
}
