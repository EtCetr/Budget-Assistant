import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:budget_assistant/core/enums/transaction_enums.dart';

part 'transaction_split.freezed.dart';

/// Сплит части транзакции.
@freezed
abstract class TransactionSplit with _$TransactionSplit {
  const factory TransactionSplit({
    required String id,
    required String transactionId,
    required String categoryId,

    /// Копейки.
    required int amount,

    String? description,

    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(SyncStatus.pending) SyncStatus syncStatus,
  }) = _TransactionSplit;
}
