import 'package:freezed_annotation/freezed_annotation.dart';

part 'savings_goal_form_draft.freezed.dart';
part 'savings_goal_form_draft.g.dart';

/// Состояние формы создания/редактирования цели для автосохранения
/// в локальную таблицу savings_goal_drafts (без синхронизации, ТОМ 2 §23).
@freezed
abstract class SavingsGoalFormDraft with _$SavingsGoalFormDraft {
  const factory SavingsGoalFormDraft({
    /// null при создании, id цели при редактировании.
    String? goalId,
    @Default('') String name,

    /// Эмодзи хранится отдельно в форме, в БД склеивается с названием.
    @Default('') String emoji,

    /// Копейки.
    int? targetAmount,
    String? currency,
    DateTime? deadline,

    /// 'virtual' | 'linked'.
    @Default('virtual') String goalType,
    String? linkedAccountId,
    @Default(true) bool autoReminderEnabled,

    /// 'personal' | 'family'.
    @Default('personal') String visibility,
    required DateTime updatedAt,
  }) = _SavingsGoalFormDraft;

  factory SavingsGoalFormDraft.fromJson(Map<String, dynamic> json) =>
      _$SavingsGoalFormDraftFromJson(json);
}