import 'package:logger/logger.dart';
import 'package:budget_assistant/core/errors/result.dart';
import 'package:budget_assistant/core/errors/failures.dart';
import '../entities/monthly_pnl.dart';
import '../repositories/budget_limits_repository.dart';

class CalculateMonthlyPnlUseCase {
  final BudgetLimitsRepository _repository;
  final Logger _logger;

  const CalculateMonthlyPnlUseCase({
    required BudgetLimitsRepository repository,
    required Logger logger,
  })  : _repository = repository,
        _logger = logger;

  Future<Result<MonthlyPnl>> call({
    required String userId,
    String? spaceId,
    required int year,
    required int month,
    bool excludeLargeExpenses = false,
  }) async {
    try {
      return await _repository.calculateMonthlyPnl(
        userId: userId,
        spaceId: spaceId,
        year: year,
        month: month,
        excludeLargeExpenses: excludeLargeExpenses,
      );
    } catch (e, stack) {
      _logger.e('CalculateMonthlyPnlUseCase failed', error: e, stackTrace: stack);
      return Error(Failure.database(e.toString(), stack));
    }
  }
}