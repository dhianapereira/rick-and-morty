import 'package:flutter/material.dart';
import 'package:rickandmorty/l10n/l10n_extension.dart';

class EpisodeCharactersSection extends StatelessWidget {
  const EpisodeCharactersSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(context.l10n.charactersTitle);
  }
}
