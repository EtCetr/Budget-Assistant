import 'package:drift/drift.dart';
import 'package:logger/logger.dart';

import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/features/transactions/domain/models/transaction.dart';
import 'package:budget_assistant/features/transactions/domain/models/transaction_split.dart';
import 'package:budget_assistant/features/transactions/domain/repositories/transactions_repository.dart';

/// Реализация репозитория транзакций на Drift.
///
/// Правила:
/// - все операции в try/catch;
/// - ошибки логируются и пробрасываются выше;
/// - сплиты пишутся в одной транзакции с родительской записью.
class TransactionsRepositoryImpl implements TransactionsRepository {
  final AppDatabase _db;
  final Logger _logger;

  TransactionsRepositoryImpl({required AppDatabase db, required Logger logger})
    : _db = db,
      _logger = logger;

  @override
  Future<void> createTransaction(
    Transaction transaction,
    List<TransactionSplit> splits,
  ) async {
    try {
      await _db.transaction(() async {
        await _db
            .into(_db.transactions)
            .insert(_toTransactionsCompanion(transaction));

        if (splits.isNotEmpty) {
          await _db.batch((batch) {
            batch.insertAll(
              _db.transactionSplits,
              splits.map(_toSplitsCompanion).toList(),
            );
          });
        }
      });
    } catch (e, stack) {
      _logger.e('Failed to create transaction', error: e, stackTrace: stack);
      rethrow;
    }
  }

  @override
  Future<void> updateTransaction(
    Transaction transaction,
    List<TransactionSplit> splits,
  ) async {
    try {
      await _db.transaction(() async {
        await (_db.update(_db.transactions)
              ..where((t) => t.id.equals(transaction.id)))
            .write(_toTransactionsCompanion(transaction));

        await (_db.delete(
          _db.transactionSplits,
        )..where((t) => t.transactionId.equals(transaction.id))).go();

        if (splits.isNotEmpty) {
          await _db.batch((batch) {
            batch.insertAll(
              _db.transactionSplits,
              splits.map(_toSplitsCompanion).toList(),
            );
          });
        }
      });
    } catch (e, stack) {
      _logger.e('Failed to update transaction', error: e, stackTrace: stack);
      rethrow;
    }
  }

  @override
  Future<int> deleteTransaction(String id, String userId) async {
    try {
      return await _db.transaction(() async {
        await (_db.delete(
          _db.transactionSplits,
        )..where((t) => t.transactionId.equals(id))).go();

        return await (_db.delete(
          _db.transactions,
        )..where((t) => t.id.equals(id) & t.userId.equals(userId))).go();
      });
    } catch (e, stack) {
      _logger.e('Failed to delete transaction', error: e, stackTrace: stack);
      rethrow;
    }
  }

  @override
  Future<Transaction?> getTransactionById(String id) async {
    try {
      final row = await (_db.select(
        _db.transactions,
      )..where((t) => t.id.equals(id))).getSingleOrNull();

      if (row == null) {
        return null;
      }

      return _fromDb(row);
    } catch (e, stack) {
      _logger.e('Failed to get transaction', error: e, stackTrace: stack);
      rethrow;
    }
  }

  @override
  Future<List<TransactionSplit>> getSplitsForTransaction(
    String transactionId,
  ) async {
    try {
      final rows = await (_db.select(
        _db.transactionSplits,
      )..where((t) => t.transactionId.equals(transactionId))).get();

      return rows.map(_splitFromDb).toList();
    } catch (e, stack) {
      _logger.e(
        'Failed to get transaction splits',
        error: e,
        stackTrace: stack,
      );
      rethrow;
    }
  }

  TransactionsCompanion _toTransactionsCompanion(Transaction t) {
    return TransactionsCompanion(
      id: Value(t.id),
      accountId: Value(t.accountId),
      linkedAccountId: Value(t.linkedAccountId),
      userId: Value(t.userId),
      spaceId: Value(t.spaceId),
      originalSpaceId: Value(t.originalSpaceId),
      bankTransactionId: Value(t.bankTransactionId),
      date: Value(t.date),
      amount: Value(t.amount),
      originalCurrency: Value(t.originalCurrency),
      originalAmount: Value(t.originalAmount),
      type: Value(t.type),
      bankCategory: Value(t.bankCategory),
      customCategoryId: Value(t.customCategoryId),
      merchantName: Value(t.merchantName),
      comment: Value(t.comment),
      isUserEdited: Value(t.isUserEdited),
      auditStatus: Value(t.auditStatus),
      isHiddenByCalendar: Value(t.isHiddenByCalendar),
      hiddenUntilDate: Value(t.hiddenUntilDate),
      syncLockedStartedAt: Value(t.syncLockedStartedAt),
      syncLockedDurationMs: Value(t.syncLockedDurationMs),
      isArchivedForSpace: Value(t.isArchivedForSpace),
      businessMirror: Value(t.businessMirror),
      savingsGoalId: Value(t.savingsGoalId),
      isWithdrawal: Value(t.isWithdrawal),
      isSplit: Value(t.isSplit),
      isLargeExpense: Value(t.isLargeExpense),
      receiptId: Value(t.receiptId),
      createdAt: Value(t.createdAt),
      updatedAt: Value(t.updatedAt),
      syncStatus: Value(t.syncStatus),
    );
  }

  TransactionSplitsCompanion _toSplitsCompanion(TransactionSplit s) {
    return TransactionSplitsCompanion(
      id: Value(s.id),
      transactionId: Value(s.transactionId),
      categoryId: Value(s.categoryId),
      amount: Value(s.amount),
      description: Value(s.description),
      createdAt: Value(s.createdAt),
      updatedAt: Value(s.updatedAt),
      syncStatus: Value(s.syncStatus),
    );
  }

  Transaction _fromDb(TransactionDb db) {
    return Transaction(
      id: db.id,
      accountId: db.accountId,
      linkedAccountId: db.linkedAccountId,
      userId: db.userId,
      spaceId: db.spaceId,
      originalSpaceId: db.originalSpaceId,
      bankTransactionId: db.bankTransactionId,
      date: db.date,
      amount: db.amount,
      originalCurrency: db.originalCurrency,
      originalAmount: db.originalAmount,
      type: db.type,
      bankCategory: db.bankCategory,
      customCategoryId: db.customCategoryId,
      merchantName: db.merchantName,
      comment: db.comment,
      isUserEdited: db.isUserEdited,
      auditStatus: db.auditStatus,
      isHiddenByCalendar: db.isHiddenByCalendar,
      hiddenUntilDate: db.hiddenUntilDate,
      syncLockedStartedAt: db.syncLockedStartedAt,
      syncLockedDurationMs: db.syncLockedDurationMs,
      isArchivedForSpace: db.isArchivedForSpace,
      businessMirror: db.businessMirror,
      savingsGoalId: db.savingsGoalId,
      isWithdrawal: db.isWithdrawal,
      isSplit: db.isSplit,
      isLargeExpense: db.isLargeExpense,
      receiptId: db.receiptId,
      createdAt: db.createdAt,
      updatedAt: db.updatedAt,
      syncStatus: db.syncStatus,
    );
  }

  TransactionSplit _splitFromDb(TransactionSplitDb db) {
    return TransactionSplit(
      id: db.id,
      transactionId: db.transactionId,
      categoryId: db.categoryId,
      amount: db.amount,
      description: db.description,
      createdAt: db.createdAt,
      updatedAt: db.updatedAt,
      syncStatus: db.syncStatus,
    );
  }
}
