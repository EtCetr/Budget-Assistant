import 'package:budget_assistant/features/recurring_payments/domain/entities/recurring_transaction.dart';
import 'package:budget_assistant/features/recurring_payments/domain/repositories/recurring_transactions_repository.dart';

/// Этап 24: заглушка репозитория регулярных платежей.
class FakeRecurringRepository implements RecurringTransactionsRepository {
  final Map<String, RecurringTransaction> rows =
      <String, RecurringTransaction>{};
  final List<String> calls = <String>[];
  final List<({String id, int count, String? status})> statsUpdates =
      <({String id, int count, String? status})>[];
  final List<({String recurringId, String? reminderId})> linkedReminders =
      <({String recurringId, String? reminderId})>[];
  final List<String> deletedStatuses = <String>[];
  Object? error;

  void _enter(String name) {
    calls.add(name);
    final e = error;
    if (e != null) throw e;
  }

  @override
  Stream<List<RecurringTransaction>> watchByStatus({
    required String userId,
    required String status,
  }) =>
      Stream.value(rows.values.where((r) => r.status == status).toList());

  @override
  Stream<List<RecurringTransaction>> watchPendingConfirmation(String userId) =>
      watchByStatus(
        userId: userId,
        status: RecurringStatus.pendingConfirmation,
      );

  @override
  Future<RecurringTransaction?> getById(String id) async {
    _enter('getById');
    return rows[id];
  }

  @override
  Future<RecurringTransaction?> getByKey({
    required String userId,
    required String merchantNormalized,
    required int amountBucket,
  }) async {
    _enter('getByKey');
    for (final r in rows.values) {
      if (r.userId == userId &&
          r.merchantNameNormalized == merchantNormalized &&
          r.averageAmountBucket == amountBucket) {
        return r;
      }
    }
    return null;
  }

  @override
  Future<void> insert(RecurringTransaction recurring) async {
    _enter('insert');
    rows[recurring.id] = recurring;
  }

  @override
  Future<void> insertAll(List<RecurringTransaction> list) async {
    _enter('insertAll');
    for (final r in list) {
      rows[r.id] = r;
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
    _enter('updateStats');
    statsUpdates.add((id: id, count: occurrenceCount, status: status));
    final r = rows[id];
    if (r != null) {
      rows[id] = r.copyWith(
        occurrenceCount: occurrenceCount,
        averageAmount: averageAmount,
        averageDayOfMonth: averageDayOfMonth,
        lastSeenDate: lastSeenDate ?? r.lastSeenDate,
        status: status ?? r.status,
      );
    }
  }

  @override
  Future<void> setStatus(String id, String status) async {
    _enter('setStatus');
    final r = rows[id];
    if (r != null) rows[id] = r.copyWith(status: status);
  }

  @override
  Future<void> setLinkedReminder({
    required String recurringId,
    String? reminderId,
  }) async {
    _enter('setLinkedReminder');
    linkedReminders.add((recurringId: recurringId, reminderId: reminderId));
  }

  @override
  Future<List<RecurringTransaction>> getPendingConfirmation(String userId) async {
    _enter('getPendingConfirmation');
    return rows.values
        .where((r) =>
            r.userId == userId && r.status == RecurringStatus.pendingConfirmation)
        .toList();
  }

  @override
  Future<int> deleteByStatus({
    required String userId,
    required String status,
  }) async {
    _enter('deleteByStatus');
    deletedStatuses.add(status);
    final before = rows.length;
    rows.removeWhere((_, r) => r.userId == userId && r.status == status);
    return before - rows.length;
  }
}

/// Фабрика регулярного платежа для тестов.
RecurringTransaction makeRecurring({
  required String id,
  String userId = 'u1',
  String merchantName = 'NETFLIX.COM',
  String? merchantNormalized,
  int averageAmount = 99900,
  int? averageAmountBucket,
  int averageDayOfMonth = 15,
  int occurrenceCount = 3,
  String confidence = RecurringConfidence.medium,
  String status = RecurringStatus.pendingConfirmation,
}) =>
    RecurringTransaction(
      id: id,
      userId: userId,
      merchantName: merchantName,
      merchantNameNormalized: merchantNormalized ?? 'netflix com',
      averageAmount: averageAmount,
      averageAmountBucket: averageAmountBucket ?? 100000,
      averageDayOfMonth: averageDayOfMonth,
      occurrenceCount: occurrenceCount,
      confidence: confidence,
      status: status,
      createdAt: DateTime.utc(2026, 1, 1),
      updatedAt: DateTime.utc(2026, 1, 1),
    );