import 'package:budget_assistant/core/enums/transaction_enums.dart';
import 'package:budget_assistant/features/transactions/domain/models/transaction_draft.dart';

/// Валидация черновика транзакции.
///
/// Возвращает:
/// - null, если ошибок нет;
/// - текст ошибки, если валидация провалилась.
class TransactionValidator {
  static String? validate(TransactionDraft draft) {
    if (draft.amount <= 0) {
      return 'Amount must be greater than zero';
    }

    if (draft.type == TransactionType.transfer) {
      if (draft.linkedAccountId == null) {
        return 'Transfer requires a destination account';
      }

      if (draft.linkedAccountId == draft.accountId) {
        return 'Destination account must differ from source account';
      }
    }

    if (draft.originalCurrency != null &&
        (draft.originalAmount == null || draft.originalAmount! <= 0)) {
      return 'Original amount is required for foreign currency';
    }

    final splits = draft.splits;

    if (splits != null && splits.isNotEmpty) {
      var total = 0;

      for (final split in splits) {
        if (split.amount <= 0) {
          return 'Split amount must be positive';
        }

        total += split.amount;
      }

      if (total != draft.amount) {
        return 'Split amounts must equal transaction amount';
      }
    }

    return null;
  }
}
