import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';

part 'receipt_item.freezed.dart';

@freezed
abstract class ReceiptItem with _$ReceiptItem {
  const factory ReceiptItem({
    required String id,
    required String receiptId,
    required String originalName,
    String? normalizedName,
    required double quantity,
    required int unitPrice,
    required int totalPrice,
    String? categoryId,
    required bool isExcluded,
    required DateTime createdAt,
    required DateTime updatedAt,
    required SyncStatus syncStatus,
  }) = _ReceiptItem;
}