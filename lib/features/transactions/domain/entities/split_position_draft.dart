import 'package:freezed_annotation/freezed_annotation.dart';
part 'split_position_draft.freezed.dart';
part 'split_position_draft.g.dart';

/// Позиция разделения транзакции (ТЗ 6.3.15): для автосохранения
/// в split_drafts (без sync) и для ValidateSplitFormUseCase.
@freezed
abstract class SplitPositionDraft with _$SplitPositionDraft {
  const factory SplitPositionDraft({
    /// id существующего сплита при переразделении; null для новых.
    String? id,
    /// Название позиции (товар из OCR или ручной ввод).
    @Default('') String name,
    /// Копейки, > 0.
    @Default(0) int amount,
    String? categoryId,
    String? description,
    /// true — позиция из OCR (название/сумма read-only).
    @Default(false) bool fromOcr,
  }) = _SplitPositionDraft;
  factory SplitPositionDraft.fromJson(Map<String, dynamic> json) =>
      _$SplitPositionDraftFromJson(json);
}