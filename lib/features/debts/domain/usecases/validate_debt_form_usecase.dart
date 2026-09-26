import 'package:budget_assistant/core/logger.dart';
import '../entities/debt_form_draft.dart';

/// Валидация формы долга (6.3.14.13): возврат текста ошибки или null.
class ValidateDebtFormUseCase {
  String? call(DebtFormDraft draft) {
    try {
      final members = draft.selectedMemberIds;
      final external = draft.externalNameDative.trim();
      if (members.isEmpty && external.isEmpty) {
        return 'Выберите члена семьи или укажите имя контрагента';
      }
      if (members.isEmpty && external.length > 50) {
        return 'Имя не должно превышать 50 символов';
      }
      final amount = draft.amount;
      if (amount == null || amount <= 0) {
        return 'Сумма должна быть больше нуля';
      }
      if (members.length > 1 && amount < members.length) {
        return 'Сумма слишком мала для деления на ${members.length}';
      }
      if (draft.description.length > 200) {
        return 'Описание не должно превышать 200 символов';
      }
      final due = draft.dueDate;
      if (due != null && draft.debtId == null) {
        final now = DateTime.now();
        final today = DateTime(now.year, now.month, now.day);
        final dueDay = DateTime(due.year, due.month, due.day);
        if (dueDay.isBefore(today)) {
          return 'Срок погашения должен быть не раньше сегодня';
        }
      }
      return null;
    } catch (e, st) {
      AppLogger.e('ValidateDebtFormUseCase failed: $e', e, st);
      rethrow;
    }
  }
}