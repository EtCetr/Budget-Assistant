import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/features/notifications/domain/models/notification_type.dart';
import 'package:budget_assistant/features/notifications/domain/usecases/notification_triggers_usecase.dart';
import '../../../helpers/sqlite_probe.dart';
import '../../../helpers/test_db.dart';

/// Этап 24: матрица триггеров пушей (ТОМ 5 §2).
/// evaluate(userId, now) читает локальную БД; каждый блок в своём try/catch.
///
/// Настройки правятся raw SQL по именам колонок из запросов UseCase —
/// Dart-геттеры app_settings не угадываем.
/// Хелперы объявлены ДО setUp: локальные функции нельзя вызывать раньше
/// объявления (referenced_before_declaration).
void main() {
  final skip = sqliteSkipReason();

  group('NotificationTriggersUseCase (in-memory)', () {
    late AppDatabase db;
    late TestSeed seed;
    late NotificationTriggersUseCase useCase;

    // 15.07.2026 — среда; для банковского напоминания нужен 25-й день.
    final now = DateTime(2026, 7, 15, 12);

    Future<void> member({
      required String id,
      required String userId,
      String role = 'member',
      String status = 'active',
      DateTime? lastActiveAt,
      DateTime? joinedAt,
    }) async {
      await db.into(db.memberships).insert(MembershipsCompanion.insert(
            id: id,
            userId: userId,
            spaceId: kSpaceId,
            joinedAt: joinedAt ?? now.subtract(const Duration(days: 60)),
            role: Value(role),
            status: Value(status),
            lastActiveAt: Value(lastActiveAt),
          ));
    }

    Future<void> sql(String statement, List<Object?> args) =>
        db.customStatement(statement, args);

    Future<List<NotificationTriggerResult>> run([DateTime? at]) =>
        useCase.evaluate(kUserId, at ?? now);

    List<NotificationType> typesOf(List<NotificationTriggerResult> r) =>
        r.map((e) => e.type).toList();

    setUp(() async {
      db = openTestDb();
      seed = TestSeed(db);
      await seed.base();
      await db.appSettingsDao.getForUser(kUserId);
      await member(id: 'm-me', userId: kUserId);
      useCase = NotificationTriggersUseCase(db);
    });

    tearDown(() async {
      await db.close();
    });

    group('Глобальный лимит пространства', () {
      Future<void> limitSpace({required int limit, required int spent}) async {
        await sql('UPDATE spaces SET monthly_budget_limit = ? WHERE id = ?',
            [limit, kSpaceId]);
        await seed.tx(
          id: 'sp1',
          amountKopecks: spent,
          categoryId: 'c1',
          spaceId: kSpaceId,
          date: DateTime(2026, 7, 10, 12),
        );
      }

      test('80% бюджета — предупреждение с дедупом 3 дня', () async {
        await limitSpace(limit: 1000000, spent: 800000);

        final hit = (await run()).firstWhere(
          (e) => e.type == NotificationType.limitGlobalPercent,
        );

        expect(hit.title, contains('80%'));
        expect(hit.spaceId, kSpaceId);
        expect(hit.dedupDays, 3);
      });

      test('ниже порога — предупреждения нет', () async {
        await limitSpace(limit: 1000000, spent: 500000);

        expect(
          typesOf(await run()),
          isNot(contains(NotificationType.limitGlobalPercent)),
        );
      });

      test('режим global_amount переключает тип предупреждения', () async {
        await limitSpace(limit: 1000000, spent: 800000);
        await sql(
          'UPDATE app_settings SET limit_alert_mode = ?, '
          'global_alert_amount = ? WHERE user_id = ?',
          ['global_amount', 300000, kUserId],
        );

        final types = typesOf(await run());
        expect(types, contains(NotificationType.limitGlobalAmount));
        expect(types, isNot(contains(NotificationType.limitGlobalPercent)));
      });

      test('лимит не задан — блок пропускается', () async {
        await seed.tx(
          id: 'sp1',
          amountKopecks: 800000,
          categoryId: 'c1',
          spaceId: kSpaceId,
          date: DateTime(2026, 7, 10, 12),
        );

        expect(
          typesOf(await run()),
          isNot(contains(NotificationType.limitGlobalPercent)),
        );
      });
    });

    group('Лимит категории', () {
      test('достижение alert_percent — предупреждение', () async {
        await seed.limit(
          id: 'l1',
          categoryId: 'c1',
          year: 2026,
          month: 7,
          kopecks: 100000,
        );
        await sql('UPDATE budget_limits SET alert_percent = ? WHERE id = ?',
            [80, 'l1']);
        await seed.tx(
          id: 't1',
          amountKopecks: 80000,
          categoryId: 'c1',
          date: DateTime(2026, 7, 10, 12),
        );

        final r = await run();
        expect(typesOf(r), contains(NotificationType.limitIndividual));
        expect(
          r.firstWhere((e) => e.type == NotificationType.limitIndividual).title,
          contains('Продукты'),
        );
      });

      test('ниже порога — предупреждения нет', () async {
        await seed.limit(
          id: 'l1',
          categoryId: 'c1',
          year: 2026,
          month: 7,
          kopecks: 100000,
        );
        await sql('UPDATE budget_limits SET alert_percent = ? WHERE id = ?',
            [80, 'l1']);
        await seed.tx(
          id: 't1',
          amountKopecks: 10000,
          categoryId: 'c1',
          date: DateTime(2026, 7, 10, 12),
        );

        expect(
          typesOf(await run()),
          isNot(contains(NotificationType.limitIndividual)),
        );
      });
    });

    group('Прогноз дефицита', () {
      Future<void> forecast(int amount) async {
        await db.into(db.forecastCache).insert(ForecastCacheCompanion(
              id: const Value('f1'),
              userId: const Value(kUserId),
              monthYear: const Value('2026-07'),
              forecastedAmount: Value(amount),
              updatedAt: Value(now.toUtc()),
            ));
      }

      test('отрицательный total — предупреждение с дедупом 7 дней', () async {
        await forecast(-50000);

        final hit = (await run()).firstWhere(
          (e) => e.type == NotificationType.deficitForecastWarning,
        );
        expect(hit.entityId, 'deficit:2026-07');
        expect(hit.dedupDays, 7);
      });

      test('положительный прогноз — предупреждения нет', () async {
        await forecast(50000);

        expect(
          typesOf(await run()),
          isNot(contains(NotificationType.deficitForecastWarning)),
        );
      });
    });

    group('Напоминания', () {
      Future<void> reminder({
        required String id,
        required DateTime at,
        int? amount,
        String? snooze,
        DateTime? completedAt,
      }) async {
        await db.into(db.reminders).insert(RemindersCompanion(
              id: Value(id),
              userId: const Value(kUserId),
              title: const Value('Оплатить интернет'),
              remindAt: Value(at),
              expectedAmount: Value(amount),
              snoozeHistory: Value(snooze),
              completedAt: Value(completedAt),
              createdAt: Value(now.toUtc()),
              updatedAt: Value(now.toUtc()),
            ));
      }

      test('срок в окне суток — пуш с entityId id:дата', () async {
        final at = now.add(const Duration(hours: 2));
        await reminder(id: 'r1', at: at, amount: 90000);

        final hit = (await run())
            .firstWhere((e) => e.type == NotificationType.reminderDue);
        expect(hit.entityId, 'r1:${at.year}-${at.month}-${at.day}');
        expect(hit.body, contains('900'));
      });

      test('завершённое напоминание не пушится', () async {
        await reminder(
          id: 'r1',
          at: now.add(const Duration(hours: 2)),
          completedAt: now.toUtc(),
        );

        expect(
          typesOf(await run()),
          isNot(contains(NotificationType.reminderDue)),
        );
      });

      test('три откладывания — предупреждение о спаме', () async {
        await reminder(
          id: 'r1',
          at: now.add(const Duration(days: 30)),
          snooze: jsonEncode([1, 2, 3]),
        );

        final hit = (await run())
            .firstWhere((e) => e.type == NotificationType.reminderSnoozeWarning);
        expect(hit.entityId, 'r1:snooze');
        expect(hit.dedupDays, 7);
      });
    });

    test('свежая подписка — пуш даже без тумблера (alwaysOn)', () async {
      await db.into(db.recurringTransactions).insert(
            RecurringTransactionsCompanion(
              id: const Value('rec1'),
              userId: const Value(kUserId),
              merchantName: const Value('NETFLIX.COM'),
              merchantNameNormalized: const Value('netflix com'),
              averageAmount: const Value(99900),
              averageAmountBucket: const Value(100000),
              averageDayOfMonth: const Value(15),
              detectedAt: Value(now.subtract(const Duration(hours: 1))),
              createdAt: Value(now.toUtc()),
              updatedAt: Value(now.toUtc()),
            ),
          );
      await sql(
        'UPDATE app_settings SET notification_settings_json = ? WHERE user_id = ?',
        [
          jsonEncode({NotificationType.recurringDetected.dbValue: false}),
          kUserId,
        ],
      );

      final hit = (await run())
          .firstWhere((e) => e.type == NotificationType.recurringDetected);
      expect(hit.title, contains('netflix com'));
      expect(hit.dedupDays, 30);
    });

    test('праздник через secrecy_days — старт режима секретности', () async {
      await sql(
        'UPDATE app_settings SET enable_secrecy_mode = 1, '
        'secrecy_days_before = ? WHERE user_id = ?',
        [14, kUserId],
      );
      await db.into(db.holidays).insert(HolidaysCompanion(
            id: const Value('h1'),
            userId: const Value(kUserId),
            name: const Value('День рождения'),
            date: Value(DateTime(2026, 7, 29, 12)),
            isAnnuallyRecurring: const Value(false),
            isPreset: const Value(false),
            isEnabled: const Value(true),
            createdAt: Value(now.toUtc()),
            updatedAt: Value(now.toUtc()),
          ));

      final hit = (await run())
          .firstWhere((e) => e.type == NotificationType.holidaySecrecyStart);
      expect(hit.body, contains('День рождения'));
      expect(hit.dedupDays, 300);
    });

    test('крупная покупка за сутки — предложение засекретить', () async {
      final realNow = DateTime.now();
      await seed.tx(
        id: 'big',
        amountKopecks: 500000,
        categoryId: 'c1',
        isLargeExpense: true,
      );

      final hit = (await run(realNow))
          .firstWhere((e) => e.type == NotificationType.giftPurchaseAlert);
      expect(hit.entityId, 'big');
      expect(hit.body, contains('Засекретить'));
    });

    group('Цели', () {
      Future<void> goal({
        required int current,
        DateTime? deadline,
      }) async {
        await db.into(db.savingsGoals).insert(SavingsGoalsCompanion(
              id: const Value('g1'),
              userId: const Value(kUserId),
              name: const Value('Отпуск'),
              targetAmount: const Value(100000),
              currentAmount: Value(current),
              status: const Value('active'),
              isArchived: const Value(false),
              deadline: Value(deadline),
              createdAt: Value(now.toUtc()),
              updatedAt: Value(now.toUtc()),
            ));
      }

      test('90% — три вехи 50/75/90', () async {
        await goal(current: 90000);

        final milestones = (await run())
            .where((e) => e.type == NotificationType.goalMilestone)
            .toList();

        expect(milestones.length, 3);
        expect(
          milestones.map((e) => e.entityId).toSet(),
          {'g1:50', 'g1:75', 'g1:90'},
        );
      });

      test('дедлайн через 3 дня — предупреждение о сроке', () async {
        await goal(
          current: 10000,
          deadline: now.add(const Duration(days: 3)),
        );

        final types = typesOf(await run());
        expect(types, contains(NotificationType.goalDeadlineApproaching));
        expect(types, isNot(contains(NotificationType.goalMilestone)));
      });
    });

    group('Активность группы', () {
      test('админ не заходил 20 дней — heartbeat-предупреждение', () async {
        await seed.user(kOtherUserId);
        await member(
          id: 'm-admin',
          userId: kOtherUserId,
          role: 'admin',
          lastActiveAt: now.subtract(const Duration(days: 20)),
        );

        final hit = (await run())
            .firstWhere((e) => e.type == NotificationType.adminHeartbeatWarning);
        expect(hit.spaceId, kSpaceId);
        expect(hit.dedupDays, 14);
      });

      test('участник присоединился час назад — пуш об активности', () async {
        await seed.user(kOtherUserId);
        await member(
          id: 'm-new',
          userId: kOtherUserId,
          joinedAt: now.subtract(const Duration(hours: 1)),
          lastActiveAt: now,
        );

        final hit = (await run())
            .firstWhere((e) => e.type == NotificationType.memberActivity);
        expect(hit.entityId, '$kOtherUserId:join');
      });
    });

    group('Конфликты синхронизации', () {
      Future<void> conflict({required String id, DateTime? resolvedAt}) async {
        await db.into(db.syncConflicts).insert(SyncConflictsCompanion.insert(
              id: id,
              entityType: 'accounts',
              entityId: kAccountId,
              localValue: '{}',
              remoteValue: '{}',
              createdAt: now.toUtc(),
              resolvedAt: Value(resolvedAt),
            ));
      }

      test('неразрешённый конфликт пушится даже без тумблера (alwaysOn)',
          () async {
        await conflict(id: 'sc1');
        await sql(
          'UPDATE app_settings SET notification_settings_json = ? '
          'WHERE user_id = ?',
          [
            jsonEncode({NotificationType.syncConflictManual.dbValue: false}),
            kUserId,
          ],
        );

        final hit = (await run())
            .firstWhere((e) => e.type == NotificationType.syncConflictManual);
        expect(hit.entityId, 'sc1');
        expect(hit.dedupDays, 7);
      });

      test('разрешённый конфликт не пушится', () async {
        await conflict(id: 'sc1', resolvedAt: now.toUtc());

        expect(
          typesOf(await run()),
          isNot(contains(NotificationType.syncConflictManual)),
        );
      });
    });

    group('Годовой отчёт', () {
      Future<void> aggregate({
        required String id,
        String? spaceId,
        bool viewed = false,
      }) async {
        await db.into(db.yearlyAggregates).insert(
              YearlyAggregatesCompanion.insert(
                id: id,
                userId: kUserId,
                spaceId: Value(spaceId),
                year: 2026,
                dataJson: '{}',
                isViewed: Value(viewed),
                lastCalculatedAt: now.toUtc(),
              ),
            );
      }

      test('27 декабря, личный отчёт не просмотрен — пуш', () async {
        await aggregate(id: 'ya1');

        final hit = (await run(DateTime(2026, 12, 27, 12)))
            .firstWhere((e) => e.type == NotificationType.yearReviewReady);
        expect(hit.entityId, 'year_review:2026');
        expect(hit.dedupDays, 300);
      });

      test('просмотренный отчёт не пушится', () async {
        await aggregate(id: 'ya1', viewed: true);

        expect(
          typesOf(await run(DateTime(2026, 12, 27, 12))),
          isNot(contains(NotificationType.yearReviewReady)),
        );
      });

      test('до 27 декабря пуша нет', () async {
        await aggregate(id: 'ya1');

        expect(
          typesOf(await run(DateTime(2026, 12, 26, 12))),
          isNot(contains(NotificationType.yearReviewReady)),
        );
      });

      test('семейный отчёт не считается личным', () async {
        await aggregate(id: 'ya1', spaceId: kSpaceId);

        expect(
          typesOf(await run(DateTime(2026, 12, 27, 12))),
          isNot(contains(NotificationType.yearReviewReady)),
        );
      });
    });

    test('чек-черновик старше суток — напоминание привязать', () async {
      await db.into(db.receipts).insert(ReceiptsCompanion(
            id: const Value('rec-draft'),
            userId: const Value(kUserId),
            storeName: const Value('Пятёрочка'),
            totalAmount: const Value(10000),
            receiptDate: Value(now.toUtc()),
            status: const Value('draft'),
            currency: const Value('RUB'),
            createdAt: Value(now.subtract(const Duration(hours: 25))),
            updatedAt: Value(now.toUtc()),
          ));

      final hit = (await run())
          .firstWhere((e) => e.type == NotificationType.unmatchedReceipt);
      expect(hit.entityId, 'rec-draft');
      expect(hit.dedupDays, 3);
    });

    test('25-е число без импорта — напоминание о выписке', () async {
      final hit = (await run(DateTime(2026, 7, 25, 12)))
          .firstWhere((e) => e.type == NotificationType.bankStatementReminder);
      expect(hit.entityId, '2026-7');
      expect(hit.dedupDays, 29);
    });

    test('выключенный тип в настройках подавляет пуш', () async {
      await db.into(db.reminders).insert(RemindersCompanion(
            id: const Value('r1'),
            userId: const Value(kUserId),
            title: const Value('Оплатить интернет'),
            remindAt: Value(now.add(const Duration(hours: 2))),
            createdAt: Value(now.toUtc()),
            updatedAt: Value(now.toUtc()),
          ));
      await sql(
        'UPDATE app_settings SET notification_settings_json = ? WHERE user_id = ?',
        [jsonEncode({NotificationType.reminderDue.dbValue: false}), kUserId],
      );

      expect(
        typesOf(await run()),
        isNot(contains(NotificationType.reminderDue)),
      );
    });
  }, skip: skip);
}