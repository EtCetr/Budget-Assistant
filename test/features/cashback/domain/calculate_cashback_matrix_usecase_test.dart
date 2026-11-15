import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/features/cashback/domain/entities/cashback_account_ref.dart';
import 'package:budget_assistant/features/cashback/domain/entities/cashback_matrix_models.dart';
import 'package:budget_assistant/features/cashback/domain/usecases/calculate_cashback_matrix_usecase.dart';
import 'package:budget_assistant/features/cashback/domain/usecases/calculate_cashback_usecase.dart';
import 'package:budget_assistant/features/cashback/domain/usecases/convert_currency_usecase.dart';
import 'package:budget_assistant/features/cashback/domain/usecases/get_cashback_cycle_bounds_usecase.dart';
import '../../../helpers/fake_cashback_repository.dart';
import '../../../helpers/fake_exchange_rate_repository.dart';

/// Этап 24: матрица выгоды «категория x карта» и выбор лучшей карты.
void main() {
  late FakeCashbackRepository repo;
  late CalculateCashbackMatrixUseCase useCase;
  final now = DateTime(2026, 7, 15);

  const a1 = CashbackAccountRef(id: 'a1', name: 'Карта 1', currency: 'RUB');
  const a2 = CashbackAccountRef(id: 'a2', name: 'Карта 2', currency: 'RUB');

  setUp(() {
    repo = FakeCashbackRepository();
    repo.currencies['a2'] = 'RUB';
    final logger = Logger(level: Level.off);
    useCase = CalculateCashbackMatrixUseCase(
      calculateCashback: CalculateCashbackUseCase(
        cashbackRepository: repo,
        convertCurrency: ConvertCurrencyUseCase(
          rateRepository: FakeExchangeRateRepository(90),
          logger: logger,
        ),
        cycleBounds: GetCashbackCycleBoundsUseCase(logger: logger),
        logger: logger,
      ),
      logger: logger,
    );
  });

  Future<List<CashbackMatrixRow>> run(List<CashbackAccountRef> accounts) =>
      useCase(now: now, accounts: accounts);

  test('нет счетов — пустая матрица', () async {
    expect(await run(const []), isEmpty);
  });

  test('одна карта и категория: лучшая карта — она сама', () async {
    repo.addEntry(id: 'e1', accountId: 'a1', percentBps: 500);
    repo.txByAccount['a1'] = [cashbackTx(id: 't1', amount: 100000)];

    final rows = await run(const [a1]);

    expect(rows.length, 1);
    expect(rows.single.cells.length, 1);
    expect(rows.single.bestAccountId, 'a1');
    expect(rows.single.bestPercentBps, 500);
  });

  test('лучшая карта — с максимальным процентом', () async {
    repo.addEntry(id: 'e1', accountId: 'a1', percentBps: 500);
    repo.addEntry(id: 'e2', accountId: 'a2', percentBps: 300);
    repo.txByAccount['a1'] = [cashbackTx(id: 't1', amount: 100000)];
    repo.txByAccount['a2'] = [cashbackTx(id: 't2', amount: 100000)];

    final row = (await run(const [a1, a2])).single;

    expect(row.bestAccountId, 'a1');
    expect(row.bestPercentBps, 500);
    expect(row.cells.length, 2);
  });

  test('при равных процентах лучшая — где больше фактический кэшбэк',
      () async {
    repo.addEntry(id: 'e1', accountId: 'a1', percentBps: 500);
    repo.addEntry(id: 'e2', accountId: 'a2', percentBps: 500);
    repo.txByAccount['a1'] = [cashbackTx(id: 't1', amount: 100000)];
    repo.txByAccount['a2'] = [cashbackTx(id: 't2', amount: 200000)];

    final row = (await run(const [a1, a2])).single;

    expect(row.bestAccountId, 'a2');
  });

  test('у карты без категории ячейка пустая', () async {
    repo.addEntry(id: 'e1', accountId: 'a1', percentBps: 500);
    repo.txByAccount['a1'] = [cashbackTx(id: 't1')];

    final row = (await run(const [a1, a2])).single;
    final empty = row.cells.firstWhere((c) => c.accountId == 'a2');

    expect(empty.percentBps, isNull);
    expect(empty.entryId, isNull);
  });

  test('строки отсортированы по убыванию лучшего процента', () async {
    repo.addEntry(
      id: 'e1',
      accountId: 'a1',
      categoryId: 'c1',
      categoryName: 'Продукты',
      percentBps: 300,
    );
    repo.addEntry(
      id: 'e2',
      accountId: 'a1',
      categoryId: 'c2',
      categoryName: 'Транспорт',
      percentBps: 700,
    );
    repo.txByAccount['a1'] = [cashbackTx(id: 't1')];

    final rows = await run(const [a1]);

    expect(rows.first.bestPercentBps, 700);
    expect(rows.last.bestPercentBps, 300);
  });

  test('категория без id группируется по названию', () async {
    repo.addEntry(
      id: 'e1',
      accountId: 'a1',
      categoryId: null,
      categoryName: 'Все покупки',
    );

    final rows = await run(const [a1]);

    expect(rows.single.categoryId, 'name:Все покупки');
    expect(rows.single.categoryName, 'Все покупки');
  });
}