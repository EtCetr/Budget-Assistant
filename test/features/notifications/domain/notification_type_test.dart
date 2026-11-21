import 'package:flutter_test/flutter_test.dart';
import 'package:budget_assistant/features/notifications/domain/models/notification_type.dart';

/// Этап 24: матрица типов и каналов (ТОМ 5 §2 / §4.4, D18-2).
/// 27 пушей + 3 дайджеста = 30 значений; 4 канала Android.
void main() {
  test('30 типов: 27 пушей и 3 дайджеста', () {
    expect(NotificationType.values.length, 30);
    const digests = {
      NotificationType.dailyDigest,
      NotificationType.weeklyDigest,
      NotificationType.monthlyDigest,
    };
    expect(
      NotificationType.values.where((t) => !digests.contains(t)).length,
      27,
    );
  });

  test('4 канала с id, названием и описанием', () {
    expect(NotificationChannel.values.length, 4);
    for (final c in NotificationChannel.values) {
      expect(c.id, startsWith('channel_'));
      expect(c.title, isNotEmpty);
      expect(c.description, isNotEmpty);
    }
    expect(
      NotificationChannel.values.map((c) => c.id).toSet().length,
      4,
    );
  });

  test('распределение типов по каналам', () {
    final counts = <NotificationChannel, int>{};
    for (final t in NotificationType.values) {
      counts[t.channel] = (counts[t.channel] ?? 0) + 1;
    }

    expect(counts[NotificationChannel.budget], 13);
    expect(counts[NotificationChannel.reminders], 6);
    expect(counts[NotificationChannel.importReceipts], 7);
    expect(counts[NotificationChannel.systemSync], 4);
  });

  test('alwaysOn ровно 4 типа — без тумблера в настройках', () {
    final alwaysOn = NotificationType.values
        .where((t) => t.alwaysOn)
        .toSet();

    expect(alwaysOn, {
      NotificationType.duplicateReceipt,
      NotificationType.holdConfirmed,
      NotificationType.recurringDetected,
      NotificationType.syncConflictManual,
    });
  });

  test('critical ровно 2 типа — без дедупликации 24ч', () {
    final critical = NotificationType.values
        .where((t) => t.critical)
        .toSet();

    expect(critical, {
      NotificationType.deficitForecastWarning,
      NotificationType.syncConflictManual,
    });
  });

  test('dbValue совпадает с именем enum (ключ в БД)', () {
    for (final t in NotificationType.values) {
      expect(t.dbValue, t.name);
    }
  });

  test('channelId берётся из канала', () {
    for (final t in NotificationType.values) {
      expect(t.channelId, t.channel.id);
    }
  });

  test('label заполнен и уникален для каждого типа', () {
    final labels = <String>{};
    for (final t in NotificationType.values) {
      expect(t.label, isNotEmpty, reason: 'нет label у ${t.name}');
      labels.add(t.label);
    }
    expect(labels.length, NotificationType.values.length);
  });

  test('fromDb восстанавливает тип по имени', () {
    expect(
      NotificationType.fromDb('goalMilestone'),
      NotificationType.goalMilestone,
    );
    expect(
      NotificationType.fromDb('syncConflictManual'),
      NotificationType.syncConflictManual,
    );
  });

  test('fromDb: null и неизвестное значение — reminderDue', () {
    expect(NotificationType.fromDb(null), NotificationType.reminderDue);
    expect(NotificationType.fromDb('мусор'), NotificationType.reminderDue);
    // legacy snake_case не распознаётся — фолбэк на напоминание.
    expect(
      NotificationType.fromDb('goal_milestone'),
      NotificationType.reminderDue,
    );
  });

  test('дайджесты идут в канал напоминаний', () {
    expect(NotificationType.dailyDigest.channel, NotificationChannel.reminders);
    expect(NotificationType.weeklyDigest.channel, NotificationChannel.reminders);
    expect(
      NotificationType.monthlyDigest.channel,
      NotificationChannel.reminders,
    );
  });
}