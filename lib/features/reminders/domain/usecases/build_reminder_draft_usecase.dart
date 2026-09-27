import '../entities/reminder_form_draft.dart';
import 'create_reminder_usecase.dart';

/// Сборка DTO создания из формы-стейта (ТЗ 6.3.12.15.9a).
class BuildReminderDraftUseCase {
  CreateReminderParams call({
    required ReminderFormDraft draft,
    required String userId,
    String? familySpaceId,
  }) {
    final isFamily = draft.scope == 'family' && familySpaceId != null;
    final description = draft.description?.trim() ?? '';
    return CreateReminderParams(
      userId: userId,
      spaceId: isFamily ? familySpaceId : null,
      title: draft.title.trim(),
      description: description.isEmpty ? null : description,
      remindAtUtc: draft.remindAt!,
      recurrenceRule: draft.recurrenceRule,
      assigneeId: isFamily ? draft.assigneeId : null,
      linkedRecurringId: draft.linkedRecurringId,
      linkedCategoryId: draft.linkedCategoryId,
      linkedAccountId: draft.linkedAccountId,
      expectedAmount: draft.expectedAmountKopecks,
      priority: draft.priority,
    );
  }
}