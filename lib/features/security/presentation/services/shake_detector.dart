// lib/features/security/presentation/services/shake_detector.dart
// Этап 21 (ТЗ 6.3.28.4): детектор встряхивания для быстрого скрытия балансов.
import 'dart:async';
import 'dart:math';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:budget_assistant/core/logger.dart';
import 'package:budget_assistant/features/privacy/domain/models/balance_visibility_mode.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';

const double _kShakeThreshold = 15.0;
const Duration _kShakeInterval = Duration(milliseconds: 500);
const Duration _kShakeHideDuration = Duration(seconds: 30);

class ShakeDetector {
  ShakeDetector._();
  static final ShakeDetector instance = ShakeDetector._();

  StreamSubscription<AccelerometerEvent>? _subscription;
  DateTime? _lastShake;
  BalanceVisibilityMode? _previousMode;
  Timer? _restoreTimer;
  bool _isActive = false;

  void start(WidgetRef ref) {
    if (_isActive) return;
    _isActive = true;
    _subscription = accelerometerEventStream().listen((event) {
      if (!_isActive) return;
      final acceleration = sqrt(
        event.x * event.x + event.y * event.y + event.z * event.z,
      );
      if (acceleration > _kShakeThreshold) {
        final now = DateTime.now();
        if (_lastShake == null || now.difference(_lastShake!) > _kShakeInterval) {
          _lastShake = now;
          _onShakeDetected(ref);
        }
      }
    });
    AppLogger.i('✅ ShakeDetector started');
  }

  void stop() {
    _isActive = false;
    _subscription?.cancel();
    _subscription = null;
    _restoreTimer?.cancel();
    _restoreTimer = null;
    AppLogger.i('⏹️ ShakeDetector stopped');
  }

  void _onShakeDetected(WidgetRef ref) {
    try {
      HapticFeedback.heavyImpact();
      final currentMode = ref.read(privacyModeProvider);
      if (currentMode == BalanceVisibilityMode.hidden) return;
      _previousMode = currentMode;
      ref.read(privacyModeProvider.notifier).setMode(BalanceVisibilityMode.hidden);
      AppLogger.i('📱 Shake detected → privacy mode = hidden (30 sec)');
      _restoreTimer?.cancel();
      _restoreTimer = Timer(_kShakeHideDuration, () {
        if (_previousMode != null) {
          ref.read(privacyModeProvider.notifier).setMode(_previousMode!);
          _previousMode = null;
          AppLogger.i('🔄 Privacy mode restored after shake timeout');
        }
      });
    } catch (e, st) {
      AppLogger.e('ShakeDetector error', e, st);
    }
  }
}