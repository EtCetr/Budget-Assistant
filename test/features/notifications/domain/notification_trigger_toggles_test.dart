import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/features/notifications/domain/models/notification_type.dart';
import 'package:budget_assistant/features/notifications/domain/usecases/notification_triggers_usecase.dart';
import '../../../helpers/sqlite_probe.dart';
import '../../../helpers/test_db.dart';

/// Этап 24 (D24-78): per-type тумблеры обязаны подавлять КАЖДЫЙ не-alwaysOn
/// тип, а не только три типа лимитов. Глобальные тумблеры групп — тоже.
void main() {
  final skip = sqliteSkipReason();

  group('Тумблеры типов пушей (in-memory)', () {
    late AppDatabase db;
    late TestSeed seed;
    late NotificationTriggersUseCase useCase;

    final now = DateTime(2026, 7, 15, 12);

    Future<void> sql(String statement, List<Object?> args) =>
        db.customStatement(statement, args);

    Future<void> off(NotificationType type) => sql(
          'UPDATE app_settings SET notification_settings_json = ? '
          'WHERE user_id = ?',
          [jsonEncode({type.dbValue: false}), kUserId],
        );

    Future<List<NotificationType>> typesAt([DateTime? at]) async {
      final r = await useCase.evaluate(kUserId, at ?? now);
      return r.map((e) => e.type).toList();
    }

    setUp(() async {
      db = openTestDb();
      seed = TestSeed(db);
      await seed.base();
      await db.appSettingsDao.getForUser(kUserId);
      useCase = NotificationTriggersUseCase(db);
    });

    tearDown(() async {
      await db.close();
    });

    test('выключенные вехи целей не пушатся', () async {
      await db.into(db.savingsGoals).insert(SavingsGoalsCompanion(
            id: const Value('g1'),
            userId: const Value(kUserId),
            name: const Value('Отпуск'),
            targetAmount: const Value(100000),
            currentAmount: const Value(90000),
            status: const Value('active'),
            isArchived: const Value(false),
            createdAt: Value(now.toUtc()),
            updatedAt: Value(now.toUtc()),
          ));
      expect(await typesAt(), contains(NotificationType.goalMilestone));

      await off(NotificationType.goalMilestone);

      expect(await typesAt(), isNot(contains(NotificationType.goalMilestone)));
    });

    test('выключенный непривязанный чек не пушится', () async {
      await db.into(db.receipts).insert(ReceiptsCompanion(
            id: const Value('rec1'),
            userId: const Value(kUserId),
            storeName: const Value('Пятёрочка'),
            totalAmount: const Value(10000),
            receiptDate: Value(now.toUtc()),
            status: const Value('draft'),
            currency: const Value('RUB'),
            createdAt: Value(now.subtract(const Duration(hours: 25))),
            updatedAt: Value(now.toUtc()),
          ));
      expect(await typesAt(), contains(NotificationType.unmatchedReceipt));

      await off(NotificationType.unmatchedReceipt);

      expect(
        await typesAt(),
        isNot(contains(NotificationType.unmatchedReceipt)),
      );
    });

    test('выключенное напоминание о выписке не пушится 25-го', () async {
      final day25 = DateTime(2026, 7, 25, 12);
      expect(
        await typesAt(day25),
        contains(NotificationType.bankStatementReminder),
      );

      await off(NotificationType.bankStatementReminder);

      expect(
        await typesAt(day25),
        isNot(contains(NotificationType.bankStatementReminder)),
      );
    });

    test('выключенный годовой отчёт не пушится после 27 декабря', () async {
      await db.into(db.yearlyAggregates).insert(
            YearlyAggregatesCompanion.insert(
              id: 'ya1',
              userId: kUserId,
              year: 2026,
              dataJson: '{}',
              isViewed: const Value(false),
              lastCalculatedAt: now.toUtc(),
            ),
          );
      final dec27 = DateTime(2026, 12, 27, 12);
      expect(await typesAt(dec27), contains(NotificationType.yearReviewReady));

      await off(NotificationType.yearReviewReady);

      expect(
        await typesAt(dec27),
        isNot(contains(NotificationType.yearReviewReady)),
      );
    });

    test('глобальный тумблер напоминаний гасит тип даже при включённом per-type',
        () async {
      await db.into(db.reminders).insert(RemindersCompanion(
            id: const Value('r1'),
            userId: const Value(kUserId),
            title: const Value('Оплатить интернет'),
            remindAt: Value(now.add(const Duration(hours: 2))),
            createdAt: Value(now.toUtc()),
            updatedAt: Value(now.toUtc()),
          ));
      await sql(
        'UPDATE app_settings SET notification_settings_json = ? '
        'WHERE user_id = ?',
        [jsonEncode({NotificationType.reminderDue.dbValue: true}), kUserId],
      );
      expect(await typesAt(), contains(NotificationType.reminderDue));

      await sql(
        'UPDATE app_settings SET enable_reminder_notifications = 0 '
        'WHERE user_id = ?',
        [kUserId],
      );

      expect(await typesAt(), isNot(contains(NotificationType.reminderDue)));
    });

    test('alwaysOn тип пушится даже с выключенным тумблером', () async {
      await db.into(db.syncConflicts).insert(SyncConflictsCompanion.insert(
            id: 'sc1',
            entityType: 'accounts',
            entityId: kAccountId,
            localValue: '{}',
            remoteValue: '{}',
            createdAt: now.toUtc(),
          ));
      await off(NotificationType.syncConflictManual);

      expect(
        await typesAt(),
        contains(NotificationType.syncConflictManual),
      );
    });
  }, skip: skip);
}