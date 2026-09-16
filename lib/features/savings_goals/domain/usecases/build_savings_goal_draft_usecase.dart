import 'package:logger/logger.dart';

import '../entities/savings_goal_form_draft.dart';

/// Построение DTO из формы создания/редактирования цели.
///
/// Используется перед валидацией и сохранением.
class BuildSavingsGoalDraftUseCase {
  BuildSavingsGoalDraftUseCase({required Logger logger}) : _logger = logger;

  final Logger _logger;

  SavingsGoalFormDraft call({
    String? goalId,
    required String name,
    required String emoji,
    required int targetAmountKopecks,
    required String currency,
    DateTime? deadline,
    required String goalType,
    String? linkedAccountId,
    required bool autoReminderEnabled,
    required String visibility,
    // 12.5.1: параметры чекбокса зачисления баланса.
    bool seedBalanceOnCreate = true,
    int? seedAmountKopecks,
  }) {
    try {
      return SavingsGoalFormDraft(
        goalId: goalId,
        name: name,
        emoji: emoji,
        targetAmount: targetAmountKopecks,
        currency: currency,
        deadline: deadline,
        goalType: goalType,
        linkedAccountId: linkedAccountId,
        autoReminderEnabled: autoReminderEnabled,
        visibility: visibility,
        seedBalanceOnCreate: seedBalanceOnCreate,
        seedAmountKopecks: seedAmountKopecks,
        updatedAt: DateTime.now().toUtc(),
      );
    } catch (e, st) {
      _logger.e('BuildSavingsGoalDraftUseCase failed', error: e, stackTrace: st);
      rethrow;
    }
  }
}