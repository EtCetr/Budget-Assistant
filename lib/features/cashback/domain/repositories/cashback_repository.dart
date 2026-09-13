import '../entities/cashback_account_ref.dart';
import '../entities/cashback_entry.dart';
import '../entities/cashback_raw_models.dart';

abstract interface class CashbackRepository {
  Stream<List<CashbackEntry>> watchByAccount(String accountId);
  Future<List<CashbackEntry>> getByAccount(String accountId);
  Future<String?> getAccountCurrency(String accountId);
  Future<void> createEntry(CashbackEntry entry);
  Future<void> deleteEntry(String id);

  /// Транзакции для кэшбэка: без переводов, без ignored, без копилок/изъятий,
  /// в диапазоне [startUtc; endUtc) (ТОМ 4 Правила 3, 5 + фундаментальные фильтры).
  Future<List<CashbackTransactionRaw>> fetchRelevantTransactions(
    String accountId,
    DateTime startUtc,
    DateTime endUtc,
  );
  Future<List<CashbackSplitRaw>> fetchSplits(List<String> transactionIds);

  /// Реактивный триггер изменений транзакций счёта (для пересчёта кэшбэка).
  Stream<int> watchRelevantTransactionsCount(String accountId);

  /// Мои счета (без системных и архивных) — колонки/селектор режима «Мои карты».
  Future<List<CashbackAccountRef>> getMyAccounts(String userId);

  /// Счета активной группы (любой владелец) — режим «Карты семьи».
  /// Локально пусты, пока не работает синхронизация (Этап 25).
  Future<List<CashbackAccountRef>> getFamilyAccounts(String spaceId);

  /// Единый реактивный триггер матрицы: любое изменение cashback_matrix,
  /// transactions или accounts.
  Stream<String> watchCashbackRelevantChanges();

  /// Смена статуса записи матрицы: 'potential' <-> 'approved'.
  Future<void> updateEntryStatus(String id, String status);
}