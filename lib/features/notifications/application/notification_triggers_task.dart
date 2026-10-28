import 'package:flutter/widgets.dart';
import 'package:workmanager/workmanager.dart';
import 'package:budget_assistant/core/logger.dart';
import 'package:budget_assistant/core/services/notification_service.dart';
import 'package:budget_assistant/core/services/secure_storage_service.dart';
import 'package:budget_assistant/features/notifications/domain/usecases/generate_daily_digest_usecase.dart';
import 'package:budget_assistant/features/notifications/domain/usecases/generate_notification_usecase.dart';
import 'package:budget_assistant/features/notifications/domain/usecases/notification_triggers_usecase.dart';
import 'package:budget_assistant/features/sync/application/sync_background_database.dart';

const String notificationTriggersTaskName = 'budget_assistant_notification_triggers';

/// Фоновая задача: оценка всех триггеров пушей + дайджесты (ТОМ 5).
/// Запускается при старте (one-off через 20с) и каждые 6 часов (periodic).
/// TODO(18.7): deep-link по тапу на пуш — открытие экранов (календарь, цель, долг).
/// TODO(18.7): обработка action-кнопок confirm/dismiss из пуша (долги, цели).
@pragma('vm:entry-point')
Future<bool> handleNotificationTriggersTask() async {
  WidgetsFlutterBinding.ensureInitialized();
  final storage = SecureStorageService();
  final uid = await storage.read('current_user_id');
  if (uid == null || uid.isEmpty) {
    return true;
  }
  final db = await openSyncDatabaseInBackground() ;
  try {
    final now = DateTime.now();
    final gen = GenerateNotificationUseCase(db);
    final triggers = NotificationTriggersUseCase(db);
    final service = NotificationService(db);
    final results = await triggers.evaluate(uid, now);
    var shown = 0;
    for (final r in results) {
      final created = await gen(
        userId: uid,
        type: r.type,
        title: r.title,
        body: r.body,
        spaceId: r.spaceId,
        relatedEntityId: r.entityId,
        dedupWindow: Duration(days: r.dedupDays),
      );
      if (created) {
        await service.showNotification(
          notificationId: '${r.type.dbValue}:${r.entityId}',
          type: r.type,
          title: r.title,
          body: r.body,
        );
        shown++;
      }
    }
    if (now.hour >= 19) {
      final digest = await GenerateDailyDigestUseCase(db).maybeGenerate(uid, now);
      if (digest != null) {
        final created = await gen(
          userId: uid,
          type: digest.type,
          title: digest.title,
          body: digest.body,
          relatedEntityId: digest.id,
          dedupWindow: const Duration(hours: 20),
        );
        if (created) {
          await service.showNotification(
            notificationId: digest.id,
            type: digest.type,
            title: digest.title,
            body: digest.body,
          );
          shown++;
        }
      }
    }
    AppLogger.i('NotificationTriggers: shown=$shown');
    return true;
  } catch (e, st) {
    AppLogger.e('NotificationTriggersTask failed', e, st);
    return false;
  } finally {
    await db.close();
  }
}

/// Регистрация фоновых задач пушей.
class NotificationTriggersWorker {
  static Future<void> register() async {
    try {
      await Workmanager().registerPeriodicTask(
        notificationTriggersTaskName,
        notificationTriggersTaskName,
        existingWorkPolicy: ExistingWorkPolicy.keep,
        frequency: const Duration(hours: 6),
      );
      await Workmanager().registerOneOffTask(
        '${notificationTriggersTaskName}_boot',
        notificationTriggersTaskName,
        existingWorkPolicy: ExistingWorkPolicy.replace,
        initialDelay: const Duration(seconds: 20),
      );
      AppLogger.i('NotificationTriggersWorker registered');
    } catch (e, st) {
      AppLogger.e('NotificationTriggersWorker register failed', e, st);
    }
  }
}