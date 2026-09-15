import 'package:logger/logger.dart';
import '../entities/savings_goal_form_draft.dart';

/// Валидация формы создания/редактирования цели.
///
/// Возвращает:
/// - null, если ошибок нет;
/// - текст ошибки, если валидация провалилась.
class ValidateSavingsGoalFormUseCase {
  ValidateSavingsGoalFormUseCase({required Logger logger}) : _logger = logger;

  final Logger _logger;

  String? call(SavingsGoalFormDraft draft) {
    try {
      // Имя: обязательное, 1-50 символов
      final name = draft.name.trim();
      if (name.isEmpty) {
        return 'Название цели обязательно';
      }
      if (name.length > 50) {
        return 'Название не должно превышать 50 символов';
      }

      // Целевая сумма: обязательная, > 0
      if (draft.targetAmount == null || draft.targetAmount! <= 0) {
        return 'Целевая сумма должна быть больше нуля';
      }

      // Дедлайн: если указан, должен быть > сегодня (для новых целей)
      if (draft.deadline != null && draft.goalId == null) {
        final today = DateTime.now();
        final todayUtc = DateTime.utc(today.year, today.month, today.day);
        final deadlineUtc = DateTime.utc(
          draft.deadline!.year,
          draft.deadline!.month,
          draft.deadline!.day,
        );
        if (deadlineUtc.isBefore(todayUtc) || deadlineUtc.isAtSameMomentAs(todayUtc)) {
          return 'Дедлайн должен быть в будущем';
        }
      }

      // Привязанная цель: обязательно выбрать счёт
      if (draft.goalType == 'linked' && draft.linkedAccountId == null) {
        return 'Выберите счёт для привязанной цели';
      }

      return null;
    } catch (e, st) {
      _logger.e('ValidateSavingsGoalFormUseCase failed', error: e, stackTrace: st);
      rethrow;
    }
  }
}