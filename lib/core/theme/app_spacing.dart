import 'package:flutter/material.dart';

/// Токены отступов и скруглений дизайн-системы.
abstract final class AppSpacing {
  static const double spacing4 = 4;
  static const double spacing8 = 8;
  static const double spacing12 = 12;
  static const double spacing16 = 16;
  static const double spacing24 = 24;
  static const double spacing32 = 32;
}

abstract final class AppRadius {
  static const double radiusSm = 8;
  static const double radiusMd = 12;
  static const double radiusLg = 16;
  static const BorderRadius radiusFull = BorderRadius.all(Radius.circular(999));
}
