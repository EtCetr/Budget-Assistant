import 'package:freezed_annotation/freezed_annotation.dart';
import 'parsed_item_draft.dart';

part 'parsed_receipt_draft.freezed.dart';

/// Черновик чека после разбора QR/OCR-текста.
@freezed
abstract class ParsedReceiptDraft with _$ParsedReceiptDraft {
  const factory ParsedReceiptDraft({
    String? storeName,
    int? totalKop,
    required List<ParsedItemDraft> items,
  }) = _ParsedReceiptDraft;
}