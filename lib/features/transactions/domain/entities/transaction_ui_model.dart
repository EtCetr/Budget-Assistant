import 'package:budget_assistant/core/enums/transaction_enums.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_ui_model.freezed.dart';

@freezed
abstract class TransactionUiModel with _$TransactionUiModel {
  const factory TransactionUiModel({
    required String id,
    required String userId,
    required String? spaceId,
    required String accountId,
    required String? categoryId,
    required TransactionType type,
    required int amountKopecks,
    required String currencyCode,
    required DateTime date,
    required String? merchantName,
    required String? comment,
    required String? receiptId,
    required bool isSplit,
    required AuditStatus auditStatus,
    required SyncStatus syncStatus,
    required String categoryName,
    required String categoryColorHex,
    required String? memberDisplayName,
    required String? memberColorHex,
    @Default(false) bool isHiddenByCalendar,
  }) = _TransactionUiModel;
}
