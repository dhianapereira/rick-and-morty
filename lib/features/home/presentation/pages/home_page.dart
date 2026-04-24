import 'package:flutter/material.dart';
import 'package:rickandmorty/features/home/presentation/widgets/theme_mode_menu_button.dart';
import 'package:rickandmorty/l10n/l10n_extension.dart';

class HomePage extends StatelessWidget {
  const HomePage({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.appName),
        actions: <Widget>[ThemeModeMenuButton()],
      ),
      body: child,
    );
  }
}
