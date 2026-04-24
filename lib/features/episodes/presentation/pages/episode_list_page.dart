import 'package:flutter/material.dart';
import 'package:rickandmorty/shared/shared.dart';

class EpisodeListPage extends StatelessWidget {
  const EpisodeListPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: AppSpacing.pagePadding,
      child: Align(alignment: Alignment.topLeft, child: Text('Episodes')),
    );
  }
}
