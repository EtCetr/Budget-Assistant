import 'package:logger/logger.dart';
import '../repositories/savings_goals_repository.dart';

/// Единственная точка изменения current_amount.
///
/// Вызывается CreateTransactionUseCase при создании транзакции с
/// savings_goal_id != null. Защищает от рассинхрона с историей транзакций.
class UpdateSavingsGoalProgressUseCase {
  UpdateSavingsGoalProgressUseCase({
    required SavingsGoalsRepository repository,
    required Logger logger,
  })  : _repository = repository,
        _logger = logger;

  final SavingsGoalsRepository _repository;
  final Logger _logger;

  /// Обновляет current_amount на deltaKopecks.
  ///
  /// deltaKopecks: +amount для пополнения, -amount для изъятия.
  /// draftAmountKopecks: если != null, обновляет draft_amount (автоподстановка).
  ///
  /// Возвращает true, если цель достигнута (current >= target) впервые.
  Future<bool> call({
    required String goalId,
    required int deltaKopecks,
    int? draftAmountKopecks,
  }) async {
    try {
      final goal = await _repository.getById(goalId);
      if (goal == null) {
        _logger.w('Goal not found: $goalId');
        return false;
      }

      final newAmount = goal.currentAmount + deltaKopecks;
      if (newAmount < 0) {
        _logger.w('Cannot withdraw more than current_amount');
        return false;
      }

      await _repository.updateProgress(
        goalId: goalId,
        newAmountKopecks: newAmount,
        draftAmountKopecks: draftAmountKopecks,
      );

      // Проверяем, достигнута ли цель впервые.
      final wasReached = goal.currentAmount < goal.targetAmount;
      final isReached = newAmount >= goal.targetAmount;
      return wasReached && isReached;
    } catch (e, st) {
      _logger.e('UpdateSavingsGoalProgressUseCase failed', error: e, stackTrace: st);
      rethrow;
    }
  }
}