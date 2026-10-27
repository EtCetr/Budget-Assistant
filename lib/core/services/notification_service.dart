import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/logger.dart';
import 'package:budget_assistant/features/notifications/domain/models/notification_type.dart';
import 'package:budget_assistant/features/notifications/domain/usecases/handle_notification_action_usecase.dart';

/// Сервис локальных уведомлений (Zero FCM Dependency).
class NotificationService {
  NotificationService(this._db);
  final AppDatabase _db;

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  bool _ready = false;

  static const String actionConfirm = 'CONFIRM';
  static const String actionDismiss = 'DISMISS';

  Future<void> ensureReady() async {
    if (_ready) return;
    _ready = true;
    try {
      const initSettings = InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
      );
      await _plugin.initialize(
        settings: initSettings,
        onDidReceiveNotificationResponse: _onForegroundResponse,
        onDidReceiveBackgroundNotificationResponse: onBackgroundResponse,
      );
      final android = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      for (final ch in NotificationChannel.values) {
        await android?.createNotificationChannel(AndroidNotificationChannel(
          ch.id,
          ch.title,
          description: ch.description,
          importance: Importance.high,
        ));
      }
    } catch (e, st) {
      _ready = false;
      AppLogger.e('NotificationService init failed', e, st);
      rethrow;
    }
  }

  Future<void> showNotification({
    required String notificationId,
    required NotificationType type,
    required String title,
    required String body,
  }) async {
    try {
      await ensureReady();
      final details = AndroidNotificationDetails(
        type.channelId,
        type.channel.title,
        channelDescription: type.channel.description,
        importance: Importance.high,
        priority: Priority.high,
        actions: const [
          AndroidNotificationAction(actionConfirm, 'Подтвердить'),
          AndroidNotificationAction(actionDismiss, 'Отклонить'),
        ],
      );
      await _plugin.show(
        id: notificationId.hashCode,
        title: title,
        body: body,
        notificationDetails: NotificationDetails(android: details),
        payload: jsonEncode({
          'notificationId': notificationId,
          'type': type.dbValue,
        }),
      );
    } catch (e, st) {
      AppLogger.e('showNotification failed', e, st);
    }
  }

  void _onForegroundResponse(NotificationResponse response) {
    _handleAction(response);
  }

  Future<void> _handleAction(NotificationResponse response) async {
    if (response.payload == null) return;
    try {
      final payload = jsonDecode(response.payload!) as Map<String, dynamic>;
      final id = payload['notificationId'] as String?;
      final actionId = response.actionId;
      if (id == null || actionId == null) return;
      final useCase = HandleNotificationActionUseCase(_db);
      final action = actionId == actionConfirm ? 'confirmed' : 'dismissed';
      await useCase.call(notificationId: id, action: action);
    } catch (e, st) {
      AppLogger.e('Handle action failed', e, st);
    }
  }
}

@pragma('vm:entry-point')
void onBackgroundResponse(NotificationResponse response) async {
  if (response.payload == null || response.actionId == null) return;
  try {
    final payload = jsonDecode(response.payload!) as Map<String, dynamic>;
    final id = payload['notificationId'] as String?;
    if (id == null) return;
    final db = AppDatabase();
    final useCase = HandleNotificationActionUseCase(db);
    final action = response.actionId == NotificationService.actionConfirm
        ? 'confirmed'
        : 'dismissed';
    await useCase.call(notificationId: id, action: action);
    await db.close();
  } catch (e) {
    AppLogger.e('Background action failed: $e');
  }
}