// lib/features/security/presentation/services/face_down_detector.dart
// Этап 21 (ТЗ 6.3.28.5): детектор переворота экраном вниз.
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'package:budget_assistant/core/logger.dart';
import 'package:budget_assistant/features/privacy/domain/models/balance_visibility_mode.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';

const double _kFaceDownAngle = 160.0;
const Duration _kFaceDownDuration = Duration(seconds: 2);

class FaceDownDetector {
  FaceDownDetector._();
  static final FaceDownDetector instance = FaceDownDetector._();

  StreamSubscription<AccelerometerEvent>? _subscription;
  Timer? _faceDownTimer;
  BalanceVisibilityMode? _previousMode;
  bool _isActive = false;
  bool _isFaceDown = false;

  void start(WidgetRef ref) {
    if (_isActive) return;
    _isActive = true;
    _subscription = accelerometerEventStream().listen((event) {
      if (!_isActive) return;
      final angle = _calculateTiltAngle(event);
      if (angle > _kFaceDownAngle) {
        if (!_isFaceDown) {
          _isFaceDown = true;
          _faceDownTimer = Timer(_kFaceDownDuration, () {
            _onFaceDownDetected(ref);
          });
        }
      } else {
        _isFaceDown = false;
        _faceDownTimer?.cancel();
        _faceDownTimer = null;
        if (_previousMode != null) {
          ref.read(privacyModeProvider.notifier).setMode(_previousMode!);
          _previousMode = null;
          AppLogger.i('🔄 Privacy mode restored after face-up');
        }
      }
    });
    AppLogger.i('✅ FaceDownDetector started');
  }

  void stop() {
    _isActive = false;
    _subscription?.cancel();
    _subscription = null;
    _faceDownTimer?.cancel();
    _faceDownTimer = null;
    AppLogger.i('⏹️ FaceDownDetector stopped');
  }

  double _calculateTiltAngle(AccelerometerEvent event) {
    final normalizedZ = event.z / 9.8;
    final angle = normalizedZ.clamp(-1.0, 1.0);
    return (angle + 1.0) * 90.0;
  }

  void _onFaceDownDetected(WidgetRef ref) {
    try {
      final currentMode = ref.read(privacyModeProvider);
      if (currentMode == BalanceVisibilityMode.hidden) return;
      _previousMode = currentMode;
      ref.read(privacyModeProvider.notifier).setMode(BalanceVisibilityMode.hidden);
      AppLogger.i('📱 Face-down detected → privacy mode = hidden');
    } catch (e, st) {
      AppLogger.e('FaceDownDetector error', e, st);
    }
  }
}