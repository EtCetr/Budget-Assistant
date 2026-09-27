import 'package:flutter/services.dart';

/// Haptic-токены (ТЗ: хаптика только через MotionTokens,
/// прямых вызовов HapticFeedback в UI быть не должно).
abstract final class MotionTokens {
  static Future<void> light() => HapticFeedback.lightImpact();
  static Future<void> medium() => HapticFeedback.mediumImpact();
  static Future<void> heavy() => HapticFeedback.heavyImpact();
  static Future<void> selection() => HapticFeedback.selectionClick();
  static Future<void> error() => HapticFeedback.vibrate();
}