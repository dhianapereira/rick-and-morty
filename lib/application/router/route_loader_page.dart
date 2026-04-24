import 'package:flutter/material.dart';
import 'package:rickandmorty/l10n/l10n_extension.dart';
import 'package:rickandmorty/shared/shared.dart';

class RouteLoaderPage extends StatefulWidget {
  const RouteLoaderPage({
    required this.onLoad,
    required this.errorTitle,
    required this.builder,
    super.key,
  });

  final Future<void> Function() onLoad;
  final String errorTitle;
  final WidgetBuilder builder;

  @override
  State<RouteLoaderPage> createState() => _RouteLoaderPageState();
}

class _RouteLoaderPageState extends State<RouteLoaderPage> {
  late Future<void> _loadFuture;

  @override
  void initState() {
    super.initState();
    _loadFuture = widget.onLoad();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: _loadFuture,
      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return _RouteLoaderErrorState(
            title: widget.errorTitle,
            message: snapshot.error.toString(),
            onRetry: _retry,
          );
        }

        return widget.builder(context);
      },
    );
  }

  Future<void> _retry() async {
    final Future<void> future = widget.onLoad();

    setState(() {
      _loadFuture = future;
    });
  }
}

class _RouteLoaderErrorState extends StatelessWidget {
  const _RouteLoaderErrorState({
    required this.title,
    required this.message,
    required this.onRetry,
  });

  final String title;
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
                    Icons.error_outline_rounded,
                    size: 40,
                    color: AppColors.secondary,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    title,
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
