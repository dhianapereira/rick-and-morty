import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Rick and Morty')),
      body: child,
    );
  }
}
