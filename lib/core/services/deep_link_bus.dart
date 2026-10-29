import 'dart:async';
import 'package:flutter/material.dart';

/// Глобальная шина мгновенных переходов по deep-link (тёплый старт, D18-9).
/// NotificationService пишет маршрут при тапе на пуш; app.dart слушает стрим
/// и делает router.go() сразу. Холодный старт — fallback через SecureStorage.
class DeepLinkBus {
  DeepLinkBus._();
  static final DeepLinkBus instance = DeepLinkBus._();

  final StreamController<String> _controller =
      StreamController<String>.broadcast();

  void send(String route) {
    if (route.isNotEmpty) {
      _controller.add(route);
      debugPrint('DeepLinkBus: $route');
    }
  }

  Stream<String> get stream => _controller.stream;
}