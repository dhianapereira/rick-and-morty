import 'package:flutter/material.dart';
import 'package:rickandmorty/l10n/l10n_extension.dart';
import 'package:rickandmorty/shared/shared.dart';

class CharacterDetailsPage extends StatelessWidget {
  const CharacterDetailsPage({required this.characterId, super.key});

  final int characterId;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.characterDetailsTitle(characterId)),
      ),
      body: Padding(
        padding: AppSpacing.pagePadding,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: theme.colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(AppSpacing.radiusLg),
          ),
          child: Padding(
            padding: AppSpacing.cardPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  context.l10n.characterDetailsPlaceholder,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
