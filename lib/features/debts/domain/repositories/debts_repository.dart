import '../entities/debt.dart';
import '../entities/debt_form_draft.dart';

/// Контракт репозитория долгов. Домен не знает про Drift.
abstract interface class DebtsRepository {
  /// Все долги, где пользователь — должник или кредитор (любые статусы).
  /// Скоуп по пространствам не применяется: долг — обязательство между
  /// людьми (SQL из ТЗ 6.3.13.3 без space-фильтра).
  Stream<List<Debt>> watchForUser({required String userId});
  Future<Debt?> getById(String debtId);
  Future<void> insert(Debt debt);
  Future<void> update(Debt debt);
  Future<void> delete(String debtId);
  /// Закрытие долга: resolved / forgiven / paid_offline.
  Future<void> resolve({required String debtId, required String status});
  Future<void> extendDueDate({
    required String debtId,
    required DateTime newDueDateUtc,
  });
  /// Пометка активных долгов вышедшего члена семьи (ТЗ 6.3.13.8).
  /// Долги НЕ удаляются — финансовые обязательства остаются.
  Future<int> markExMember({required String memberUserId});
  /// Авто-закрытие активных долгов с auto_resolve, связанных
  /// с транзакцией (6.3.14.13 п.4.b). Без компенсирующих транзакций.
  Future<int> resolveAutoLinked({required String transactionId});
  Future<DebtFormDraft?> getFreshDraft(String userId);
  Future<void> saveDraft(String userId, DebtFormDraft draft);
  Future<void> deleteDraftByUser(String userId);
}