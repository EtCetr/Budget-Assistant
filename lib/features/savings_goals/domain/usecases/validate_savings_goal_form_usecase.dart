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

  /// [linkedAccountBalanceKopecks] — баланс выбранного счёта для проверки
  /// суммы зачисления (микро-коммит 12.5.1, Вариант Б).
  String? call(SavingsGoalFormDraft draft, {int? linkedAccountBalanceKopecks}) {
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

      // Сумма зачисления баланса счёта (12.5.1, Вариант Б):
      // пустое поле = 100% баланса (валидно); если указана — > 0 и не больше баланса.
      if (draft.goalType == 'linked' &&
          draft.seedBalanceOnCreate &&
          draft.seedAmountKopecks != null) {
        if (draft.seedAmountKopecks! <= 0) {
          return 'Сумма зачисления должна быть больше нуля';
        }
        if (linkedAccountBalanceKopecks != null &&
            draft.seedAmountKopecks! > linkedAccountBalanceKopecks) {
          return 'Сумма зачисления не может превышать баланс счёта';
        }
      }

      return null;
    } catch (e, st) {
      _logger.e('ValidateSavingsGoalFormUseCase failed', error: e, stackTrace: st);
      rethrow;
    }
  }
}