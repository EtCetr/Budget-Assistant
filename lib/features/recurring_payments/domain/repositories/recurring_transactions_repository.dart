import '../entities/recurring_transaction.dart';

abstract interface class RecurringTransactionsRepository {
  Stream<List<RecurringTransaction>> watchByStatus({
    required String userId,
    required String status,
  });
  Stream<List<RecurringTransaction>> watchPendingConfirmation(String userId);
  Future<RecurringTransaction?> getById(String id);
  /// Поиск по ключу идемпотентности (user, normalized, bucket).
  Future<RecurringTransaction?> getByKey({
    required String userId,
    required String merchantNormalized,
    required int amountBucket,
  });
  Future<void> insert(RecurringTransaction recurring);
  Future<void> insertAll(List<RecurringTransaction> rows);
  Future<void> updateStats({
    required String id,
    required int occurrenceCount,
    required int averageAmount,
    required int averageDayOfMonth,
    DateTime? lastSeenDate,
    String? status,
  });
  Future<void> setStatus(String id, String status);
  Future<void> setLinkedReminder({
    required String recurringId,
    String? reminderId,
  });
  Future<List<RecurringTransaction>> getPendingConfirmation(String userId);
  Future<int> deleteByStatus({required String userId, required String status});
}