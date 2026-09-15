/// Порт домена: обновление прогресса цели накопления.
///
/// Реализация — в data-слое (SavingsGoalsRepository).
/// Используется CreateTransactionUseCase для обновления current_amount
/// при создании транзакции с savings_goal_id != null.
///
/// Это защита от круговых импортов: transactions не импортируют savings_goals.
abstract interface class SavingsGoalProgressPort {
  /// Обновляет current_amount цели.
  ///
  /// deltaKopecks: +amount для пополнения, -amount для изъятия.
  /// draftAmountKopecks: если != null, обновляет draft_amount (автоподстановка).
  Future<void> updateProgress({
    required String goalId,
    required int deltaKopecks,
    int? draftAmountKopecks,
  });

  /// Помечает цель как завершённую (current_amount >= target_amount).
  Future<void> markCompleted(String goalId);
}