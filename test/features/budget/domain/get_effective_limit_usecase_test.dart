import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/errors/result.dart';
import 'package:budget_assistant/features/budget/domain/entities/effective_limit.dart';
import 'package:budget_assistant/features/budget/domain/usecases/get_effective_limit_usecase.dart';
import '../../../helpers/fake_budget_limits_repository.dart';

/// Этап 24: плавающие лимиты (ТОМ 4 §2.1) — наследование и перенос остатка.
void main() {
  late FakeBudgetLimitsRepository repo;
  late GetEffectiveLimitUseCase useCase;

  setUp(() {
    repo = FakeBudgetLimitsRepository();
    useCase = GetEffectiveLimitUseCase(
      repository: repo,
      logger: Logger(level: Level.off),
    );
  });

  Future<EffectiveLimit> run({
    int year = 2026,
    int month = 7,
    bool inherit = false,
    bool carry = false,
  }) async {
    final result = await useCase(
      userId: 'u1',
      spaceId: null,
      categoryId: 'c1',
      year: year,
      month: month,
      inheritLimit: inherit,
      carryOverUnused: carry,
    );
    return (result as Success<EffectiveLimit>).value;
  }

  test('заданный лимит месяца берётся как есть', () async {
    repo.putLimit(year: 2026, month: 7, categoryId: 'c1', kopecks: 2000000);
    repo.putExpense(year: 2026, month: 7, categoryId: 'c1', kopecks: 500000);

    final e = await run();

    expect(e.baseLimit, 2000000);
    expect(e.inheritedFromPrevious, isFalse);
    expect(e.carriedOver, 0);
    expect(e.effectiveTotal, 2000000);
    expect(e.spent, 500000);
    expect(e.remaining, 1500000);
    expect(e.percentUsed, 25);
  });

  test('наследование: лимит прошлого месяца, если текущий не задан', () async {
    repo.putLimit(year: 2026, month: 6, categoryId: 'c1', kopecks: 1000000);

    final e = await run(inherit: true);

    expect(e.inheritedFromPrevious, isTrue);
    expect(e.effectiveTotal, 1000000);
  });

  test('наследование выключено: лимит не подставляется', () async {
    repo.putLimit(year: 2026, month: 6, categoryId: 'c1', kopecks: 1000000);

    final e = await run();

    expect(e.inheritedFromPrevious, isFalse);
    expect(e.effectiveTotal, 0);
  });

  test('перенос остатка: неиспользованное добавляется к лимиту', () async {
    repo.putLimit(year: 2026, month: 7, categoryId: 'c1', kopecks: 2000000);
    repo.putLimit(year: 2026, month: 6, categoryId: 'c1', kopecks: 1000000);
    repo.putExpense(year: 2026, month: 6, categoryId: 'c1', kopecks: 400000);

    final e = await run(carry: true);

    expect(e.carriedOver, 600000);
    expect(e.effectiveTotal, 2600000);
  });

  test('перерасход прошлого месяца не переносится', () async {
    repo.putLimit(year: 2026, month: 7, categoryId: 'c1', kopecks: 2000000);
    repo.putLimit(year: 2026, month: 6, categoryId: 'c1', kopecks: 1000000);
    repo.putExpense(year: 2026, month: 6, categoryId: 'c1', kopecks: 1200000);

    final e = await run(carry: true);

    expect(e.carriedOver, 0);
    expect(e.effectiveTotal, 2000000);
  });

  test('наследование и перенос работают вместе', () async {
    repo.putLimit(year: 2026, month: 6, categoryId: 'c1', kopecks: 1000000);
    repo.putExpense(year: 2026, month: 6, categoryId: 'c1', kopecks: 400000);

    final e = await run(inherit: true, carry: true);

    expect(e.inheritedFromPrevious, isTrue);
    expect(e.carriedOver, 600000);
    expect(e.effectiveTotal, 1600000);
  });

  test('январь смотрит на декабрь прошлого года', () async {
    repo.putLimit(year: 2025, month: 12, categoryId: 'c1', kopecks: 1000000);

    final e = await run(year: 2026, month: 1, inherit: true);

    expect(e.inheritedFromPrevious, isTrue);
    expect(e.effectiveTotal, 1000000);
  });

  test('нулевой лимит: процент использования 0, а не деление на ноль', () async {
    final e = await run();

    expect(e.effectiveTotal, 0);
    expect(e.percentUsed, 0);
  });

  test('перерасход текущего месяца: остаток отрицательный', () async {
    repo.putLimit(year: 2026, month: 7, categoryId: 'c1', kopecks: 1000000);
    repo.putExpense(year: 2026, month: 7, categoryId: 'c1', kopecks: 1500000);

    final e = await run();

    expect(e.remaining, -500000);
    expect(e.percentUsed, 150);
  });

  test('ошибка репозитория возвращается как Error', () async {
    repo.error = Exception('db down');

    final result = await useCase(
      userId: 'u1',
      categoryId: 'c1',
      year: 2026,
      month: 7,
      inheritLimit: false,
      carryOverUnused: false,
    );

    expect(result, isA<Error<EffectiveLimit>>());
  });
}