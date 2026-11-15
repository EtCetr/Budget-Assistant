import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import 'package:budget_assistant/features/cashback/domain/entities/cashback_category_summary.dart';
import 'package:budget_assistant/features/cashback/domain/entities/cashback_raw_models.dart';
import 'package:budget_assistant/features/cashback/domain/usecases/calculate_cashback_usecase.dart';
import 'package:budget_assistant/features/cashback/domain/usecases/convert_currency_usecase.dart';
import 'package:budget_assistant/features/cashback/domain/usecases/get_cashback_cycle_bounds_usecase.dart';
import '../../../helpers/fake_cashback_repository.dart';
import '../../../helpers/fake_exchange_rate_repository.dart';

/// Этап 24: 5 жёстких правил кэшбэка (ТОМ 4 §3).
void main() {
  late FakeCashbackRepository repo;
  late FakeExchangeRateRepository rates;
  late CalculateCashbackUseCase useCase;
  final now = DateTime(2026, 7, 15, 14, 30);

  void build({double? rate = 90}) {
    rates = FakeExchangeRateRepository(rate);
    final logger = Logger(level: Level.off);
    useCase = CalculateCashbackUseCase(
      cashbackRepository: repo,
      convertCurrency: ConvertCurrencyUseCase(
        rateRepository: rates,
        logger: logger,
      ),
      cycleBounds: GetCashbackCycleBoundsUseCase(logger: logger),
      logger: logger,
    );
  }

  setUp(() {
    repo = FakeCashbackRepository();
    build();
  });

  Future<List<CashbackCategorySummary>> run() =>
      useCase(accountId: 'a1', now: now);

  CashbackCategorySummary byEntry(
    List<CashbackCategorySummary> list,
    String entryId,
  ) =>
      list.firstWhere((s) => s.entryId == entryId);

  test('нет категорий кэшбэка — пустой результат', () async {
    expect(await run(), isEmpty);
  });

  test('счёт не найден — пустой результат', () async {
    repo.addEntry(id: 'e1');
    repo.currencies['a1'] = null;

    expect(await run(), isEmpty);
  });

  group('Правило 1: сплит-чеки', () {
    test('базовая сумма игнорируется, берутся позиции нужной категории',
        () async {
      repo.addEntry(id: 'e1', categoryId: 'c1', percentBps: 500);
      repo.txByAccount['a1'] = [
        cashbackTx(id: 't1', amount: 100000, isSplit: true),
      ];
      repo.splits.addAll(const [
        CashbackSplitRaw(
          id: 's1',
          transactionId: 't1',
          categoryId: 'c1',
          amount: 30000,
        ),
        CashbackSplitRaw(
          id: 's2',
          transactionId: 't1',
          categoryId: 'c2',
          amount: 70000,
        ),
      ]);

      final s = byEntry(await run(), 'e1');

      expect(s.grossExpenseKopecks, 30000);
      expect(s.cashbackKopecks, 1500);
    });

    test('сплит без позиций не даёт базы', () async {
      repo.addEntry(id: 'e1');
      repo.txByAccount['a1'] = [
        cashbackTx(id: 't1', amount: 100000, isSplit: true),
      ];

      final s = byEntry(await run(), 'e1');

      expect(s.grossExpenseKopecks, 0);
      expect(s.cashbackKopecks, 0);
    });
  });

  group('Правило 2: мультивалютность', () {
    test('сумма приводится к валюте карты по курсу на дату', () async {
      repo.addEntry(id: 'e1', percentBps: 500);
      repo.txByAccount['a1'] = [
        cashbackTx(
          id: 't1',
          amount: 999999,
          originalCurrency: 'USD',
          originalAmount: 10000,
        ),
      ];

      final s = byEntry(await run(), 'e1');

      expect(rates.calls, ['USD->RUB']);
      expect(s.grossExpenseKopecks, 900000);
      expect(s.cashbackKopecks, 45000);
    });

    test('курса нет — транзакция пропускается', () async {
      build(rate: null);
      repo.addEntry(id: 'e1');
      repo.txByAccount['a1'] = [
        cashbackTx(id: 't1', originalCurrency: 'USD', originalAmount: 10000),
      ];

      expect(byEntry(await run(), 'e1').grossExpenseKopecks, 0);
    });

    test('валюта совпадает с валютой карты — конвертация не нужна', () async {
      repo.addEntry(id: 'e1');
      repo.txByAccount['a1'] = [
        cashbackTx(id: 't1', amount: 100000, originalCurrency: 'RUB'),
      ];

      final s = byEntry(await run(), 'e1');

      expect(rates.calls, isEmpty);
      expect(s.grossExpenseKopecks, 100000);
    });
  });

  group('Правило 4: NET-сумма с возвратами', () {
    test('возврат той же категории вычитается из базы', () async {
      repo.addEntry(id: 'e1', percentBps: 500);
      repo.txByAccount['a1'] = [
        cashbackTx(id: 't1', amount: 100000),
        cashbackTx(id: 't2', amount: 30000, type: TransactionType.income),
      ];

      final s = byEntry(await run(), 'e1');

      expect(s.grossExpenseKopecks, 100000);
      expect(s.refundKopecks, 30000);
      expect(s.netExpenseKopecks, 70000);
      expect(s.cashbackKopecks, 3500);
    });

    test('возврат больше трат — база не уходит в минус', () async {
      repo.addEntry(id: 'e1');
      repo.txByAccount['a1'] = [
        cashbackTx(id: 't1', amount: 10000),
        cashbackTx(id: 't2', amount: 50000, type: TransactionType.income),
      ];

      final s = byEntry(await run(), 'e1');

      expect(s.netExpenseKopecks, 0);
      expect(s.cashbackKopecks, 0);
    });

    test('возврат другой категории не уменьшает базу', () async {
      repo.addEntry(id: 'e1', categoryId: 'c1');
      repo.txByAccount['a1'] = [
        cashbackTx(id: 't1', amount: 100000),
        cashbackTx(
          id: 't2',
          amount: 50000,
          type: TransactionType.income,
          categoryId: 'c2',
        ),
      ];

      final s = byEntry(await run(), 'e1');

      expect(s.refundKopecks, 0);
      expect(s.netExpenseKopecks, 100000);
    });
  });

  test('Правило 5: границы цикла передаются в репозиторий', () async {
    repo.addEntry(id: 'e1', lifetimeType: 'weekly');

    await run();

    final expected = GetCashbackCycleBoundsUseCase(
      logger: Logger(level: Level.off),
    )(now: now, lifetimeType: 'weekly');

    expect(repo.boundsCalls.length, 1);
    expect(repo.boundsCalls.single.start, expected.startUtc);
    expect(repo.boundsCalls.single.end, expected.endUtc);
  });

  test('недельная и месячная записи считаются по своим циклам', () async {
    repo.addEntry(id: 'w1', categoryId: 'c1', lifetimeType: 'weekly');
    repo.addEntry(id: 'm1', categoryId: 'c2', lifetimeType: 'monthly');

    final result = await run();

    expect(result.length, 2);
    expect(repo.boundsCalls.length, 2);
    expect(repo.boundsCalls[0].start, isNot(repo.boundsCalls[1].start));
  });

  test('транзакция без категории не даёт базы', () async {
    repo.addEntry(id: 'e1');
    repo.txByAccount['a1'] = [cashbackTx(id: 't1', categoryId: null)];

    expect(byEntry(await run(), 'e1').grossExpenseKopecks, 0);
  });

  test('запись без привязки к категории: процент есть, базы нет', () async {
    repo.addEntry(id: 'e1', categoryId: null, categoryName: 'Все покупки');
    repo.txByAccount['a1'] = [cashbackTx(id: 't1')];

    final s = byEntry(await run(), 'e1');

    expect(s.percentBps, 500);
    expect(s.grossExpenseKopecks, 0);
    expect(s.cashbackKopecks, 0);
  });

  test('ошибка репозитория пробрасывается', () async {
    repo.error = Exception('db down');

    await expectLater(run(), throwsA(isA<Exception>()));
  });
}