import 'package:logger/logger.dart';
import '../repositories/savings_goals_repository.dart';

/// Восстановление цели из архива.
///
/// Цель возвращается в список активных.
class RestoreSavingsGoalUseCase {
  RestoreSavingsGoalUseCase({
    required SavingsGoalsRepository repository,
    required Logger logger,
  })  : _repository = repository,
        _logger = logger;

  final SavingsGoalsRepository _repository;
  final Logger _logger;

  Future<void> call(String goalId) async {
    try {
      await _repository.restore(goalId);
    } catch (e, st) {
      _logger.e('RestoreSavingsGoalUseCase failed', error: e, stackTrace: st);
      rethrow;
    }
  }
}