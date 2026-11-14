import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/features/dashboard/data/repositories/dashboard_data_repository_impl.dart';
import 'package:budget_assistant/features/transactions/domain/usecases/add_transaction_copies_usecase.dart';
import '../../../helpers/sqlite_probe.dart';
import '../../../helpers/test_db.dart';

/// Этап 24 (D24-9): «Движение расходов» считает группу копий один раз.
void main() {
  final skip = sqliteSkipReason();

  group('Dashboard getExpenseFlow (in-memory)', () {
    late AppDatabase db;
    late TestSeed seed;
    late DashboardDataRepositoryImpl repo;
    late AddTransactionCopiesUseCase addCopies;

    setUp(() async {
      db = openTestDb();
      seed = TestSeed(db);
      await seed.base();
      repo = DashboardDataRepositoryImpl(
        db: db,
        logger: Logger(level: Level.off),
      );
      addCopies = AddTransactionCopiesUseCase(
        db: db,
        logger: Logger(level: Level.off),
      );
    });

    tearDown(() async {
      await db.close();
    });

    Future<int> total({String? spaceId}) async {
      final points = await repo.getExpenseFlow(
        userId: kUserId,
        spaceId: spaceId,
      );
      return points.fold<int>(0, (s, p) => s + p.totalKopecks);
    }

    test('личное + семейная копия = одна трата', () async {
      await seed.tx(
        id: 'src',
        amountKopecks: 1500,
        categoryId: 'c1',
        date: DateTime.now(),
      );
      await addCopies(
        transactionId: 'src',
        spaceIds: [kSpaceId],
        userId: kUserId,
      );

      expect(await total(), 1500);
    });

    test('в семейном скоупе та же группа тоже считается один раз', () async {
      await seed.tx(
        id: 'src',
        amountKopecks: 1500,
        categoryId: 'c1',
        date: DateTime.now(),
      );
      await addCopies(
        transactionId: 'src',
        spaceIds: [kSpaceId],
        userId: kUserId,
      );

      expect(await total(spaceId: kSpaceId), 1500);
    });

    test('две разные операции складываются', () async {
      await seed.tx(
        id: 'a',
        amountKopecks: 1500,
        categoryId: 'c1',
        date: DateTime.now(),
      );
      await seed.tx(
        id: 'b',
        amountKopecks: 2000,
        categoryId: 'c2',
        date: DateTime.now(),
      );

      expect(await total(), 3500);
    });

    test('окно 30 дней: старая трата не попадает', () async {
      await seed.tx(
        id: 'old',
        amountKopecks: 9999,
        categoryId: 'c1',
        date: DateTime.now().subtract(const Duration(days: 45)),
      );

      expect(await total(), 0);
    });
  }, skip: skip);
}