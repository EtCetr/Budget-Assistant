import 'package:freezed_annotation/freezed_annotation.dart';

part 'reminder_form_draft.freezed.dart';
part 'reminder_form_draft.g.dart';

/// Черновик формы напоминания (автосейв каждые 5 сек, ТОМ 2 §23.3).
@freezed
abstract class ReminderFormDraft with _$ReminderFormDraft {
  const factory ReminderFormDraft({
    String? reminderId,
    @Default('') String title,
    String? description,
    DateTime? remindAt,
    String? recurrenceRule,
    int? expectedAmountKopecks,
    @Default('RUB') String currency,
    String? linkedCategoryId,
    String? linkedAccountId,
    String? linkedRecurringId,
    @Default('normal') String priority,
    @Default('personal') String scope,
    String? assigneeId,
    @Default(true) bool autoCompleteOnPayment,
  }) = _ReminderFormDraft;

  factory ReminderFormDraft.fromJson(Map<String, dynamic> json) =>
      _$ReminderFormDraftFromJson(json);
}