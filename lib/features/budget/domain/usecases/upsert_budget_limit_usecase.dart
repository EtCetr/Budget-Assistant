import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
import 'package:budget_assistant/core/errors/result.dart';
import 'package:budget_assistant/core/errors/failures.dart';
import '../entities/budget_limit.dart';
import '../repositories/budget_limits_repository.dart';

class UpsertBudgetLimitUseCase {
  final BudgetLimitsRepository _repository;
  final Logger _logger;

  const UpsertBudgetLimitUseCase({
    required BudgetLimitsRepository repository,
    required Logger logger,
  })  : _repository = repository,
        _logger = logger;

  Future<Result<BudgetLimit>> call({
    String? id,
    String? spaceId,
    required String userId,
    required String categoryId,
    required int year,
    required int month,
    required int limitAmount,
    int alertPercent = 80,
    int alertAmount = 0,
  }) async {
    try {
      final nowUtc = DateTime.now().toUtc();
      final limitId = id ?? const Uuid().v4();

      final limit = BudgetLimit(
        id: limitId,
        spaceId: spaceId,
        userId: userId,
        categoryId: categoryId,
        year: year,
        month: month,
        limitAmount: limitAmount,
        alertPercent: alertPercent,
        alertAmount: alertAmount,
        createdAt: nowUtc,
        updatedAt: nowUtc,
        syncStatus: 'pending',
      );

      return await _repository.upsert(limit);
    } catch (e, stack) {
      _logger.e('UpsertBudgetLimitUseCase failed', error: e, stackTrace: stack);
      return Error(Failure.database(e.toString(), stack));
    }
  }
}