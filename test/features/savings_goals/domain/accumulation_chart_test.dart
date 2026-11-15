import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import 'package:budget_assistant/features/savings_goals/domain/entities/savings_goal.dart';
import 'package:budget_assistant/features/savings_goals/domain/usecases/build_accumulation_chart_usecase.dart';
import 'package:budget_assistant/features/savings_goals/domain/usecases/calculate_savings_forecast_usecase.dart';
import '../../../helpers/savings_analytics_fixtures.dart';

/// Этап 24: график накопления по всем целям (ТЗ 6.3.18.5).
/// Точки строятся только в дни поступлений и идут строго по датам.
void main() {
  late BuildAccumulationChartUseCase useCase;
  final accounts = [analyticsAccount(id: 'a1')];
  final periodStart = DateTime(2026, 7, 1);
  final periodEnd = DateTime(2026, 7, 31, 23, 59, 59);
  final now = DateTime(2026, 7, 10, 12);

  void build({double? rate = 90}) {
    final convert = buildConvert(rate: rate);
    final logger = Logger(level: Level.off);
    useCase = BuildAccumulationChartUseCase(
      forecast: CalculateSavingsForecastUseCase(
        convertCurrency: convert,
        logger: logger,
      ),
      convertCurrency: convert,
      logger: logger,
    );
  }

  setUp(build);

  Future<AccumulationChartData> run({
    List<SavingsGoal> goals = const [],
    List<dynamic> txs = const [],
    List<dynamic>? acc,
  }) =>
      useCase(
        goals: goals,
        savingsTransactions: txs.cast(),
        accounts: (acc ?? accounts).cast(),
        baseCurrency: 'RUB',
        periodStart: periodStart,
        periodEnd: periodEnd,
        now: now,
      );

  test('нет пополнений: точек нет, целевая линия считается', () async {
    final data = await run(goals: [
      analyticsGoal(id: 'g1', target: 10000000),
    ]);

    expect(data.points, isEmpty);
    expect(data.forecast, isEmpty);
    expect(data.targetLineKopecks, 10000000);
    expect(data.baseCurrency, 'RUB');
    expect(data.hasStaleRates, isFalse);
  });

  test('точки идут строго по датам и накапливают сумму', () async {
    final data = await run(txs: [
      savingsTx(id: 't1', amount: 1000, date: DateTime(2026, 7, 1, 12)),
      savingsTx(id: 't2', amount: 2000, date: DateTime(2026, 7, 2, 12)),
      savingsTx(id: 't3', amount: 3000, date: DateTime(2026, 7, 10, 12)),
    ]);

    expect(data.points.map((p) => p.date.day).toList(), [1, 2, 10]);
    expect(
      data.points.map((p) => p.cumulativeAmountKopecks).toList(),
      [1000, 3000, 6000],
    );
  });

  test('несколько пополнений в один день складываются в одну точку', () async {
    final data = await run(txs: [
      savingsTx(id: 't1', amount: 1000, date: DateTime(2026, 7, 2, 10)),
      savingsTx(id: 't2', amount: 2500, date: DateTime(2026, 7, 2, 18)),
    ]);

    expect(data.points.length, 1);
    expect(data.points.single.cumulativeAmountKopecks, 3500);
  });

  test('изъятия и ignored не попадают в график', () async {
    final data = await run(txs: [
      savingsTx(id: 't1', amount: 1000, date: DateTime(2026, 7, 1, 12)),
      savingsTx(
        id: 't2',
        amount: 500,
        date: DateTime(2026, 7, 2, 12),
        isWithdrawal: true,
      ),
      savingsTx(
        id: 't3',
        amount: 700,
        date: DateTime(2026, 7, 3, 12),
        auditStatus: AuditStatus.ignored,
      ),
    ]);

    expect(data.points.length, 1);
    expect(data.points.single.cumulativeAmountKopecks, 1000);
  });

  test('пополнения вне периода отбрасываются', () async {
    final data = await run(txs: [
      savingsTx(id: 'before', amount: 900, date: DateTime(2026, 6, 25, 12)),
      savingsTx(id: 'in', amount: 1000, date: DateTime(2026, 7, 5, 12)),
      savingsTx(id: 'after', amount: 900, date: DateTime(2026, 8, 1, 12)),
    ]);

    expect(data.points.length, 1);
    expect(data.points.single.date.day, 5);
  });

  test('счёт не найден — флаг устаревших курсов, точка не строится', () async {
    final data = await run(
      txs: [savingsTx(id: 't1', amount: 1000, date: DateTime(2026, 7, 1, 12))],
      acc: const [],
    );

    expect(data.hasStaleRates, isTrue);
    expect(data.points, isEmpty);
  });

  test('курса нет — флаг устаревших курсов', () async {
    build(rate: null);

    final data = await run(
      goals: [analyticsGoal(id: 'g1', currency: 'USD', target: 10000)],
      txs: [
        savingsTx(
          id: 't1',
          amount: 100,
          date: DateTime(2026, 7, 1, 12),
          accountId: 'usd',
        ),
      ],
      acc: [analyticsAccount(id: 'usd', currency: 'USD')],
    );

    expect(data.hasStaleRates, isTrue);
    expect(data.points, isEmpty);
    expect(data.targetLineKopecks, 0);
  });

  test('целевая линия учитывает только активные цели', () async {
    final data = await run(goals: [
      analyticsGoal(id: 'g1', target: 10000000),
      analyticsGoal(id: 'g2', target: 20000000, isArchived: true),
      analyticsGoal(
        id: 'g3',
        target: 30000000,
        status: SavingsGoalStatus.completed,
      ),
    ]);

    expect(data.targetLineKopecks, 10000000);
  });

  test('валютные пополнения приводятся к базовой валюте', () async {
    final data = await run(
      txs: [
        savingsTx(
          id: 't1',
          amount: 100,
          date: DateTime(2026, 7, 1, 12),
          accountId: 'usd',
        ),
      ],
      acc: [analyticsAccount(id: 'usd', currency: 'USD')],
    );

    expect(data.points.single.cumulativeAmountKopecks, 9000);
    expect(data.hasStaleRates, isFalse);
  });

  test('при 7 днях пополнений достраивается прогнозная линия', () async {
    final data = await run(txs: [
      for (var d = 1; d <= 7; d++)
        savingsTx(id: 't$d', amount: 3000, date: DateTime(2026, 7, d, 12)),
    ]);

    expect(data.points.length, 7);
    expect(data.points.last.cumulativeAmountKopecks, 21000);
    expect(data.forecast.length, 2);
    expect(data.forecast.first.forecastedAmountKopecks, 21000);
    expect(
      data.forecast.last.forecastedAmountKopecks,
      greaterThan(21000),
    );
  });
}