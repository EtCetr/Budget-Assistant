import 'package:logger/logger.dart';
import '../entities/savings_goal.dart';
import '../repositories/savings_goals_repository.dart';

/// Привязка виртуальной цели к счёту.
///
/// Используется в long-press меню для преобразования виртуальной цели в привязанную.
class LinkSavingsGoalToAccountUseCase {
  LinkSavingsGoalToAccountUseCase({
    required SavingsGoalsRepository repository,
    required Logger logger,
  })  : _repository = repository,
        _logger = logger;

  final SavingsGoalsRepository _repository;
  final Logger _logger;

  Future<void> call({
    required SavingsGoal goal,
    required String accountId,
  }) async {
    try {
      final updated = goal.copyWith(
        linkedAccountId: accountId,
        updatedAt: DateTime.now().toUtc(),
      );
      await _repository.update(updated);
    } catch (e, st) {
      _logger.e('LinkSavingsGoalToAccountUseCase failed', error: e, stackTrace: st);
      rethrow;
    }
  }
}