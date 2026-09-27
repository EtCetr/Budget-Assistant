// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reminder_form_draft.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ReminderFormDraft _$ReminderFormDraftFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_ReminderFormDraft', json, ($checkedConvert) {
  final val = _ReminderFormDraft(
    reminderId: $checkedConvert('reminderId', (v) => v as String?),
    title: $checkedConvert('title', (v) => v as String? ?? ''),
    description: $checkedConvert('description', (v) => v as String?),
    remindAt: $checkedConvert(
      'remindAt',
      (v) => v == null ? null : DateTime.parse(v as String),
    ),
    recurrenceRule: $checkedConvert('recurrenceRule', (v) => v as String?),
    expectedAmountKopecks: $checkedConvert(
      'expectedAmountKopecks',
      (v) => (v as num?)?.toInt(),
    ),
    currency: $checkedConvert('currency', (v) => v as String? ?? 'RUB'),
    linkedCategoryId: $checkedConvert('linkedCategoryId', (v) => v as String?),
    linkedAccountId: $checkedConvert('linkedAccountId', (v) => v as String?),
    linkedRecurringId: $checkedConvert(
      'linkedRecurringId',
      (v) => v as String?,
    ),
    priority: $checkedConvert('priority', (v) => v as String? ?? 'normal'),
    scope: $checkedConvert('scope', (v) => v as String? ?? 'personal'),
    assigneeId: $checkedConvert('assigneeId', (v) => v as String?),
    autoCompleteOnPayment: $checkedConvert(
      'autoCompleteOnPayment',
      (v) => v as bool? ?? true,
    ),
  );
  return val;
});

Map<String, dynamic> _$ReminderFormDraftToJson(_ReminderFormDraft instance) =>
    <String, dynamic>{
      'reminderId': instance.reminderId,
      'title': instance.title,
      'description': instance.description,
      'remindAt': instance.remindAt?.toIso8601String(),
      'recurrenceRule': instance.recurrenceRule,
      'expectedAmountKopecks': instance.expectedAmountKopecks,
      'currency': instance.currency,
      'linkedCategoryId': instance.linkedCategoryId,
      'linkedAccountId': instance.linkedAccountId,
      'linkedRecurringId': instance.linkedRecurringId,
      'priority': instance.priority,
      'scope': instance.scope,
      'assigneeId': instance.assigneeId,
      'autoCompleteOnPayment': instance.autoCompleteOnPayment,
    };
