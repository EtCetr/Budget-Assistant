import 'package:budget_assistant/core/enums/transaction_enums.dart';
import 'package:budget_assistant/features/cashback/domain/entities/cashback_account_ref.dart';
import 'package:budget_assistant/features/cashback/domain/entities/cashback_entry.dart';
import 'package:budget_assistant/features/cashback/domain/entities/cashback_raw_models.dart';
import 'package:budget_assistant/features/cashback/domain/repositories/cashback_repository.dart';

/// Этап 24: заглушка репозитория кэшбэка для доменных тестов.
/// Деньги — целые копейки, даты — UTC.
class FakeCashbackRepository implements CashbackRepository {
  final List<CashbackEntry> entries = <CashbackEntry>[];
  final Map<String, String?> currencies = <String, String?>{'a1': 'RUB'};
  final Map<String, List<CashbackTransactionRaw>> txByAccount =
      <String, List<CashbackTransactionRaw>>{};
  final List<CashbackSplitRaw> splits = <CashbackSplitRaw>[];
  final List<CashbackAccountRef> myAccounts = <CashbackAccountRef>[];
  final List<CashbackAccountRef> familyAccounts = <CashbackAccountRef>[];

  /// Если задано — каждый метод бросает эту ошибку.
  Object? error;

  final List<String> calls = <String>[];
  final List<({DateTime start, DateTime end})> boundsCalls =
      <({DateTime start, DateTime end})>[];
  final List<({String id, String status})> statusUpdates =
      <({String id, String status})>[];

  void _enter(String name) {
    calls.add(name);
    final e = error;
    if (e != null) throw e;
  }

  void addEntry({
    required String id,
    String accountId = 'a1',
    String? categoryId = 'c1',
    String categoryName = 'Продукты',
    int percentBps = 500,
    String lifetimeType = 'monthly',
    String status = 'potential',
  }) {
    entries.add(CashbackEntry(
      id: id,
      accountId: accountId,
      categoryId: categoryId,
      categoryName: categoryName,
      percentBps: percentBps,
      status: status,
      lifetimeType: lifetimeType,
      expiresAt: DateTime.utc(2026, 8, 1),
      createdAt: DateTime.utc(2026, 7, 1),
      updatedAt: DateTime.utc(2026, 7, 1),
      syncStatus: SyncStatus.pending,
    ));
  }

  @override
  Stream<List<CashbackEntry>> watchByAccount(String accountId) =>
      Stream.fromFuture(getByAccount(accountId));

  @override
  Future<List<CashbackEntry>> getByAccount(String accountId) async {
    _enter('getByAccount');
    return entries.where((e) => e.accountId == accountId).toList();
  }

  @override
  Future<String?> getAccountCurrency(String accountId) async {
    _enter('getAccountCurrency');
    return currencies[accountId];
  }

  @override
  Future<void> createEntry(CashbackEntry entry) async {
    _enter('createEntry');
    entries.add(entry);
  }

  @override
  Future<void> deleteEntry(String id) async {
    _enter('deleteEntry');
    entries.removeWhere((e) => e.id == id);
  }

  @override
  Future<void> updateEntry({
    required String id,
    required String? categoryId,
    required String categoryName,
    required int percentBps,
    required String lifetimeType,
    required DateTime expiresAt,
  }) async {
    _enter('updateEntry');
  }

  @override
  Future<List<CashbackTransactionRaw>> fetchRelevantTransactions(
    String accountId,
    DateTime startUtc,
    DateTime endUtc,
  ) async {
    _enter('fetchRelevantTransactions');
    boundsCalls.add((start: startUtc, end: endUtc));
    return txByAccount[accountId] ?? const <CashbackTransactionRaw>[];
  }

  @override
  Future<List<CashbackSplitRaw>> fetchSplits(List<String> transactionIds) async {
    _enter('fetchSplits');
    return splits
        .where((s) => transactionIds.contains(s.transactionId))
        .toList();
  }

  @override
  Stream<int> watchRelevantTransactionsCount(String accountId) =>
      const Stream<int>.empty();

  @override
  Future<List<CashbackAccountRef>> getMyAccounts(String userId) async {
    _enter('getMyAccounts');
    return myAccounts;
  }

  @override
  Future<List<CashbackAccountRef>> getFamilyAccounts(String spaceId) async {
    _enter('getFamilyAccounts');
    return familyAccounts;
  }

  @override
  Stream<String> watchCashbackRelevantChanges() => const Stream<String>.empty();

  @override
  Future<void> updateEntryStatus(String id, String status) async {
    _enter('updateEntryStatus');
    statusUpdates.add((id: id, status: status));
  }
}

/// Фабрика проекции транзакции для тестов кэшбэка.
CashbackTransactionRaw cashbackTx({
  required String id,
  int amount = 100000,
  TransactionType type = TransactionType.expense,
  String? categoryId = 'c1',
  bool isSplit = false,
  String? originalCurrency,
  int? originalAmount,
  DateTime? date,
}) =>
    CashbackTransactionRaw(
      id: id,
      type: type,
      amount: amount,
      originalCurrency: originalCurrency,
      originalAmount: originalAmount,
      customCategoryId: categoryId,
      isSplit: isSplit,
      date: date ?? DateTime.utc(2026, 7, 15, 12),
    );