import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';

part 'receipt.freezed.dart';

@freezed
abstract class Receipt with _$Receipt {
  const factory Receipt({
    required String id,
    required String userId,
    String? spaceId,
    String? transactionId,
    required String storeName,
    required int totalAmount,
    required DateTime receiptDate,
    String? fiscalData,
    String? rawOcrText,
    String? imagePath,
    required String status,
    required String currency,
    required DateTime createdAt,
    required DateTime updatedAt,
    required SyncStatus syncStatus,
  }) = _Receipt;
}