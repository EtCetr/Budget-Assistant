import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// Этап 23: debug-детекция утечек памяти (без новых пакетов).
///
/// Как пользоваться:
/// 1. В State — подмешать [LeakGuardedState] (авторегистрация).
/// 2. Вручную: LeakGuard.track(controller) / LeakGuard.release(controller).
/// 3. Проверка: LeakGuard.logReport() (на выходе с экрана или в тестах).
///
/// В release все методы — no-op.
class LeakGuard {
  LeakGuard._();

  static final Map<int, String> _live = <int, String>{};

  static void track(Object object, [String? label]) {
    if (!kDebugMode) return;
    _live[identityHashCode(object)] = label ?? object.runtimeType.toString();
  }

  static void release(Object object) {
    if (!kDebugMode) return;
    _live.remove(identityHashCode(object));
  }

  /// Список живых отслеживаемых объектов.
  static List<String> liveObjects() {
    if (!kDebugMode) return const <String>[];
    return List<String>.unmodifiable(_live.values);
  }

  static void logReport() {
    if (!kDebugMode) return;
    if (_live.isEmpty) {
      debugPrint('LeakGuard: живых отслеживаемых объектов нет');
      return;
    }
    debugPrint(
      'LeakGuard: живых отслеживаемых объектов ${_live.length}: '
      '${_live.values.join(', ')}',
    );
  }
}

/// Миксин для State: авторегистрация в initState, снятие в dispose.
mixin LeakGuardedState<T extends StatefulWidget> on State<T> {
  @override
  void initState() {
    super.initState();
    LeakGuard.track(this);
  }

  @override
  void dispose() {
    LeakGuard.release(this);
    super.dispose();
  }
}