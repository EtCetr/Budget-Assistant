import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';

part 'cashback_raw_models.freezed.dart';

/// Облегчённая проекция транзакции для расчёта кэшбэка.
@freezed
abstract class CashbackTransactionRaw with _$CashbackTransactionRaw {
  const factory CashbackTransactionRaw({
    required String id,
    required TransactionType type,
    required int amount,
    String? originalCurrency,
    int? originalAmount,
    String? customCategoryId,
    required bool isSplit,
    required DateTime date,
  }) = _CashbackTransactionRaw;
}

/// Облегчённая проекция сплита чека для расчёта кэшбэка.
@freezed
abstract class CashbackSplitRaw with _$CashbackSplitRaw {
  const factory CashbackSplitRaw({
    required String id,
    required String transactionId,
    required String categoryId,
    required int amount,
  }) = _CashbackSplitRaw;
}