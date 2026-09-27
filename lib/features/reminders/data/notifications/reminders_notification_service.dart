import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:timezone/data/latest_all.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import 'package:budget_assistant/core/logger.dart';
import '../../domain/entities/reminder.dart';
import '../../domain/ports/reminders_scheduler_port.dart';

/// Намерение из уведомления (тап или экшен) для UI-слоя.
class ReminderNotificationIntent {
  const ReminderNotificationIntent({this.actionId, required this.reminderId});
  final String? actionId;
  final String reminderId;
}

/// Реализация порта планировщика на flutter_local_notifications.
///
/// Ключевые решения (зафиксированы в DECISIONS):
/// - строго 3 PendingIntent на напоминание (лимит Android);
/// - рескейдул: старт app + CRUD + открытие RemindersScreen;
///   WorkManager-piggyback — долг Этапа 18;
/// - экшен «Выполнено» из пуша при убитом app пишет в БД напрямую
///   в background-изолейте (путь БД передаём в payload);
/// - экшен «Отложить» и тап открывают app (intent в UI-слой).
class RemindersNotificationService implements RemindersSchedulerPort {
  RemindersNotificationService({required Logger logger}) : _logger = logger;

  final Logger _logger;
  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  static const String _channelId = 'reminders';
  static const String actionDone = 'DONE';
  static const String actionSnooze = 'SNOOZE';

  bool _ready = false;
  String? _dbPath;

  static final StreamController<ReminderNotificationIntent> _intents =
      StreamController<ReminderNotificationIntent>.broadcast();

  /// Поток намерений для UI (тап по пушу / экшен в открытом app).
  static Stream<ReminderNotificationIntent> get intents => _intents.stream;

  @override
  Future<void> ensureReady() async {
    if (_ready) return;
    _ready = true;
    try {
      tzdata.initializeTimeZones();
      try {
        final tzInfo = await FlutterTimezone.getLocalTimezone();
        tz.setLocalLocation(tz.getLocation(tzInfo.identifier));
      } catch (e) {
        _logger.w('Timezone detection failed, keep default location: $e');
      }
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
      await android?.createNotificationChannel(
        const AndroidNotificationChannel(
          _channelId,
          'Напоминания',
          description: 'Напоминания о платежах и событиях',
          importance: Importance.high,
        ),
      );
      try {
        final dir = await getApplicationDocumentsDirectory();
        _dbPath =
            '${dir.path}${Platform.pathSeparator}budget_assistant.sqlite';
      } catch (e) {
        _logger.w('DB path for payload unavailable: $e');
      }
      _logger.i('RemindersNotificationService ready');
    } catch (e, st) {
      _ready = false;
      _logger.e('Notification init failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<bool> requestPermissions() async {
    try {
      final android = _plugin.resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();
      if (android == null) return true;
      final granted = await android.requestNotificationsPermission() ?? false;
      try {
        await android.requestExactAlarmsPermission();
      } catch (e) {
        _logger.w('Exact alarms permission request failed: $e');
      }
      return granted;
    } catch (e, st) {
      _logger.e('requestPermissions failed', error: e, stackTrace: st);
      return false;
    }
  }

  @override
  Future<void> scheduleReminder(
    Reminder reminder,
    List<DateTime> occurrencesUtc,
  ) async {
    try {
      await ensureReady();
      await cancelReminder(reminder.id);
      const details = AndroidNotificationDetails(
        _channelId,
        'Напоминания',
        channelDescription: 'Напоминания о платежах и событиях',
        importance: Importance.high,
        priority: Priority.high,
        actions: [
          AndroidNotificationAction(actionDone, 'Выполнено',
              showsUserInterface: false),
          AndroidNotificationAction(actionSnooze, 'Отложить'),
        ],
      );
      int index = 0;
      for (final occ in occurrencesUtc.take(3)) {
        final scheduled = tz.TZDateTime.from(occ.toLocal(), tz.local);
        await _plugin.zonedSchedule(
          id: _stableId(reminder.id, index),
          title: reminder.title,
          body: _body(reminder),
          scheduledDate: scheduled,
          notificationDetails: const NotificationDetails(android: details),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          payload: jsonEncode({
            'reminderId': reminder.id,
            'index': index,
            if (_dbPath != null) 'dbPath': _dbPath,
          }),
        );
        index++;
      }
    } catch (e, st) {
      _logger.e('scheduleReminder failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> cancelReminder(String reminderId) async {
    try {
      for (int i = 0; i < 3; i++) {
        await _plugin.cancel(id: _stableId(reminderId, i));
      }
    } catch (e, st) {
      _logger.w('cancelReminder failed: $e', error: e, stackTrace: st);
    }
  }

  void _onForegroundResponse(NotificationResponse response) {
    try {
      final intent = _parseIntent(response);
      if (intent != null) _intents.add(intent);
    } catch (e, st) {
      _logger.e('Foreground response parse failed', error: e, stackTrace: st);
    }
  }

  ReminderNotificationIntent? _parseIntent(NotificationResponse response) {
    if (response.payload == null) return null;
    final map = jsonDecode(response.payload!) as Map<String, dynamic>;
    final reminderId = map['reminderId'] as String?;
    if (reminderId == null) return null;
    return ReminderNotificationIntent(
      actionId: response.actionId,
      reminderId: reminderId,
    );
  }

  String _body(Reminder reminder) {
    final amount = reminder.expectedAmount;
    if (amount == null) return 'Напоминание';
    final rub = amount ~/ 100;
    return 'Ожидаемая сумма: $rub ₽';
  }

  /// Детерминированный id PendingIntent (стабилен между запусками).
  int _stableId(String reminderId, int index) {
    var h = 0;
    for (final c in reminderId.codeUnits) {
      h = (h * 31 + c) & 0x7fffffff;
    }
    return (h + index * 7919) % 1000000007;
  }
}

/// Background-изолят: экшен «Выполнено» без открытия app.
/// Пишем в БД напрямую (drift = FFI, platform channels не нужны),
/// путь БД приходит в payload уведомления.
@pragma('vm:entry-point')
void onBackgroundResponse(NotificationResponse response) async {
  if (response.actionId != RemindersNotificationService.actionDone) return;
  try {
    final payload =
        jsonDecode(response.payload ?? '{}') as Map<String, dynamic>;
    final dbPath = payload['dbPath'] as String?;
    final reminderId = payload['reminderId'] as String?;
    if (dbPath == null || reminderId == null) return;
    final db = AppDatabase.forBackground(NativeDatabase(File(dbPath)));
    final now = DateTime.now().toUtc();
    await (db.update(db.reminders)..where((t) => t.id.equals(reminderId)))
        .write(
      RemindersCompanion(
        isCompleted: const Value(true),
        completedAt: Value(now),
        updatedAt: Value(now),
        syncStatus: const Value(SyncStatus.pending),
      ),
    );
    await db.close();
    AppLogger.i('Background DONE applied: $reminderId');
  } catch (e) {
    AppLogger.e('Background DONE failed: $e');
  }
}