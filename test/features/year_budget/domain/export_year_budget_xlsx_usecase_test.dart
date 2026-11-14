import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/features/year_budget/domain/models/year_budget_models.dart';
import 'package:budget_assistant/features/year_budget/domain/usecases/calculate_year_budget_usecase.dart';
import 'package:budget_assistant/features/year_budget/domain/usecases/export_year_budget_xlsx_usecase.dart';
import '../../../helpers/fake_year_budget_repository.dart';

/// Этап 24: экспорт XLSX (D23.5-7) — смоук на реальном OOXML-writer.
/// Пишет во временную папку ОС, плагины не нужны.
void main() {
  late FakeYearBudgetRepository repo;
  late ExportYearBudgetXlsxUseCase useCase;
  final created = <String>[];

  setUp(() {
    repo = FakeYearBudgetRepository();
    final logger = Logger(level: Level.off);
    useCase = ExportYearBudgetXlsxUseCase(
      repository: repo,
      yearUseCase: CalculateYearBudgetUseCase(
        repository: repo,
        logger: logger,
      ),
      logger: logger,
    );

    repo.scopeCats = [
      const CategoryInfo(id: 'c1', name: 'Продукты', type: 'expense'),
      const CategoryInfo(id: 'i1', name: 'Зарплата', type: 'income'),
    ];
    repo.allCats = repo.scopeCats;
    repo.expenseSums = [
      const YearCatMonthSum(categoryId: 'c1', month: 1, totalKopecks: 150000),
      const YearCatMonthSum(categoryId: 'c1', month: 2, totalKopecks: 50000),
    ];
    repo.incomeSums = [
      const YearCatMonthSum(categoryId: 'i1', month: 1, totalKopecks: 300000),
    ];
    repo.monthLimits = {'c1': 200000};
    repo.allocatedValue = 250000;
    repo.expenseTx = [
      MonthTxRow(
        id: 't1',
        dateUtc: DateTime.utc(2026, 1, 5, 10),
        accountName: 'Карта',
        categoryName: 'Продукты',
        amountKopecks: 150000,
        isSplitPosition: false,
      ),
    ];
    repo.incomeTx = [
      MonthTxRow(
        id: 't2',
        dateUtc: DateTime.utc(2026, 1, 1, 9),
        accountName: 'Карта',
        categoryName: 'Зарплата',
        amountKopecks: 300000,
        isSplitPosition: false,
      ),
    ];
  });

  tearDown(() {
    for (final path in created) {
      try {
        final f = File(path);
        if (f.existsSync()) f.deleteSync();
      } catch (e) {
        // Уборка временных файлов не должна ронять тест.
        // ignore: avoid_print
        print('cleanup failed: $e');
      }
    }
    created.clear();
  });

  test('создаёт файл отчёта за выбранный год', () async {
    final path = await useCase(userId: 'user-1', year: 2026);
    created.add(path);

    expect(path.endsWith('godovoy_otchet_2026.xlsx'), isTrue);
    expect(File(path).existsSync(), isTrue);
    expect(File(path).lengthSync(), greaterThan(0));
  });

  test('пустой год тоже экспортируется без ошибки', () async {
    repo.expenseSums = [];
    repo.incomeSums = [];
    repo.monthLimits = {};
    repo.allocatedValue = null;
    repo.expenseTx = [];
    repo.incomeTx = [];

    final path = await useCase(userId: 'user-1', year: 2025);
    created.add(path);

    expect(File(path).existsSync(), isTrue);
  });

  test('семейный скоуп пробрасывается в репозиторий', () async {
    final path =
        await useCase(userId: 'user-1', year: 2026, spaceId: 'space-1');
    created.add(path);

    expect(repo.lastSpaceId, 'space-1');
  });

  test('ошибка репозитория логируется и пробрасывается', () async {
    repo.error = Exception('db down');

    await expectLater(
      useCase(userId: 'user-1', year: 2026),
      throwsA(isA<Exception>()),
    );
  });
}