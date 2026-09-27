import '../entities/reminder_form_draft.dart';

/// Клиентская валидация формы напоминания (ТЗ 6.3.12.15.8).
/// Возвращает текст первой ошибки или null.
class ValidateReminderFormUseCase {
  String? call({
    required ReminderFormDraft draft,
    required bool isNew,
    required DateTime nowUtc,
  }) {
    final title = draft.title.trim();
    if (title.isEmpty) return 'Укажите название';
    if (title.length > 100) return 'Название: не более 100 символов';
    final description = draft.description?.trim() ?? '';
    if (description.length > 500) return 'Описание: не более 500 символов';
    final remindAt = draft.remindAt;
    if (remindAt == null) return 'Укажите дату и время';
    if (isNew && remindAt.isBefore(nowUtc)) return 'Дата должна быть в будущем';
    final amount = draft.expectedAmountKopecks;
    if (amount != null && amount <= 0) return 'Сумма должна быть больше 0';
    if (draft.scope == 'personal' && draft.assigneeId != null) {
      return 'Ответственный возможен только для семейной области';
    }
    return null;
  }
}