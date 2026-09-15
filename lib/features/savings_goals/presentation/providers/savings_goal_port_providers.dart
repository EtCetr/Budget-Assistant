import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/ports/savings_goal_progress_port.dart';
import '../../domain/repositories/savings_goals_repository.dart';
import 'savings_goals_repository_providers.dart';

final Logger _logger = Logger();

/// Реализация порта прогресса целей накопления (Этап 12).
///
/// Единственная точка, через которую CreateTransactionUseCase меняет
/// current_amount. Исключения не пробрасывает наверх: ошибка прогресса
/// не должна отменять уже созданную транзакцию.
class SavingsGoalProgressPortImpl implements SavingsGoalProgressPort {
  SavingsGoalProgressPortImpl({
    required SavingsGoalsRepository repository,
    required Logger logger,
  })  : _repository = repository,
        _logger = logger;

  final SavingsGoalsRepository _repository;
  final Logger _logger;

  @override
  Future<void> updateProgress({
    required String goalId,
    required int deltaKopecks,
    int? draftAmountKopecks,
  }) async {
    try {
      final goal = await _repository.getById(goalId);
      if (goal == null) {
        _logger.w('Savings goal not found: $goalId');
        return;
      }

      final newAmount = goal.currentAmount + deltaKopecks;
      if (newAmount < 0) {
        _logger.w('Savings goal progress would go negative: $goalId');
        return;
      }

      await _repository.updateProgress(
        goalId: goalId,
        newAmountKopecks: newAmount,
        draftAmountKopecks: draftAmountKopecks,
      );
    } catch (e, st) {
      _logger.e(
        'SavingsGoalProgressPort.updateProgress failed',
        error: e,
        stackTrace: st,
      );
    }
  }

  @override
  Future<void> markCompleted(String goalId) async {
    try {
      await _repository.markCompleted(goalId);
    } catch (e, st) {
      _logger.e(
        'SavingsGoalProgressPort.markCompleted failed',
        error: e,
        stackTrace: st,
      );
    }
  }
}

/// Порт прогресса целей для CreateTransactionUseCase.
final savingsGoalProgressPortProvider = Provider<SavingsGoalProgressPort>((ref) {
  return SavingsGoalProgressPortImpl(
    repository: ref.watch(savingsGoalsRepositoryProvider),
    logger: _logger,
  );
});