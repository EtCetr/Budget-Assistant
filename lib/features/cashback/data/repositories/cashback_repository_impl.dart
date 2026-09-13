import 'package:drift/drift.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import '../../domain/entities/cashback_account_ref.dart';
import '../../domain/entities/cashback_entry.dart';
import '../../domain/entities/cashback_raw_models.dart';
import '../../domain/repositories/cashback_repository.dart';
import '../datasources/cashback_matrix_dao.dart';

class CashbackRepositoryImpl implements CashbackRepository {
  CashbackRepositoryImpl({
    required AppDatabase db,
    required Logger logger,
  })  : _db = db,
        _logger = logger,
        _dao = CashbackMatrixDao(db);

  final AppDatabase _db;
  final Logger _logger;
  final CashbackMatrixDao _dao;

  @override
  Stream<List<CashbackEntry>> watchByAccount(String accountId) {
    return _dao
        .watchByAccount(accountId)
        .map((rows) => rows.map(_mapEntry).toList());
  }

  @override
  Future<List<CashbackEntry>> getByAccount(String accountId) async {
    try {
      final rows = await _dao.getByAccount(accountId);
      return rows.map(_mapEntry).toList();
    } catch (e, st) {
      _logger.e('CashbackRepository.getByAccount failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<String?> getAccountCurrency(String accountId) async {
    try {
      return await _dao.getAccountCurrency(accountId);
    } catch (e, st) {
      _logger.e('CashbackRepository.getAccountCurrency failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> createEntry(CashbackEntry entry) async {
    try {
      await _dao.insert(CashbackMatrixCompanion(
        id: Value(entry.id),
        accountId: Value(entry.accountId),
        categoryId: Value(entry.categoryId),
        categoryName: Value(entry.categoryName),
        percentBps: Value(entry.percentBps),
        status: Value(entry.status),
        lifetimeType: Value(entry.lifetimeType),
        expiresAt: Value(entry.expiresAt),
        createdAt: Value(entry.createdAt),
        updatedAt: Value(entry.updatedAt),
        syncStatus: Value(entry.syncStatus),
      ));
    } catch (e, st) {
      _logger.e('CashbackRepository.createEntry failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> deleteEntry(String id) async {
    try {
      await _dao.deleteById(id);
    } catch (e, st) {
      _logger.e('CashbackRepository.deleteEntry failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<List<CashbackTransactionRaw>> fetchRelevantTransactions(
    String accountId,
    DateTime startUtc,
    DateTime endUtc,
  ) async {
    try {
      final t = _db.transactions;
      final rows = await (_db.select(t)
            ..where((row) =>
                row.accountId.equals(accountId) &
                // Правило 3: переводы исключены.
                row.type.equalsValue(TransactionType.transfer).not() &
                // Исключение игнорируемых.
                row.auditStatus.equalsValue(AuditStatus.ignored).not() &
                // Фундаментальные фильтры P&L (ТОМ 4 §1.1): без копилок и изъятий.
                row.savingsGoalId.isNull() &
                row.isWithdrawal.equals(false) &
                // Правило 5: диапазон цикла.
                row.date.isBiggerOrEqualValue(startUtc) &
                row.date.isSmallerThanValue(endUtc)))
          .get();
      return rows
          .map((r) => CashbackTransactionRaw(
                id: r.id,
                type: r.type,
                amount: r.amount,
                originalCurrency: r.originalCurrency,
                originalAmount: r.originalAmount,
                customCategoryId: r.customCategoryId,
                isSplit: r.isSplit,
                date: r.date,
              ))
          .toList();
    } catch (e, st) {
      _logger.e('CashbackRepository.fetchRelevantTransactions failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<List<CashbackSplitRaw>> fetchSplits(List<String> transactionIds) async {
    try {
      if (transactionIds.isEmpty) return const [];
      final s = _db.transactionSplits;
      final rows = await (_db.select(s)
            ..where((row) => row.transactionId.isIn(transactionIds)))
          .get();
      return rows
          .map((r) => CashbackSplitRaw(
                id: r.id,
                transactionId: r.transactionId,
                categoryId: r.categoryId,
                amount: r.amount,
              ))
          .toList();
    } catch (e, st) {
      _logger.e('CashbackRepository.fetchSplits failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Stream<int> watchRelevantTransactionsCount(String accountId) {
    final countExp = _db.transactions.id.count();
    final query = _db.selectOnly(_db.transactions)
      ..addColumns([countExp])
      ..where(_db.transactions.accountId.equals(accountId));
    return query.map((row) => row.read(countExp) ?? 0).watchSingle();
  }

  @override
  Future<List<CashbackAccountRef>> getMyAccounts(String userId) async {
    try {
      final rows = await _dao.getMyAccounts(userId);
      return rows.map(_toRef).toList();
    } catch (e, st) {
      _logger.e('CashbackRepository.getMyAccounts failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<List<CashbackAccountRef>> getFamilyAccounts(String spaceId) async {
    try {
      final rows = await _dao.getFamilyAccounts(spaceId);
      return rows.map(_toRef).toList();
    } catch (e, st) {
      _logger.e('CashbackRepository.getFamilyAccounts failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Stream<String> watchCashbackRelevantChanges() =>
      _dao.watchCashbackRelevantChanges();

  @override
  Future<void> updateEntryStatus(String id, String status) async {
    try {
      await _dao.updateStatus(id, status);
    } catch (e, st) {
      _logger.e('CashbackRepository.updateEntryStatus failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  CashbackAccountRef _toRef(Account r) {
    return CashbackAccountRef(
      id: r.id,
      name: r.customName.isNotEmpty ? r.customName : r.bankName,
      currency: r.currency,
    );
  }

  CashbackEntry _mapEntry(CashbackMatrixDb r) {
    return CashbackEntry(
      id: r.id,
      accountId: r.accountId,
      categoryId: r.categoryId,
      categoryName: r.categoryName,
      percentBps: r.percentBps,
      status: r.status,
      lifetimeType: r.lifetimeType,
      expiresAt: r.expiresAt,
      createdAt: r.createdAt,
      updatedAt: r.updatedAt,
      syncStatus: r.syncStatus,
    );
  }
}