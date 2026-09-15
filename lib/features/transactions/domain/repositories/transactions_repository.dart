import 'package:budget_assistant/features/transactions/domain/models/transaction.dart';
import 'package:budget_assistant/features/transactions/domain/models/transaction_split.dart';

/// Контракт репозитория транзакций.
///
/// Домен не знает про Drift.
abstract interface class TransactionsRepository {
  Future<void> createTransaction(
    Transaction transaction,
    List<TransactionSplit> splits,
  );

  Future<void> updateTransaction(
    Transaction transaction,
    List<TransactionSplit> splits,
  );

  /// Возвращает количество удалённых строк.
  Future<int> deleteTransaction(String id, String userId);

  Future<Transaction?> getTransactionById(String id);

  Future<List<TransactionSplit>> getSplitsForTransaction(String transactionId);

  /// Все транзакции цели накопления (пополнения и изъятия),
  /// отсортированные по дате по возрастанию — для графика накопления
  /// (Этап 12, ТЗ 6.3.47.6).
  Future<List<Transaction>> getTransactionsByGoalId(String goalId);
}