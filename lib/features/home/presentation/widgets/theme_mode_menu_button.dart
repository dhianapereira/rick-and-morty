import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rickandmorty/application/theme/app_theme_preference.dart';
import 'package:rickandmorty/application/theme/theme_controller.dart';
import 'package:rickandmorty/l10n/l10n_extension.dart';

class ThemeModeMenuButton extends StatelessWidget {
  ThemeModeMenuButton({super.key}) : _controller = GetIt.I<ThemeController>();

  final ThemeController _controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppThemePreference>(
      valueListenable: _controller,
      builder: (_, preference, _) {
        final AppThemePreference currentPreference = preference;
        final ThemeData theme = Theme.of(context);
        return PopupMenuButton<AppThemePreference>(
          tooltip: context.l10n.themeMenuTooltip,
          initialValue: currentPreference,
          onSelected: _controller.updateThemePreference,
          icon: Material(
            color: theme.colorScheme.surfaceContainerHigh,
            elevation: 2,
            shadowColor: theme.colorScheme.shadow.withValues(alpha: 0.16),
            shape: const CircleBorder(),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                switchInCurve: Curves.easeOutCubic,
                switchOutCurve: Curves.easeInCubic,
                transitionBuilder: (child, animation) {
                  return RotationTransition(
                    turns: Tween<double>(
                      begin: 0.85,
                      end: 1,
                    ).animate(animation),
                    child: FadeTransition(opacity: animation, child: child),
                  );
                },
                child: Icon(
                  currentPreference.icon,
                  key: ValueKey<AppThemePreference>(currentPreference),
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
          ),
          itemBuilder: (BuildContext context) {
            return AppThemePreference.values
                .map(
                  (AppThemePreference option) =>
                      PopupMenuItem<AppThemePreference>(
                        value: option,
                        child: Text(option.label(context.l10n)),
                      ),
                )
                .toList(growable: false);
          },
        );
      },
    );
  }
}
