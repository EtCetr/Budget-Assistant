import 'package:freezed_annotation/freezed_annotation.dart';

import 'package:budget_assistant/core/enums/transaction_enums.dart';

part 'transaction.freezed.dart';

/// Доменная модель транзакции.
///
/// Не является Drift-сущностью.
/// UI не должен видеть эту модель напрямую; для экрана используется
/// [TransactionUiModel].
@freezed
abstract class Transaction with _$Transaction {
  const factory Transaction({
    required String id,
    required String accountId,
    String? linkedAccountId,
    required String userId,
    String? spaceId,
    String? originalSpaceId,
    String? bankTransactionId,

    /// UTC.
    required DateTime date,

    /// Копейки.
    required int amount,

    String? originalCurrency,

    /// Копейки/минорные единицы исходной валюты.
    int? originalAmount,

    required TransactionType type,
    String? bankCategory,
    String? customCategoryId,
    String? merchantName,
    String? comment,

    @Default(false) bool isUserEdited,
    @Default(AuditStatus.verified) AuditStatus auditStatus,

    @Default(false) bool isHiddenByCalendar,
    DateTime? hiddenUntilDate,

    int? syncLockedStartedAt,
    int? syncLockedDurationMs,

    @Default(false) bool isArchivedForSpace,
    @Default(false) bool businessMirror,

    String? savingsGoalId,
    @Default(false) bool isWithdrawal,
    @Default(false) bool isSplit,

    String? receiptId,

    required DateTime createdAt,
    required DateTime updatedAt,
    @Default(SyncStatus.pending) SyncStatus syncStatus,
  }) = _Transaction;
}
