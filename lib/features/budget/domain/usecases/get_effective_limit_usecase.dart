import 'package:logger/logger.dart';
import 'package:budget_assistant/core/errors/result.dart';
import 'package:budget_assistant/core/errors/failures.dart';
import '../entities/effective_limit.dart';
import '../repositories/budget_limits_repository.dart';

class GetEffectiveLimitUseCase {
  final BudgetLimitsRepository _repository;
  final Logger _logger;

  const GetEffectiveLimitUseCase({
    required BudgetLimitsRepository repository,
    required Logger logger,
  })  : _repository = repository,
        _logger = logger;

  Future<Result<EffectiveLimit>> call({
    required String userId,
    String? spaceId,
    required String categoryId,
    required int year,
    required int month,
    required bool inheritLimit,
    required bool carryOverUnused,
  }) async {
    try {
      final currentLimit = await _repository.getForCategory(
        userId: userId,
        spaceId: spaceId,
        categoryId: categoryId,
        year: year,
        month: month,
      );

      int prevYear = year;
      int prevMonth = month - 1;
      if (prevMonth < 1) {
        prevMonth = 12;
        prevYear--;
      }

      final prevLimit = await _repository.getForCategory(
        userId: userId,
        spaceId: spaceId,
        categoryId: categoryId,
        year: prevYear,
        month: prevMonth,
      );

      final currentExpenseResult = await _repository.calculateCategoryExpense(
        userId: userId,
        spaceId: spaceId,
        categoryId: categoryId,
        year: year,
        month: month,
      );
      final currentExpense = currentExpenseResult.fold(
        onSuccess: (value) => value,
        onError: (_) => 0,
      );

      int baseLimit = currentLimit?.limitAmount ?? 0;
      bool inherited = false;
      int carriedOver = 0;

      if (currentLimit == null && inheritLimit && prevLimit != null) {
        baseLimit = prevLimit.limitAmount;
        inherited = true;
      }

      if (carryOverUnused && prevLimit != null) {
        final prevExpenseResult = await _repository.calculateCategoryExpense(
          userId: userId,
          spaceId: spaceId,
          categoryId: categoryId,
          year: prevYear,
          month: prevMonth,
        );
        final prevExpense = prevExpenseResult.fold(
          onSuccess: (value) => value,
          onError: (_) => 0,
        );
        final unused = prevLimit.limitAmount - prevExpense;
        if (unused > 0) {
          carriedOver = unused;
          baseLimit += unused;
        }
      }

      final effectiveTotal = baseLimit;
      final spent = currentExpense;
      final remaining = effectiveTotal - spent;
      int percentUsed = 0;
      if (effectiveTotal > 0) {
        percentUsed = (spent * 100) ~/ effectiveTotal;
      }

      return Success(EffectiveLimit(
        categoryId: categoryId,
        baseLimit: currentLimit?.limitAmount ?? 0,
        inheritedFromPrevious: inherited,
        carriedOver: carriedOver,
        effectiveTotal: effectiveTotal,
        spent: spent,
        remaining: remaining,
        percentUsed: percentUsed,
      ));
    } catch (e, stack) {
      _logger.e('GetEffectiveLimitUseCase failed', error: e, stackTrace: stack);
      return Error(Failure.database(e.toString(), stack));
    }
  }
}