import 'package:freezed_annotation/freezed_annotation.dart';
import '../entities/receipt.dart';
import '../entities/receipt_item.dart';

part 'receipt_bundle.freezed.dart';

/// Чек + позиции одной загрузкой для ReceiptPreviewScreen.
@freezed
abstract class ReceiptBundle with _$ReceiptBundle {
  const factory ReceiptBundle({
    required Receipt receipt,
    required List<ReceiptItem> items,
  }) = _ReceiptBundle;
}