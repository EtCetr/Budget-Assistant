import 'package:logger/logger.dart';
import '../repositories/savings_goals_repository.dart';

/// Пометка цели как завершённой.
///
/// Вызывается после конфетти-анимации (пользователь подтвердил достижение).
class CompleteSavingsGoalUseCase {
  CompleteSavingsGoalUseCase({
    required SavingsGoalsRepository repository,
    required Logger logger,
  })  : _repository = repository,
        _logger = logger;

  final SavingsGoalsRepository _repository;
  final Logger _logger;

  Future<void> call(String goalId) async {
    try {
      await _repository.markCompleted(goalId);
    } catch (e, st) {
      _logger.e('CompleteSavingsGoalUseCase failed', error: e, stackTrace: st);
      rethrow;
    }
  }
}