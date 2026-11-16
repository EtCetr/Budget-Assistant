import 'package:budget_assistant/features/transactions/domain/models/transaction.dart';
import 'package:budget_assistant/features/transactions/domain/models/transaction_split.dart';
import 'package:budget_assistant/features/transactions/domain/repositories/transactions_repository.dart';

/// Этап 24: фейк TransactionsRepository для CloseDebtUseCase.
class FakeTransactionsRepositoryForDebts implements TransactionsRepository {
  final List<Transaction> created = <Transaction>[];
  Object? error;

  @override
  Future<void> createTransaction(
    Transaction transaction,
    List<TransactionSplit> splits,
  ) async {
    final e = error;
    if (e != null) throw e;
    created.add(transaction);
  }

  @override
  Future<Transaction?> getTransactionById(String id) async => null;

  @override
  Future<void> updateTransaction(
    Transaction transaction,
    List<TransactionSplit> splits,
  ) async {}

  @override
  Future<int> deleteTransaction(String id, String userId) async => 0;

  @override
  Future<List<TransactionSplit>> getSplitsForTransaction(
    String transactionId,
  ) async =>
      const [];

  @override
  Future<TransactionSplit?> getSplitById(String splitId) async => null;

  @override
  Future<List<Transaction>> getTransactionsByGoalId(String goalId) async =>
      const [];
}