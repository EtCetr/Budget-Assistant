import 'package:budget_assistant/core/enums/transaction_enums.dart';
import 'package:budget_assistant/features/transactions/domain/models/transaction.dart';
import 'package:budget_assistant/features/transactions/domain/models/transaction_draft.dart';
import 'package:budget_assistant/features/transactions/domain/models/transaction_ui_model.dart';

/// Маппинг доменной модели в презентационную.
///
/// Правила:
/// - UI никогда не видит Drift-сущности;
/// - связанные данные (категория/счёт) передаются из провайдеров;
/// - никакого форматирования денег здесь (это делает PrivacyFormatter).
extension TransactionUiMapper on Transaction {
  TransactionUiModel toUiModel({
    required bool isLocked,
    String? categoryName,
    String? categoryEmoji,
    String? categoryColorHex,
    String? accountName,
  }) {
    return TransactionUiModel(
      id: id,
      date: date,
      amount: amount,
      type: type,
      merchantName: merchantName,
      comment: comment,
      isPendingSync: syncStatus == SyncStatus.pending,
      isSyncLocked: isLocked,
      isHidden: isHiddenByCalendar,
      categoryName: categoryName,
      categoryEmoji: categoryEmoji,
      categoryColorHex: categoryColorHex,
      accountName: accountName,
    );
  }

  /// Заполнение формы редактирования из существующей транзакции.
  TransactionDraft toEditDraft({List<TransactionSplitDraft>? splits}) {
    return TransactionDraft(
      id: id,
      accountId: accountId,
      linkedAccountId: linkedAccountId,
      date: date,
      amount: amount,
      originalCurrency: originalCurrency,
      originalAmount: originalAmount,
      type: type,
      spaceId: spaceId,
      bankCategory: bankCategory,
      customCategoryId: customCategoryId,
      merchantName: merchantName,
      comment: comment,
      savingsGoalId: savingsGoalId,
      isWithdrawal: isWithdrawal,
      splits: splits,
    );
  }
}
