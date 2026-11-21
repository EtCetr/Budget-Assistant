import 'dart:convert';

import 'package:drift/drift.dart' show Value;
import 'package:flutter_test/flutter_test.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import 'package:budget_assistant/features/notifications/domain/models/notification_type.dart';
import 'package:budget_assistant/features/notifications/domain/usecases/generate_daily_digest_usecase.dart';
import '../../../helpers/sqlite_probe.dart';
import '../../../helpers/test_db.dart';

/// Этап 24: дайджесты (ТОМ 5 §4.2–4.3).
/// День / неделя (воскресенье) / месяц (1-е число), не раньше настроенного часа.
/// Нулевые блоки исключаются; пустой дайджест не отправляется.
///
/// D24-75: типы уведомлений собираются в обеих формах — camelCase (dbValue)
/// и legacy snake_case.
void main() {
  final skip = sqliteSkipReason();

  group('GenerateDailyDigestUseCase (in-memory)', () {
    late AppDatabase db;
    late TestSeed seed;
    late GenerateDailyDigestUseCase useCase;

    // 15.07.2026 — среда, 19.07.2026 — воскресенье, 01.08.2026 — 1-е число.
    final wednesday = DateTime(2026, 7, 15, 20);
    final sunday = DateTime(2026, 7, 19, 20);
    final firstDay = DateTime(2026, 8, 1, 20);

    setUp(() async {
      db = openTestDb();
      seed = TestSeed(db);
      await seed.base();
      await db.appSettingsDao.getForUser(kUserId);
      useCase = GenerateDailyDigestUseCase(db);
    });

    tearDown(() async {
      await db.close();
    });

    Future<void> setConfig(Map<String, dynamic> cfg) async {
      await db.customStatement(
        'UPDATE app_settings SET digest_config = ? WHERE user_id = ?',
        [jsonEncode(cfg), kUserId],
      );
    }

    Future<void> addNote({
      required String id,
      required String type,
      bool isRead = false,
    }) async {
      await db.into(db.notifications).insert(NotificationsCompanion.insert(
            id: id,
            userId: kUserId,
            type: type,
            title: 'Событие',
            body: 'Текст',
            isRead: Value(isRead),
            createdAt: Value(DateTime(2026, 7, 15, 10)),
          ));
    }

    Future<void> addExpense({
      required String id,
      required int amount,
      bool isWithdrawal = false,
      AuditStatus auditStatus = AuditStatus.verified,
    }) =>
        seed.tx(
          id: id,
          amountKopecks: amount,
          categoryId: 'c1',
          date: DateTime(2026, 7, 15, 12),
          isWithdrawal: isWithdrawal,
          auditStatus: auditStatus,
        );

    Future<bool> readFlag(String id) async {
      final row = await (db.select(db.notifications)
            ..where((n) => n.id.equals(id)))
          .getSingle();
      return row.isRead;
    }

    test('выключенный дневной дайджест не генерируется', () async {
      await setConfig({'daily': {'on': false}});
      await addExpense(id: 't1', amount: 10000);

      expect(await useCase.maybeGenerate(kUserId, wednesday), isNull);
    });

    test('раньше настроенного часа дайджест не генерируется', () async {
      await addExpense(id: 't1', amount: 10000);

      expect(
        await useCase.maybeGenerate(kUserId, DateTime(2026, 7, 15, 10)),
        isNull,
      );
    });

    test('дневной дайджест после часа содержит траты', () async {
      await addExpense(id: 't1', amount: 10000);

      final r = await useCase.maybeGenerate(kUserId, wednesday);

      expect(r, isNotNull);
      expect(r!.type, NotificationType.dailyDigest);
      expect(r.title, contains('Итоги дня'));
      expect(r.body, contains('потрачено 100 ₽'));
    });

    test('в воскресенье генерируется недельный дайджест', () async {
      await addExpense(id: 't1', amount: 10000);

      final r = await useCase.maybeGenerate(kUserId, sunday);

      expect(r!.type, NotificationType.weeklyDigest);
      expect(r.title, contains('Итоги недели'));
    });

    test('первого числа генерируется месячный дайджест', () async {
      await addExpense(id: 't1', amount: 10000);

      final r = await useCase.maybeGenerate(kUserId, firstDay);

      expect(r!.type, NotificationType.monthlyDigest);
      expect(r.title, contains('Итоги месяца'));
      expect(r.id, startsWith(NotificationType.monthlyDigest.dbValue));
    });

    test('camelCase уведомления агрегируются и помечаются прочитанными',
        () async {
      await addNote(id: 'n1', type: NotificationType.memberActivity.dbValue);
      await addNote(id: 'n2', type: NotificationType.memberActivity.dbValue);
      await addNote(id: 'n3', type: NotificationType.goalMilestone.dbValue);
      await addNote(id: 'n4', type: NotificationType.debtCreated.dbValue);

      final r = await useCase.maybeGenerate(kUserId, wednesday);

      expect(r!.body, contains('2 новых участника'));
      expect(r.body, contains('1 цели с прогрессом'));
      expect(r.body, contains('1 события по долгам'));
      expect(await readFlag('n1'), isTrue);
      expect(await readFlag('n4'), isTrue);
    });

    test('legacy snake_case уведомления тоже агрегируются', () async {
      await addNote(id: 'n1', type: 'member_activity');
      await addNote(id: 'n2', type: 'recurring_detected');

      final r = await useCase.maybeGenerate(kUserId, wednesday);

      expect(r!.body, contains('1 новых участника'));
      expect(r.body, contains('найдена подписка'));
      expect(await readFlag('n1'), isTrue);
    });

    test('прочитанные уведомления в дайджест не попадают', () async {
      await addNote(
        id: 'n1',
        type: NotificationType.memberActivity.dbValue,
        isRead: true,
      );

      expect(await useCase.maybeGenerate(kUserId, wednesday), isNull);
    });

    test('посторонний тип не агрегируется', () async {
      await addNote(id: 'n1', type: NotificationType.reminderDue.dbValue);

      expect(await useCase.maybeGenerate(kUserId, wednesday), isNull);
      expect(await readFlag('n1'), isFalse);
    });

    test('нет событий и трат — дайджест не отправляется', () async {
      expect(await useCase.maybeGenerate(kUserId, wednesday), isNull);
    });

    test('изъятия и ignored-операции не считаются тратами', () async {
      await addExpense(id: 't1', amount: 10000);
      await addExpense(id: 't2', amount: 5000, isWithdrawal: true);
      await addExpense(
        id: 't3',
        amount: 7000,
        auditStatus: AuditStatus.ignored,
      );

      final r = await useCase.maybeGenerate(kUserId, wednesday);

      expect(r!.body, contains('потрачено 100 ₽'));
      expect(r.body, isNot(contains('220')));
    });
  }, skip: skip);
}