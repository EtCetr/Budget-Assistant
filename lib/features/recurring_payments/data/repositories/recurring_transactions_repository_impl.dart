import 'package:logger/logger.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import '../../domain/entities/recurring_transaction.dart';
import '../../domain/repositories/recurring_transactions_repository.dart';
import '../datasources/recurring_transactions_dao.dart';

class RecurringTransactionsRepositoryImpl
    implements RecurringTransactionsRepository {
  RecurringTransactionsRepositoryImpl({
    required RecurringTransactionsDao dao,
    required Logger logger,
  })  : _dao = dao,
        _logger = logger;

  final RecurringTransactionsDao _dao;
  final Logger _logger;

  @override
  Stream<List<RecurringTransaction>> watchByStatus({
    required String userId,
    required String status,
  }) {
    try {
      return _dao
          .watchByStatus(userId: userId, status: status)
          .map((rows) => rows.map(_map).toList());
    } catch (e, st) {
      _logger.e('watchByStatus failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Stream<List<RecurringTransaction>> watchPendingConfirmation(String userId) {
    return watchByStatus(
      userId: userId,
      status: RecurringStatus.pendingConfirmation,
    );
  }

  @override
  Future<RecurringTransaction?> getById(String id) async {
    try {
      final row = await _dao.getById(id);
      return row == null ? null : _map(row);
    } catch (e, st) {
      _logger.e('getById failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<RecurringTransaction?> getByKey({
    required String userId,
    required String merchantNormalized,
    required int amountBucket,
  }) async {
    try {
      final row = await _dao.getByKey(
        userId: userId,
        merchantNormalized: merchantNormalized,
        amountBucket: amountBucket,
      );
      return row == null ? null : _map(row);
    } catch (e, st) {
      _logger.e('getByKey failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> insert(RecurringTransaction recurring) async {
    try {
      await _dao.insertOne(_toDb(recurring));
    } catch (e, st) {
      _logger.e('insert failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> insertAll(List<RecurringTransaction> rows) async {
    try {
      await _dao.insertMany(rows.map(_toDb).toList());
    } catch (e, st) {
      _logger.e('insertAll failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> updateStats({
    required String id,
    required int occurrenceCount,
    required int averageAmount,
    required int averageDayOfMonth,
    DateTime? lastSeenDate,
    String? status,
  }) async {
    try {
      await _dao.updateStats(
        id: id,
        occurrenceCount: occurrenceCount,
        averageAmount: averageAmount,
        averageDayOfMonth: averageDayOfMonth,
        lastSeenDate: lastSeenDate,
        status: status,
      );
    } catch (e, st) {
      _logger.e('updateStats failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> setStatus(String id, String status) async {
    try {
      await _dao.setStatus(id, status);
    } catch (e, st) {
      _logger.e('setStatus failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> setLinkedReminder({
    required String recurringId,
    String? reminderId,
  }) async {
    try {
      await _dao.setLinkedReminder(
        recurringId: recurringId,
        reminderId: reminderId,
      );
    } catch (e, st) {
      _logger.e('setLinkedReminder failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<List<RecurringTransaction>> getPendingConfirmation(
    String userId,
  ) async {
    try {
      final rows = await _dao.getPendingConfirmation(userId);
      return rows.map(_map).toList();
    } catch (e, st) {
      _logger.e('getPendingConfirmation failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<int> deleteByStatus({
    required String userId,
    required String status,
  }) async {
    try {
      return await _dao.deleteByStatus(userId: userId, status: status);
    } catch (e, st) {
      _logger.e('deleteByStatus failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  RecurringTransaction _map(RecurringTransactionDb db) {
    return RecurringTransaction(
      id: db.id,
      userId: db.userId,
      spaceId: db.spaceId,
      merchantName: db.merchantName,
      merchantNameNormalized: db.merchantNameNormalized,
      averageAmount: db.averageAmount,
      averageAmountBucket: db.averageAmountBucket,
      averageDayOfMonth: db.averageDayOfMonth,
      occurrenceCount: db.occurrenceCount,
      confidence: db.confidence,
      status: db.status,
      firstSeenDate: db.firstSeenDate,
      lastSeenDate: db.lastSeenDate,
      linkedReminderId: db.linkedReminderId,
      categoryId: db.categoryId,
      detectedAt: db.detectedAt,
      createdAt: db.createdAt,
      updatedAt: db.updatedAt,
      syncStatus: db.syncStatus,
    );
  }

  RecurringTransactionDb _toDb(RecurringTransaction r) {
    return RecurringTransactionDb(
      id: r.id,
      userId: r.userId,
      spaceId: r.spaceId,
      merchantName: r.merchantName,
      merchantNameNormalized: r.merchantNameNormalized,
      averageAmount: r.averageAmount,
      averageAmountBucket: r.averageAmountBucket,
      averageDayOfMonth: r.averageDayOfMonth,
      occurrenceCount: r.occurrenceCount,
      confidence: r.confidence,
      status: r.status,
      firstSeenDate: r.firstSeenDate,
      lastSeenDate: r.lastSeenDate,
      linkedReminderId: r.linkedReminderId,
      categoryId: r.categoryId,
      detectedAt: r.detectedAt,
      createdAt: r.createdAt,
      updatedAt: r.updatedAt,
      syncStatus: r.syncStatus,
    );
  }
}