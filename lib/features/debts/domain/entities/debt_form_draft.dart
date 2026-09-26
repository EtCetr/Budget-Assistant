import 'package:freezed_annotation/freezed_annotation.dart';
part 'debt_form_draft.freezed.dart';
part 'debt_form_draft.g.dart';

/// Состояние формы создания/редактирования долга для автосохранения
/// в локальную таблицу debt_drafts (без синхронизации, ТОМ 2 §23).
@freezed
abstract class DebtFormDraft with _$DebtFormDraft {
  const factory DebtFormDraft({
    /// null при создании, id долга при редактировании.
    String? debtId,
    /// 'payable' | 'receivable'.
    @Default('payable') String debtType,
    /// 'family_member' | 'external'.
    @Default('family_member') String counterpartyType,
    /// user_id выбранных членов семьи (множественный выбор).
    @Default(<String>[]) List<String> selectedMemberIds,
    /// Имя внешнего контрагента в дательном (как ввёл пользователь).
    @Default('') String externalNameDative,
    /// Копейки.
    int? amount,
    @Default('RUB') String currency,
    String? categoryId,
    @Default('') String description,
    DateTime? dueDate,
    String? originalTransactionId,
    String? splitId,
    /// Авто-закрытие долга при появлении связанной транзакции.
    @Default(true) bool autoResolveOnLink,
    required DateTime updatedAt,
  }) = _DebtFormDraft;
  factory DebtFormDraft.fromJson(Map<String, dynamic> json) =>
      _$DebtFormDraftFromJson(json);
}