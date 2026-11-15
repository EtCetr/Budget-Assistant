import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/errors/result.dart';
import 'package:budget_assistant/features/budget/domain/entities/monthly_pnl.dart';
import 'package:budget_assistant/features/budget/domain/usecases/calculate_monthly_pnl_usecase.dart';
import '../../../helpers/fake_budget_limits_repository.dart';

/// Этап 24: P&L UseCase пробрасывает аргументы и оборачивает ошибки.
void main() {
  late FakeBudgetLimitsRepository repo;
  late CalculateMonthlyPnlUseCase useCase;

  setUp(() {
    repo = FakeBudgetLimitsRepository();
    useCase = CalculateMonthlyPnlUseCase(
      repository: repo,
      logger: Logger(level: Level.off),
    );
  });

  test('доходы, расходы и норма сбережений приходят из репозитория', () async {
    repo.pnlIncome = 10000000;
    repo.pnlExpense = 4000000;

    final result = await useCase(userId: 'u1', year: 2026, month: 7);
    final pnl = (result as Success<MonthlyPnl>).value;

    expect(pnl.totalIncome, 10000000);
    expect(pnl.totalExpense, 4000000);
    expect(pnl.savingsRate, 60);
  });

  test('нулевой доход: норма сбережений 0', () async {
    repo.pnlIncome = 0;
    repo.pnlExpense = 500000;

    final result = await useCase(userId: 'u1', year: 2026, month: 7);

    expect((result as Success<MonthlyPnl>).value.savingsRate, 0);
  });

  test('аргументы, включая «без крупных трат», пробрасываются', () async {
    await useCase(
      userId: 'u1',
      spaceId: 's1',
      year: 2026,
      month: 7,
      excludeLargeExpenses: true,
    );

    expect(repo.lastUserId, 'u1');
    expect(repo.lastSpaceId, 's1');
    expect(repo.lastYear, 2026);
    expect(repo.lastMonth, 7);
    expect(repo.lastExcludeLarge, isTrue);
  });

  test('ошибка репозитория возвращается как Error', () async {
    repo.error = Exception('db down');

    final result = await useCase(userId: 'u1', year: 2026, month: 7);

    expect(result, isA<Error<MonthlyPnl>>());
  });
}