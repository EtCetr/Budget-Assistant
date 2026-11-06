// lib/features/security/presentation/services/user_activity_observer.dart
// Этап 21 (ТЗ 6.3.28.6): автоматическое скрытие при бездействии.
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:budget_assistant/core/logger.dart';
import 'package:budget_assistant/features/privacy/domain/models/balance_visibility_mode.dart';
import 'package:budget_assistant/features/privacy/presentation/providers/privacy_mode_provider.dart';

class UserActivityObserver with WidgetsBindingObserver {
  UserActivityObserver._();
  static final UserActivityObserver instance = UserActivityObserver._();

  Timer? _inactivityTimer;
  WidgetRef? _ref;
  bool _isActive = false;

  void start(WidgetRef ref) {
    if (_isActive) return;
    _isActive = true;
    _ref = ref;
    WidgetsBinding.instance.addObserver(this);
    AppLogger.i('✅ UserActivityObserver started');
  }

  void stop() {
    _isActive = false;
    _inactivityTimer?.cancel();
    _inactivityTimer = null;
    WidgetsBinding.instance.removeObserver(this);
    _ref = null;
    AppLogger.i('⏹️ UserActivityObserver stopped');
  }

  /// Любое пользовательское взаимодействие (тап, свайп, скролл).
  /// [timeoutSeconds] — autoHideTimeoutSeconds; 0 = автоскрытие выключено.
  void onUserActivity(int timeoutSeconds) {
    if (!_isActive || _ref == null) return;
    _inactivityTimer?.cancel();
    _inactivityTimer = null;
    if (timeoutSeconds <= 0) return;
    _inactivityTimer = Timer(Duration(seconds: timeoutSeconds), () {
      _onInactivityTimeout();
    });
  }

  void _onInactivityTimeout() {
    if (_ref == null) return;
    try {
      final currentMode = _ref!.read(privacyModeProvider);
      if (currentMode == BalanceVisibilityMode.hidden) return;
      _ref!.read(privacyModeProvider.notifier).setMode(BalanceVisibilityMode.hidden);
      AppLogger.i('⏱️ Inactivity timeout → privacy mode = hidden');
    } catch (e, st) {
      AppLogger.e('UserActivityObserver error', e, st);
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
      _inactivityTimer?.cancel();
      _inactivityTimer = null;
    }
  }
}