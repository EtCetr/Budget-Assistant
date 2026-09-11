import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:budget_assistant/core/enums/transaction_enums.dart';

part 'transaction_draft.freezed.dart';

/// Черновик транзакции для форм создания/редактирования.
///
/// Используется как входные данные для UseCases.
@freezed
abstract class TransactionDraft with _$TransactionDraft {
  const factory TransactionDraft({
    /// Для создания null.
    /// Для обновления обязателен.
    String? id,

    required String accountId,
    String? linkedAccountId,

    required DateTime date,

    /// Копейки.
    required int amount,

    String? originalCurrency,
    int? originalAmount,

    required TransactionType type,

    String? spaceId,
    String? bankCategory,
    String? customCategoryId,
    String? merchantName,
    String? comment,

    String? savingsGoalId,
    bool? isWithdrawal,

    List<TransactionSplitDraft>? splits,
  }) = _TransactionDraft;
}

/// Черновик сплита.
@freezed
abstract class TransactionSplitDraft with _$TransactionSplitDraft {
  const factory TransactionSplitDraft({
    /// Для нового сплита может быть null.
    String? id,

    required String categoryId,

    /// Копейки.
    required int amount,

    String? description,

    /// Для сохранения существующего createdAt при редактировании.
    DateTime? createdAt,
  }) = _TransactionSplitDraft;
}
