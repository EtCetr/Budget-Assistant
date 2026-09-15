// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'savings_goal_form_draft.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SavingsGoalFormDraft _$SavingsGoalFormDraftFromJson(
  Map<String, dynamic> json,
) => $checkedCreate('_SavingsGoalFormDraft', json, ($checkedConvert) {
  final val = _SavingsGoalFormDraft(
    goalId: $checkedConvert('goalId', (v) => v as String?),
    name: $checkedConvert('name', (v) => v as String? ?? ''),
    emoji: $checkedConvert('emoji', (v) => v as String? ?? ''),
    targetAmount: $checkedConvert('targetAmount', (v) => (v as num?)?.toInt()),
    currency: $checkedConvert('currency', (v) => v as String?),
    deadline: $checkedConvert(
      'deadline',
      (v) => v == null ? null : DateTime.parse(v as String),
    ),
    goalType: $checkedConvert('goalType', (v) => v as String? ?? 'virtual'),
    linkedAccountId: $checkedConvert('linkedAccountId', (v) => v as String?),
    autoReminderEnabled: $checkedConvert(
      'autoReminderEnabled',
      (v) => v as bool? ?? true,
    ),
    visibility: $checkedConvert(
      'visibility',
      (v) => v as String? ?? 'personal',
    ),
    updatedAt: $checkedConvert('updatedAt', (v) => DateTime.parse(v as String)),
  );
  return val;
});

Map<String, dynamic> _$SavingsGoalFormDraftToJson(
  _SavingsGoalFormDraft instance,
) => <String, dynamic>{
  'goalId': instance.goalId,
  'name': instance.name,
  'emoji': instance.emoji,
  'targetAmount': instance.targetAmount,
  'currency': instance.currency,
  'deadline': instance.deadline?.toIso8601String(),
  'goalType': instance.goalType,
  'linkedAccountId': instance.linkedAccountId,
  'autoReminderEnabled': instance.autoReminderEnabled,
  'visibility': instance.visibility,
  'updatedAt': instance.updatedAt.toIso8601String(),
};
