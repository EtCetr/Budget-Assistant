import 'package:logger/logger.dart';
import '../entities/savings_goal.dart';
import '../repositories/savings_goals_repository.dart';

/// Редактирование цели накопления.
///
/// Накопленный прогресс (current_amount) НЕ меняется — защита
/// от рассинхрона с историей транзакций (ТЗ 6.3.17.9).
///
/// null в newDeadline / newLinkedAccountId снимает значение:
/// дедлайн убирается, цель становится виртуальной.
class UpdateSavingsGoalUseCase {
  UpdateSavingsGoalUseCase({
    required SavingsGoalsRepository repository,
    required Logger logger,
  })  : _repository = repository,
        _logger = logger;

  final SavingsGoalsRepository _repository;
  final Logger _logger;

  Future<void> call({
    required SavingsGoal goal,
    required String newName,
    required int newTargetAmountKopecks,
    required DateTime? newDeadline,
    required String? newLinkedAccountId,
    required bool newAutoReminderEnabled,
  }) async {
    try {
      final updated = goal.copyWith(
        name: newName,
        targetAmount: newTargetAmountKopecks,
        deadline: newDeadline,
        linkedAccountId: newLinkedAccountId,
        autoReminderEnabled: newAutoReminderEnabled,
        updatedAt: DateTime.now().toUtc(),
      );
      await _repository.update(updated);
    } catch (e, st) {
      _logger.e('UpdateSavingsGoalUseCase failed', error: e, stackTrace: st);
      rethrow;
    }
  }
}