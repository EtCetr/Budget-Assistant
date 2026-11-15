import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:budget_assistant/features/cashback/domain/usecases/convert_currency_usecase.dart';
import 'package:budget_assistant/features/savings_goals/domain/entities/savings_goal.dart';
import 'package:budget_assistant/features/savings_goals/domain/usecases/calculate_archive_stats_usecase.dart';
import 'package:budget_assistant/features/savings_goals/domain/usecases/calculate_savings_goals_summary_usecase.dart';
import 'package:budget_assistant/features/savings_goals/domain/usecases/calculate_savings_plan_usecase.dart';
import 'package:budget_assistant/features/savings_goals/domain/usecases/sort_goals_table_usecase.dart';
import '../../../helpers/fake_savings_goals_repository.dart';

class _MockConvert extends Mock implements ConvertCurrencyUseCase {}

/// Этап 24: математика целей — прогресс, план накопления, сводки,
/// мультивалютная агрегация и сортировка таблицы.
void main() {
  late _MockConvert convert;
  late Logger logger;

  setUpAll(() {
    registerFallbackValue(DateTime.utc(2026));
  });

  setUp(() {
    convert = _MockConvert();
    logger = Logger(level: Level.off);
    when(() => convert(
          amountKopecks: any(named: 'amountKopecks'),
          fromCurrency: any(named: 'fromCurrency'),
          toCurrency: any(named: 'toCurrency'),
          dateUtc: any(named: 'dateUtc'),
        )).thenAnswer((inv) async {
      final amount = inv.namedArguments[#amountKopecks] as int;
      return amount * 90;
    });
  });

  group('SavingsGoal: признаки и прогресс', () {
    test('виртуальная цель — без привязки к счёту', () {
      expect(makeGoal(id: 'g').isVirtual, isTrue);
      expect(makeGoal(id: 'g', linkedAccountId: 'a1').isVirtual, isFalse);
    });

    test('активна только неархивная цель в статусе active', () {
      expect(makeGoal(id: 'g').isActive, isTrue);
      expect(makeGoal(id: 'g', isArchived: true).isActive, isFalse);
      expect(
        makeGoal(id: 'g', status: SavingsGoalStatus.completed).isActive,
        isFalse,
      );
    });

    test('достижение цели по накопленному', () {
      expect(makeGoal(id: 'g', current: 9999999).isReached, isFalse);
      expect(makeGoal(id: 'g', current: 10000000).isReached, isTrue);
      expect(makeGoal(id: 'g', target: 0, current: 0).isReached, isFalse);
    });

    test('процент прогресса: округление вниз и потолок 100', () {
      expect(makeGoal(id: 'g', current: 5000000).progressPercent, 50);
      expect(makeGoal(id: 'g', target: 3, current: 1).progressPercent, 33);
      expect(makeGoal(id: 'g', current: 20000000).progressPercent, 100);
      expect(makeGoal(id: 'g', target: 0).progressPercent, 0);
    });
  });

  group('CalculateSavingsPlanUseCase', () {
    late CalculateSavingsPlanUseCase useCase;

    setUp(() {
      useCase = CalculateSavingsPlanUseCase(logger: logger);
    });

    test('нулевая цель — нулевой план', () {
      final plan = useCase(targetAmountKopecks: 0);

      expect(plan.monthlyAmountKopecks, 0);
      expect(plan.yearlyAmountKopecks, 0);
      expect(plan.monthsUntilDeadline, isNull);
    });

    test('без дедлайна: план на 10 лет и на год', () {
      final plan = useCase(targetAmountKopecks: 12000000);

      expect(plan.monthlyAmountKopecks, 100000);
      expect(plan.yearlyAmountKopecks, 1200000);
      expect(plan.monthsUntilDeadline, isNull);
    });

    test('с дедлайном: сумма делится на число месяцев', () {
      final now = DateTime.now();
      final deadline = DateTime(now.year, now.month + 3, 1);

      final plan = useCase(
        targetAmountKopecks: 9000000,
        deadline: deadline,
      );

      expect(plan.monthsUntilDeadline, 3);
      expect(plan.monthlyAmountKopecks, 3000000);
      expect(plan.yearlyAmountKopecks, 36000000);
    });

    test('дедлайн в прошлом — план обнуляется', () {
      final now = DateTime.now();

      final plan = useCase(
        targetAmountKopecks: 9000000,
        deadline: DateTime(now.year, now.month - 1, 1),
      );

      expect(plan.monthsUntilDeadline, 0);
      expect(plan.monthlyAmountKopecks, 0);
    });
  });

  group('CalculateSavingsGoalsSummaryUseCase', () {
    late CalculateSavingsGoalsSummaryUseCase useCase;

    setUp(() {
      useCase = CalculateSavingsGoalsSummaryUseCase(
        convertCurrency: convert,
        logger: logger,
      );
    });

    test('пустой список — нулевая сводка', () async {
      final s = await useCase(baseCurrency: 'RUB', goals: const []);

      expect(s.count, 0);
      expect(s.totalTargetKopecks, 0);
      expect(s.totalCurrentKopecks, 0);
      expect(s.averageProgressPercent, 0);
      expect(s.overallProgressPercent, 0);
      expect(s.hasStaleRates, isFalse);
    });

    test('одна валюта: суммы складываются без конвертации', () async {
      final s = await useCase(baseCurrency: 'RUB', goals: [
        makeGoal(id: 'g1', target: 10000000, current: 5000000),
        makeGoal(id: 'g2', target: 20000000, current: 10000000),
      ]);

      expect(s.count, 2);
      expect(s.totalTargetKopecks, 30000000);
      expect(s.totalCurrentKopecks, 15000000);
      expect(s.averageProgressPercent, 50);
      expect(s.overallProgressPercent, 50);
      expect(s.hasStaleRates, isFalse);
      verifyNever(() => convert(
            amountKopecks: any(named: 'amountKopecks'),
            fromCurrency: any(named: 'fromCurrency'),
            toCurrency: any(named: 'toCurrency'),
            dateUtc: any(named: 'dateUtc'),
          ));
    });

    test('другая валюта приводится к базовой по курсу', () async {
      final s = await useCase(baseCurrency: 'RUB', goals: [
        makeGoal(id: 'g1', currency: 'USD', target: 10000, current: 5000),
      ]);

      expect(s.totalTargetKopecks, 900000);
      expect(s.totalCurrentKopecks, 450000);
      expect(s.hasStaleRates, isFalse);
    });

    test('курса нет — флаг устаревших курсов', () async {
      when(() => convert(
            amountKopecks: any(named: 'amountKopecks'),
            fromCurrency: any(named: 'fromCurrency'),
            toCurrency: any(named: 'toCurrency'),
            dateUtc: any(named: 'dateUtc'),
          )).thenAnswer((_) async => null);

      final s = await useCase(baseCurrency: 'RUB', goals: [
        makeGoal(id: 'g1', currency: 'USD', target: 10000, current: 5000),
      ]);

      expect(s.hasStaleRates, isTrue);
      expect(s.totalTargetKopecks, 0);
      expect(s.totalCurrentKopecks, 0);
    });
  });

  group('CalculateArchiveStatsUseCase', () {
    late CalculateArchiveStatsUseCase useCase;

    setUp(() {
      useCase = CalculateArchiveStatsUseCase(
        convertCurrency: convert,
        logger: logger,
      );
    });

    test('пустой архив — нулевая статистика', () async {
      final s = await useCase(goals: const [], baseCurrency: 'RUB');

      expect(s.totalSavedKopecks, 0);
      expect(s.averageProgressPercent, 0);
      expect(s.hasStaleRates, isFalse);
    });

    test('сумма накопленного и средний прогресс', () async {
      final s = await useCase(baseCurrency: 'RUB', goals: [
        makeGoal(id: 'g1', current: 5000000),
        makeGoal(id: 'g2', current: 10000000),
      ]);

      expect(s.totalSavedKopecks, 15000000);
      expect(s.averageProgressPercent, 75);
    });

    test('нет курса — флаг устаревших курсов', () async {
      when(() => convert(
            amountKopecks: any(named: 'amountKopecks'),
            fromCurrency: any(named: 'fromCurrency'),
            toCurrency: any(named: 'toCurrency'),
            dateUtc: any(named: 'dateUtc'),
          )).thenAnswer((_) async => null);

      final s = await useCase(baseCurrency: 'RUB', goals: [
        makeGoal(id: 'g1', currency: 'USD', current: 5000),
      ]);

      expect(s.hasStaleRates, isTrue);
      expect(s.totalSavedKopecks, 0);
    });
  });

  group('SortGoalsTableUseCase', () {
    late SortGoalsTableUseCase useCase;
    late List<SavingsGoal> goals;

    setUp(() {
      useCase = SortGoalsTableUseCase(logger: logger);
      goals = [
        makeGoal(id: 'b', name: 'Отпуск', target: 20000000, current: 1000000),
        makeGoal(id: 'a', name: 'Авто', target: 10000000, current: 9000000),
        makeGoal(id: 'c', name: 'Банк', target: 30000000, current: 0),
      ];
    });

    List<String> ids(List<SavingsGoal> list) => list.map((g) => g.id).toList();

    test('по названию: возрастание и убывание', () {
      expect(
        ids(useCase(goals: goals, field: GoalSortField.name, ascending: true)),
        ['a', 'c', 'b'],
      );
      expect(
        ids(useCase(goals: goals, field: GoalSortField.name, ascending: false)),
        ['b', 'c', 'a'],
      );
    });

    test('по целевой сумме', () {
      expect(
        ids(useCase(goals: goals, field: GoalSortField.target, ascending: true)),
        ['a', 'b', 'c'],
      );
    });

    test('по накопленному', () {
      expect(
        ids(useCase(
          goals: goals,
          field: GoalSortField.current,
          ascending: false,
        )),
        ['a', 'b', 'c'],
      );
    });

    test('по прогрессу', () {
      expect(
        ids(useCase(
          goals: goals,
          field: GoalSortField.progress,
          ascending: false,
        )),
        ['a', 'b', 'c'],
      );
    });

    test('по дедлайну: цели без дедлайна в конце', () {
      final withDeadlines = [
        makeGoal(id: 'none'),
        makeGoal(id: 'late', deadline: DateTime.utc(2027, 6, 1)),
        makeGoal(id: 'soon', deadline: DateTime.utc(2027, 1, 1)),
      ];

      expect(
        ids(useCase(
          goals: withDeadlines,
          field: GoalSortField.deadline,
          ascending: true,
        )),
        ['soon', 'late', 'none'],
      );
    });

    test('исходный список не мутируется', () {
      final before = ids(goals);
      useCase(goals: goals, field: GoalSortField.name, ascending: true);

      expect(ids(goals), before);
    });
  });
}