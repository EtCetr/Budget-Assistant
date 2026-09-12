import 'package:logger/logger.dart';
import 'package:budget_assistant/core/errors/result.dart';
import 'package:budget_assistant/core/errors/failures.dart';
import '../repositories/budget_limits_repository.dart';

class DeleteBudgetLimitUseCase {
  final BudgetLimitsRepository _repository;
  final Logger _logger;

  const DeleteBudgetLimitUseCase({
    required BudgetLimitsRepository repository,
    required Logger logger,
  })  : _repository = repository,
        _logger = logger;

  Future<Result<void>> call(String id) async {
    try {
      return await _repository.delete(id);
    } catch (e, stack) {
      _logger.e('DeleteBudgetLimitUseCase failed', error: e, stackTrace: stack);
      return Error(Failure.database(e.toString(), stack));
    }
  }
}