import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import 'package:budget_assistant/features/savings_goals/domain/usecases/calculate_savings_forecast_usecase.dart';
import '../../../helpers/savings_analytics_fixtures.dart';

/// Этап 24: прогнозная линия накоплений (ТЗ 6.3.18.5).
/// Среднее дневное пополнение за 30 дней; данных меньше 7 дней — линии нет.
void main() {
  late CalculateSavingsForecastUseCase useCase;
  final accounts = [analyticsAccount(id: 'a1')];
  final now = DateTime(2026, 7, 10, 12);
  final startDate = DateTime(2026, 7, 7);
  final projectUntil = DateTime(2026, 7, 17);

  setUp(() {
    useCase = CalculateSavingsForecastUseCase(
      convertCurrency: buildConvert(),
      logger: Logger(level: Level.off),
    );
  });

  /// 7 пополнений по 3000 копеек на 7 разных дней (1..7 июля).
  List<dynamic> week({int amount = 3000}) => [
        for (var d = 1; d <= 7; d++)
          savingsTx(id: 't$d', amount: amount, date: DateTime(2026, 7, d, 12)),
      ];

  Future<List<ForecastPoint>> run({
    List<dynamic> txs = const [],
    List<dynamic>? acc,
    DateTime? until,
    DateTime? start,
    int startCumulative = 100000,
  }) =>
      useCase(
        savingsTransactions: txs.cast(),
        accounts: (acc ?? accounts).cast(),
        baseCurrency: 'RUB',
        now: now,
        projectUntil: until ?? projectUntil,
        startCumulativeKopecks: startCumulative,
        startDate: start ?? startDate,
      );

  test('горизонт не после старта — прогноза нет', () async {
    final points = await run(txs: week(), until: startDate);

    expect(points, isEmpty);
  });

  test('меньше 7 дней с пополнениями — прогноза нет', () async {
    final points = await run(txs: [
      for (var d = 1; d <= 6; d++)
        savingsTx(id: 't$d', amount: 3000, date: DateTime(2026, 7, d, 12)),
    ]);

    expect(points, isEmpty);
  });

  test('ровно 7 дней: две точки, среднее = сумма / 30', () async {
    final points = await run(txs: week());

    expect(points.length, 2);
    expect(points.first.date, startDate);
    expect(points.first.forecastedAmountKopecks, 100000);
    expect(points.last.date, projectUntil);
    // 7 * 3000 = 21000; 21000 ~/ 30 = 700; горизонт 10 дней.
    expect(points.last.forecastedAmountKopecks, 107000);
  });

  test('изъятия и ignored не увеличивают ни сумму, ни число дней', () async {
    final points = await run(txs: [
      ...week(),
      savingsTx(
        id: 'w',
        amount: 50000,
        date: DateTime(2026, 7, 8, 12),
        isWithdrawal: true,
      ),
      savingsTx(
        id: 'i',
        amount: 50000,
        date: DateTime(2026, 7, 9, 12),
        auditStatus: AuditStatus.ignored,
      ),
    ]);

    expect(points.last.forecastedAmountKopecks, 107000);
  });

  test('пополнения старше 30 дней не учитываются', () async {
    final points = await run(txs: [
      ...week(),
      savingsTx(id: 'old', amount: 999999, date: DateTime(2026, 6, 1, 12)),
    ]);

    expect(points.last.forecastedAmountKopecks, 107000);
  });

  test('пополнения после «сейчас» не учитываются', () async {
    final points = await run(txs: [
      ...week(),
      savingsTx(id: 'future', amount: 999999, date: DateTime(2026, 7, 20, 12)),
    ]);

    expect(points.last.forecastedAmountKopecks, 107000);
  });

  test('счёт не найден — пополнение пропускается, прогноза нет', () async {
    final points = await run(txs: week(), acc: const []);

    expect(points, isEmpty);
  });

  test('курса нет — пополнение пропускается, прогноза нет', () async {
    useCase = CalculateSavingsForecastUseCase(
      convertCurrency: buildConvert(rate: null),
      logger: Logger(level: Level.off),
    );

    final points = await run(
      txs: [
        for (var d = 1; d <= 7; d++)
          savingsTx(
            id: 't$d',
            amount: 100,
            date: DateTime(2026, 7, d, 12),
            accountId: 'usd',
          ),
      ],
      acc: [analyticsAccount(id: 'usd', currency: 'USD')],
    );

    expect(points, isEmpty);
  });

  test('валютные пополнения приводятся к базовой валюте', () async {
    final points = await run(
      txs: [
        for (var d = 1; d <= 7; d++)
          savingsTx(
            id: 't$d',
            amount: 100,
            date: DateTime(2026, 7, d, 12),
            accountId: 'usd',
          ),
      ],
      acc: [analyticsAccount(id: 'usd', currency: 'USD')],
    );

    // 7 * 100 * 90 = 63000; 63000 ~/ 30 = 2100; горизонт 10 дней.
    expect(points.last.forecastedAmountKopecks, 121000);
  });

  test('среднее меньше копейки в день — прогноза нет', () async {
    final points = await run(txs: week(amount: 1));

    expect(points, isEmpty);
  });
}