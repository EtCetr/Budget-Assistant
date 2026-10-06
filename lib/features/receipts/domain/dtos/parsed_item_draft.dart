import 'package:freezed_annotation/freezed_annotation.dart';

part 'parsed_item_draft.freezed.dart';

/// Черновик позиции чека (после OCR/ручного ввода). Деньги — копейки.
@freezed
abstract class ParsedItemDraft with _$ParsedItemDraft {
  const factory ParsedItemDraft({
    required String name,
    required double quantity,
    required int unitPriceKop,
    required int totalPriceKop,
  }) = _ParsedItemDraft;
}