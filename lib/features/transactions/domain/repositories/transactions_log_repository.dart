import '../entities/lookup_item.dart';
import '../entities/transaction_ui_model.dart';
import '../entities/transactions_filter_state.dart';

abstract interface class TransactionsLogRepository {
  Future<List<TransactionUiModel>> fetchPage({
    required TransactionsFilterState filter,
    required String currentUserId,
    required String? currentSpaceId,
    required int limit,
    required int offset,
  });

  Future<void> unhideAsGift(String transactionId);

  Future<List<LookupItem>> fetchCategories();

  Future<List<LookupItem>> fetchAccounts();

  Future<void> hideAsGift(String transactionId);

  Future<void> updateCategory({
    required String transactionId,
    required String categoryId,
  });

  Future<void> createCompensatingIncome(String originalTransactionId);

  /// Переключает флаг крупной траты (is_large_expense).
  /// Используется для аналитического фильтра "Без крупных трат".
  Future<void> toggleLargeExpense(String transactionId);

  Stream<int> watchPendingSyncCount();
}
