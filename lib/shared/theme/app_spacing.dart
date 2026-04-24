import 'package:flutter/widgets.dart';

class AppSpacing {
  const AppSpacing._();

  static const double none = 0;
  static const double xxxs = 4;
  static const double xxs = 8;
  static const double xs = 12;
  static const double sm = 16;
  static const double md = 20;
  static const double lg = 24;
  static const double xl = 32;
  static const double xxl = 40;
  static const double xxxl = 48;

  static const double radiusSm = 12;
  static const double radiusMd = 20;
  static const double radiusLg = 28;
  static const double radiusFull = 999;

  static const EdgeInsets pagePadding = EdgeInsets.symmetric(
    horizontal: lg,
    vertical: sm,
  );
  static const EdgeInsets sectionPadding = EdgeInsets.all(sm);
  static const EdgeInsets cardPadding = EdgeInsets.all(md);
  static const EdgeInsets chipPadding = EdgeInsets.symmetric(
    horizontal: xs,
    vertical: xxs,
  );
  static const EdgeInsets listItemSpacing = EdgeInsets.only(bottom: sm);
}
