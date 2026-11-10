import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Утилиты доступности (Этап 22, ТЗ 6.10).
abstract final class AnimationUtils {
  /// true, если системные настройки разрешают анимации.
  static bool shouldAnimate(BuildContext context) {
    return !MediaQuery.of(context).disableAnimations;
  }

  /// Возвращает длительность анимации с учётом настройки "Уменьшить движение".
  static Duration getAnimationDuration(BuildContext context, Duration normal) {
    return shouldAnimate(context) ? normal : Duration.zero;
  }
}

/// Сервис тактильной обратной связи с учётом настройки "Уменьшить движение".
abstract final class HapticService {
  static Future<void> light(BuildContext context) async {
    if (AnimationUtils.shouldAnimate(context)) {
      await HapticFeedback.lightImpact();
    }
  }

  static Future<void> medium(BuildContext context) async {
    if (AnimationUtils.shouldAnimate(context)) {
      await HapticFeedback.mediumImpact();
    }
  }

  static Future<void> heavy(BuildContext context) async {
    if (AnimationUtils.shouldAnimate(context)) {
      await HapticFeedback.heavyImpact();
    }
  }

  static Future<void> selection(BuildContext context) async {
    if (AnimationUtils.shouldAnimate(context)) {
      await HapticFeedback.selectionClick();
    }
  }

  static Future<void> error(BuildContext context) async {
    if (AnimationUtils.shouldAnimate(context)) {
      await HapticFeedback.vibrate();
    }
  }
}