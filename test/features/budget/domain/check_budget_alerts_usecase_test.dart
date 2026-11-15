import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/features/budget/domain/usecases/check_budget_alerts_usecase.dart';
import '../../../helpers/fake_budget_limits_repository.dart';
import '../../../helpers/sqlite_probe.dart';
import '../../../helpers/test_db.dart';

/// Этап 24: матрица алертов лимитов (ТОМ 4 §2.2) + дедупликация за 24 часа.
void main() {
  final skip = sqliteSkipReason();

  group('CheckBudgetAlertsUseCase (in-memory)', () {
    late AppDatabase db;
    late TestSeed seed;
    late FakeBudgetLimitsRepository repo;
    late CheckBudgetAlertsUseCase useCase;

    setUp(() async {
      db = openTestDb();
      seed = TestSeed(db);
      await seed.base();
      repo = FakeBudgetLimitsRepository();
      useCase = CheckBudgetAlertsUseCase(
        repository: repo,
        notificationsDao: db.notificationsDao,
        logger: Logger(level: Level.off),
      );
    });

    tearDown(() async {
      await db.close();
    });

    Future<void> run({
      required String mode,
      int percent = 80,
      int amount = 0,
    }) async {
      await useCase(
        userId: kUserId,
        spaceId: null,
        year: 2026,
        month: 7,
        alertMode: mode,
        globalAlertPercent: percent,
        globalAlertAmount: amount,
      );
    }

    Future<List<Notification>> notifications() =>
        db.select(db.notifications).get();

    test('global_percent: порог достигнут — уведомление создано', () async {
      repo.putLimit(year: 2026, month: 7, categoryId: 'c1', kopecks: 10000000);
      repo.pnlExpense = 8000000;

      await run(mode: 'global_percent');

      final rows = await notifications();
      expect(rows.length, 1);
      expect(rows.single.type, 'limit_global_percent');
    });

    test('global_percent: ниже порога — уведомления нет', () async {
      repo.putLimit(year: 2026, month: 7, categoryId: 'c1', kopecks: 10000000);
      repo.pnlExpense = 1000000;

      await run(mode: 'global_percent');

      expect(await notifications(), isEmpty);
    });

    test('global_amount: остаток меньше порога — уведомление создано',
        () async {
      repo.putLimit(year: 2026, month: 7, categoryId: 'c1', kopecks: 10000000);
      repo.pnlExpense = 9500000;

      await run(mode: 'global_amount', amount: 1000000);

      final rows = await notifications();
      expect(rows.length, 1);
      expect(rows.single.type, 'limit_global_amount');
    });

    test('individual: порог категории достигнут, relatedEntityId = категория',
        () async {
      repo.putLimit(
        year: 2026,
        month: 7,
        categoryId: 'c1',
        kopecks: 10000000,
      );
      repo.putExpense(
        year: 2026,
        month: 7,
        categoryId: 'c1',
        kopecks: 8000000,
      );

      await run(mode: 'individual');

      final rows = await notifications();
      expect(rows.length, 1);
      expect(rows.single.type, 'limit_individual');
      expect(rows.single.relatedEntityId, 'c1');
    });

    test('повторная проверка в течение суток не плодит дубли', () async {
      repo.putLimit(year: 2026, month: 7, categoryId: 'c1', kopecks: 10000000);
      repo.pnlExpense = 8000000;

      await run(mode: 'global_percent');
      await run(mode: 'global_percent');

      expect((await notifications()).length, 1);
    });

    test('индивидуальный алерт тоже не дублируется', () async {
      repo.putLimit(
        year: 2026,
        month: 7,
        categoryId: 'c1',
        kopecks: 10000000,
      );
      repo.putExpense(
        year: 2026,
        month: 7,
        categoryId: 'c1',
        kopecks: 8000000,
      );

      await run(mode: 'individual');
      await run(mode: 'individual');

      expect((await notifications()).length, 1);
    });

    test('неизвестный режим алертов ничего не создаёт', () async {
      repo.putLimit(year: 2026, month: 7, categoryId: 'c1', kopecks: 10000000);
      repo.pnlExpense = 9999999;

      await run(mode: 'off');

      expect(await notifications(), isEmpty);
    });
  }, skip: skip);
}