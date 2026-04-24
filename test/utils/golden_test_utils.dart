import 'package:alchemist/alchemist.dart';
import 'package:flutter/material.dart';

GoldenTestGroup buildMobileGoldenScenario({
  required Widget child,
  String name = 'mobile',
  int columns = 1,
}) {
  return _GoldenScenarioFactory(
    child: child,
    name: name,
    columns: columns,
  ).build();
}

class _GoldenScenarioFactory {
  const _GoldenScenarioFactory({
    required this.child,
    required this.name,
    required this.columns,
  });

  final Widget child;
  final String name;
  final int columns;

  GoldenTestGroup build() {
    return GoldenTestGroup(
      columns: columns,
      children: <Widget>[
        GoldenTestScenario(
          name: name,
          child: SizedBox(width: 390, height: 844, child: child),
        ),
      ],
    );
  }
}
