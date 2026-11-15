import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import 'package:budget_assistant/features/savings_goals/domain/entities/savings_goal.dart';
import 'package:budget_assistant/features/savings_goals/domain/usecases/calculate_savings_analytics_usecase.dart';
import '../../../helpers/savings_analytics_fixtures.dart';

/// Этап 24: сводка SavingsAnalyticsScreen (ТЗ 6.3.18.4).
/// Курсы: остатки — на сегодня, пополнения — на дату транзакции.
void main() {
  late CalculateSavingsAnalyticsUseCase useCase;
  final accounts = [analyticsAccount(id: 'a1')];
  final periodStart = DateTime(2026, 7, 1);
  final periodEnd = DateTime(2026, 7, 31, 23, 59, 59);
  final prevStart = DateTime(2026, 6, 1);
  final prevEnd = DateTime(2026, 6, 30, 23, 59, 59);

  setUpAll(() {
    registerFallbackValue(DateTime.utc(2026));
  });

  setUp(() {
    useCase = CalculateSavingsAnalyticsUseCase(
      convertCurrency: buildConvert(),
      logger: Logger(level: Level.off),
    );
  });

  Future<AnalyticsSummary> run({
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
        prevPeriodStart: prevStart,
        prevPeriodEnd: prevEnd,
      );

  test('пустые данные: нули и отсутствие дельт', () async {
    final s = await run();

    expect(s.activeGoalsCount, 0);
    expect(s.completedGoalsCount, 0);
    expect(s.totalTargetKopecks, 0);
    expect(s.totalCurrentKopecks, 0);
    expect(s.overallProgressPercent, 0);
    expect(s.contributedInPeriodKopecks, 0);
    expect(s.contributionDeltaPercent, isNull);
    expect(s.targetDeltaPercent, isNull);
    expect(s.hasStaleRates, isFalse);
  });

  test('в суммы идут только активные цели, завершённые считаются отдельно',
      () async {
    final s = await run(goals: [
      analyticsGoal(id: 'g1', target: 10000000, current: 5000000),
      analyticsGoal(id: 'g2', target: 20000000, current: 1000000, isArchived: true),
      analyticsGoal(
        id: 'g3',
        target: 5000000,
        current: 5000000,
        status: SavingsGoalStatus.completed,
      ),
    ]);

    expect(s.activeGoalsCount, 1);
    expect(s.completedGoalsCount, 1);
    expect(s.totalTargetKopecks, 10000000);
    expect(s.totalCurrentKopecks, 5000000);
    expect(s.overallProgressPercent, 50);
  });

  test('пополнения периода и дельта к прошлому периоду', () async {
    final s = await run(txs: [
      savingsTx(id: 't1', amount: 30000, date: DateTime(2026, 7, 5, 12)),
      savingsTx(id: 't2', amount: 20000, date: DateTime(2026, 7, 10, 12)),
      savingsTx(id: 't3', amount: 25000, date: DateTime(2026, 6, 5, 12)),
    ]);

    expect(s.contributedInPeriodKopecks, 50000);
    expect(s.contributionDeltaPercent, 100);
  });

  test('прошлого периода нет — дельта null', () async {
    final s = await run(txs: [
      savingsTx(id: 't1', amount: 30000, date: DateTime(2026, 7, 5, 12)),
    ]);

    expect(s.contributedInPeriodKopecks, 30000);
    expect(s.contributionDeltaPercent, isNull);
  });

  test('изъятия и ignored не входят в пополнения', () async {
    final s = await run(txs: [
      savingsTx(id: 't1', amount: 30000, date: DateTime(2026, 7, 5, 12)),
      savingsTx(
        id: 't2',
        amount: 10000,
        date: DateTime(2026, 7, 6, 12),
        isWithdrawal: true,
      ),
      savingsTx(
        id: 't3',
        amount: 20000,
        date: DateTime(2026, 7, 7, 12),
        auditStatus: AuditStatus.ignored,
      ),
    ]);

    expect(s.contributedInPeriodKopecks, 30000);
  });

  test('счёт транзакции не найден — флаг устаревших курсов', () async {
    final s = await run(
      txs: [savingsTx(id: 't1', amount: 30000, date: DateTime(2026, 7, 5, 12))],
      acc: const [],
    );

    expect(s.hasStaleRates, isTrue);
    expect(s.contributedInPeriodKopecks, 0);
  });

  test('курса нет — флаг устаревших курсов', () async {
    useCase = CalculateSavingsAnalyticsUseCase(
      convertCurrency: buildConvert(rate: null),
      logger: Logger(level: Level.off),
    );

    final s = await run(
      goals: [analyticsGoal(id: 'g1', currency: 'USD', target: 10000)],
      txs: [
        savingsTx(
          id: 't1',
          amount: 100,
          date: DateTime(2026, 7, 5, 12),
          accountId: 'usd',
        ),
      ],
      acc: [analyticsAccount(id: 'usd', currency: 'USD')],
    );

    expect(s.hasStaleRates, isTrue);
    expect(s.totalTargetKopecks, 0);
    expect(s.contributedInPeriodKopecks, 0);
  });

  test('валютная цель приводится к базовой валюте', () async {
    final s = await run(goals: [
      analyticsGoal(id: 'g1', currency: 'USD', target: 10000, current: 5000),
    ]);

    expect(s.totalTargetKopecks, 900000);
    expect(s.totalCurrentKopecks, 450000);
    expect(s.hasStaleRates, isFalse);
  });

  test('цели, созданные в периоде, считаются отдельно', () async {
    final s = await run(goals: [
      analyticsGoal(id: 'g1', createdAt: DateTime.utc(2026, 7, 5)),
      analyticsGoal(id: 'g2', createdAt: DateTime.utc(2026, 1, 1)),
    ]);

    expect(s.goalsCreatedInPeriod, 1);
  });

  test('дельта целевой суммы: новая цель увеличивает план', () async {
    final s = await run(goals: [
      analyticsGoal(
        id: 'g1',
        target: 10000000,
        createdAt: DateTime.utc(2026, 1, 1),
      ),
      analyticsGoal(
        id: 'g2',
        target: 5000000,
        createdAt: DateTime.utc(2026, 7, 5),
      ),
    ]);

    expect(s.targetDeltaPercent, 50);
  });

  test('ошибка конвертации пробрасывается', () async {
    final broken = MockConvertCurrency();
    when(() => broken(
          amountKopecks: any(named: 'amountKopecks'),
          fromCurrency: any(named: 'fromCurrency'),
          toCurrency: any(named: 'toCurrency'),
          dateUtc: any(named: 'dateUtc'),
        )).thenThrow(Exception('rates down'));
    useCase = CalculateSavingsAnalyticsUseCase(
      convertCurrency: broken,
      logger: Logger(level: Level.off),
    );

    await expectLater(
      run(goals: [analyticsGoal(id: 'g1')]),
      throwsA(isA<Exception>()),
    );
  });
}