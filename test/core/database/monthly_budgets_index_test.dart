import 'package:flutter_test/flutter_test.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import '../../helpers/sqlite_probe.dart';
import '../../helpers/test_db.dart';

/// Этап 24 (D24-7): UNIQUE «Выделено» на чистой установке.
/// Раньше индекс создавался только в миграции from<23, поэтому у новых
/// пользователей дубль месяца был возможен. Теперь он есть и в beforeOpen.
void main() {
  final skip = sqliteSkipReason();

  group('monthly_budgets: уникальность на чистой установке', () {
    late AppDatabase db;
    late TestSeed seed;

    setUp(() async {
      db = openTestDb();
      seed = TestSeed(db);
      await seed.base();
    });

    tearDown(() async {
      await db.close();
    });

    test('индексы monthly_budgets созданы', () async {
      final rows = await db.customSelect(
        "SELECT name FROM sqlite_master WHERE type = 'index' "
        "AND name IN ('idx_monthly_budgets_unique', 'idx_monthly_budgets_lookup')",
      ).get();

      final names = rows.map((r) => r.read<String>('name')).toSet();
      expect(names, {
        'idx_monthly_budgets_unique',
        'idx_monthly_budgets_lookup',
      });
    });

    test('дубль «Выделено» за один месяц невозможен', () async {
      await seed.allocated(id: 'm1', year: 2026, month: 7, kopecks: 10000);

      await expectLater(
        seed.allocated(id: 'm2', year: 2026, month: 7, kopecks: 20000),
        throwsA(anything),
      );

      final rows = await db.select(db.monthlyBudgets).get();
      expect(rows.length, 1);
      expect(rows.single.allocatedAmount, 10000);
    });

    test('разные месяцы и скоупы не конфликтуют', () async {
      await seed.allocated(id: 'm7', year: 2026, month: 7, kopecks: 10000);
      await seed.allocated(id: 'm8', year: 2026, month: 8, kopecks: 10000);
      await seed.allocated(
        id: 'f7',
        year: 2026,
        month: 7,
        kopecks: 10000,
        spaceId: kSpaceId,
      );

      expect((await db.select(db.monthlyBudgets).get()).length, 3);
    });
  }, skip: skip);
}