import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import 'package:budget_assistant/features/notifications/domain/models/notification_type.dart';
import 'package:budget_assistant/features/notifications/domain/usecases/handle_notification_action_usecase.dart';
import '../../../helpers/sqlite_probe.dart';
import '../../../helpers/test_db.dart';

/// Этап 24: действия из пуша (ТОМ 5 §3.2).
/// «Подтвердить» у подарка скрывает покупку на 30 дней,
/// у напоминания — завершает его. Идемпотентно.
///
/// D24-73: тип принимается и как NotificationType.dbValue (camelCase),
/// и как legacy snake_case.
/// D24-74: entityId = 'id:суффикс' — берётся часть ДО двоеточия.
/// reminders.sync_status — `textEnum<SyncStatus>` (не строка, как в чеках).
void main() {
  final skip = sqliteSkipReason();

  group('HandleNotificationActionUseCase (in-memory)', () {
    late AppDatabase db;
    late TestSeed seed;
    late HandleNotificationActionUseCase useCase;

    setUp(() async {
      db = openTestDb();
      seed = TestSeed(db);
      await seed.base();
      useCase = HandleNotificationActionUseCase(db);
      await db.into(db.notifications).insert(NotificationsCompanion.insert(
            id: 'n1',
            userId: kUserId,
            type: NotificationType.giftPurchaseAlert.dbValue,
            title: 'Крупная покупка',
            body: 'Засекретить?',
          ));
    });

    tearDown(() async {
      await db.close();
    });

    Future<void> addReminder(String id) async {
      final now = DateTime.now().toUtc();
      await db.into(db.reminders).insert(RemindersCompanion(
            id: Value(id),
            userId: const Value(kUserId),
            title: const Value('Оплатить интернет'),
            remindAt: Value(now),
            createdAt: Value(now),
            updatedAt: Value(now),
          ));
    }

    Future<bool> readFlag() async {
      final row = await (db.select(db.notifications)
            ..where((n) => n.id.equals('n1')))
          .getSingle();
      return row.isRead;
    }

    Future<String?> actionTaken() async {
      final row = await (db.select(db.notifications)
            ..where((n) => n.id.equals('n1')))
          .getSingle();
      return row.actionTaken;
    }

    test('dismiss отмечает прочитанным без бизнес-логики', () async {
      await seed.tx(id: 't1', amountKopecks: 100000, categoryId: 'c1');

      await useCase(
        notificationId: 'n1',
        action: 'dismissed',
        type: NotificationType.giftPurchaseAlert.dbValue,
        entityId: 't1',
      );

      expect(await readFlag(), isTrue);
      expect(await actionTaken(), 'dismissed');
      final t = await (db.select(db.transactions)
            ..where((x) => x.id.equals('t1')))
          .getSingle();
      expect(t.isHiddenByCalendar, isFalse);
    });

    test('подтверждение подарка скрывает покупку на 30 дней (camelCase)',
        () async {
      await seed.tx(id: 't1', amountKopecks: 100000, categoryId: 'c1');
      final before = DateTime.now().toUtc();

      await useCase(
        notificationId: 'n1',
        action: 'confirmed',
        type: NotificationType.giftPurchaseAlert.dbValue,
        entityId: 't1',
      );

      final t = await (db.select(db.transactions)
            ..where((x) => x.id.equals('t1')))
          .getSingle();
      expect(t.isHiddenByCalendar, isTrue);
      expect(t.syncStatus, SyncStatus.pending);
      final days = t.hiddenUntilDate!.toUtc().difference(before).inDays;
      expect(days, inInclusiveRange(29, 30));
    });

    test('legacy snake_case тип тоже выполняет бизнес-логику', () async {
      await seed.tx(id: 't1', amountKopecks: 100000, categoryId: 'c1');

      await useCase(
        notificationId: 'n1',
        action: 'confirmed',
        type: 'gift_purchase_alert',
        entityId: 't1',
      );

      final t = await (db.select(db.transactions)
            ..where((x) => x.id.equals('t1')))
          .getSingle();
      expect(t.isHiddenByCalendar, isTrue);
    });

    test('подтверждение напоминания завершает его', () async {
      await addReminder('r1');

      await useCase(
        notificationId: 'n1',
        action: 'confirmed',
        type: NotificationType.reminderDue.dbValue,
        entityId: 'r1',
      );

      final r = await (db.select(db.reminders)
            ..where((x) => x.id.equals('r1')))
          .getSingle();
      expect(r.completedAt, isNotNull);
      expect(r.syncStatus, SyncStatus.pending);
    });

    test('entityId = id:суффикс — берётся часть ДО двоеточия (D24-74)',
        () async {
      await addReminder('r1');

      await useCase(
        notificationId: 'n1',
        action: 'confirmed',
        type: NotificationType.reminderDue.dbValue,
        entityId: 'r1:2026-7-15',
      );

      final r = await (db.select(db.reminders)
            ..where((x) => x.id.equals('r1')))
          .getSingle();
      expect(r.completedAt, isNotNull);
    });

    test('суффикс snooze тоже отбрасывается', () async {
      await addReminder('r1');

      await useCase(
        notificationId: 'n1',
        action: 'confirmed',
        type: NotificationType.reminderDue.dbValue,
        entityId: 'r1:snooze',
      );

      final r = await (db.select(db.reminders)
            ..where((x) => x.id.equals('r1')))
          .getSingle();
      expect(r.completedAt, isNotNull);
    });

    test('неизвестный тип: только отметка о прочтении', () async {
      await seed.tx(id: 't1', amountKopecks: 100000, categoryId: 'c1');

      await useCase(
        notificationId: 'n1',
        action: 'confirmed',
        type: 'unknown_type',
        entityId: 't1',
      );

      expect(await readFlag(), isTrue);
      final t = await (db.select(db.transactions)
            ..where((x) => x.id.equals('t1')))
          .getSingle();
      expect(t.isHiddenByCalendar, isFalse);
    });

    test('повторное подтверждение идемпотентно', () async {
      await addReminder('r1');

      await useCase(
        notificationId: 'n1',
        action: 'confirmed',
        type: NotificationType.reminderDue.dbValue,
        entityId: 'r1',
      );
      final first = await (db.select(db.reminders)
            ..where((x) => x.id.equals('r1')))
          .getSingle();

      await useCase(
        notificationId: 'n1',
        action: 'confirmed',
        type: NotificationType.reminderDue.dbValue,
        entityId: 'r1',
      );
      final second = await (db.select(db.reminders)
            ..where((x) => x.id.equals('r1')))
          .getSingle();

      expect(second.completedAt, isNotNull);
      expect(
        second.completedAt!.isAtSameMomentAs(first.completedAt!),
        isTrue,
      );
    });

    test('markAsRead отмечает прочитанным без действия', () async {
      await useCase.markAsRead('n1');

      expect(await readFlag(), isTrue);
      expect(await actionTaken(), isNull);
    });

    test('несуществующий id не роняет обработку', () async {
      await useCase.markAsRead('missing');

      await useCase(
        notificationId: 'missing',
        action: 'confirmed',
        type: NotificationType.reminderDue.dbValue,
        entityId: 'nope',
      );

      expect(await readFlag(), isFalse);
    });
  }, skip: skip);
}