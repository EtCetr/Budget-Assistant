import 'package:freezed_annotation/freezed_annotation.dart';

part 'receipt_category_lookup.freezed.dart';

/// Категория для dropdown позиций чека (открытые метаданные).
@freezed
abstract class ReceiptCategoryLookup with _$ReceiptCategoryLookup {
  const factory ReceiptCategoryLookup({
    required String id,
    required String name,
    String? iconEmoji,
    String? colorHex,
  }) = _ReceiptCategoryLookup;
}