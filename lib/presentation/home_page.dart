import 'package:flutter/material.dart';
import 'package:rickandmorty/shared/shared.dart';

class MyHomePage extends StatelessWidget {
  const MyHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rick and Morty')),
      body: const Padding(
        padding: AppSpacing.pagePadding,
        child: SizedBox.expand(),
      ),
    );
  }
}
