import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Утилита расчёта контраста по формуле WCAG 2.1 (Этап 22, ТЗ 6.10.2).
///
/// Формула:
/// 1. Линейзация sRGB.
/// 2. Относительная яркость: L = 0.2126*R + 0.7152*G + 0.0722*B.
/// 3. Контраст: (L1 + 0.05) / (L2 + 0.05), где L1 — более яркий цвет.
abstract final class ContrastChecker {
  /// Минимальный контраст для обычного текста (WCAG AA).
  static const double minTextContrast = 4.5;

  /// Минимальный контраст для крупного текста.
  static const double minLargeTextContrast = 3.0;

  /// Минимальный контраст для важных UI-элементов.
  static const double minUiContrast = 3.0;

  /// Линейлизует один канал sRGB [0..1].
  static double _linearize(double channel) {
    final srgb = channel.clamp(0.0, 1.0).toDouble();
    if (srgb <= 0.03928) {
      return srgb / 12.92;
    }
    return math.pow((srgb + 0.055) / 1.055, 2.4).toDouble();
  }

  /// Относительная яркость цвета по WCAG.
  static double relativeLuminance(Color color) {
    final r = _linearize(color.r);
    final g = _linearize(color.g);
    final b = _linearize(color.b);
    return 0.2126 * r + 0.7152 * g + 0.0722 * b;
  }

  /// Коэффициент контраста между двумя цветами (от 1.0 до 21.0).
  static double contrastRatio(Color foreground, Color background) {
    final l1 = relativeLuminance(foreground);
    final l2 = relativeLuminance(background);
    final lighter = math.max(l1, l2);
    final darker = math.min(l1, l2);
    return (lighter + 0.05) / (darker + 0.05);
  }

  /// true, если пара подходит для обычного текста (>= 4.5:1).
  static bool meetsTextContrast(Color foreground, Color background) {
    return contrastRatio(foreground, background) >= minTextContrast;
  }

  /// true, если пара подходит для крупного текста (>= 3.0:1).
  static bool meetsLargeTextContrast(Color foreground, Color background) {
    return contrastRatio(foreground, background) >= minLargeTextContrast;
  }

  /// true, если пара подходит для важных UI-элементов (>= 3.0:1).
  static bool meetsUiContrast(Color foreground, Color background) {
    return contrastRatio(foreground, background) >= minUiContrast;
  }
}