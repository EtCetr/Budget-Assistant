/// Порт домена: системные категории для компенсирующих транзакций
/// (ТОМ 4 §6, Сценарий Б: SYSTEM_DEBT_REPAYMENT).
abstract interface class SystemCategoryPort {
  /// Находит системную категорию погашения долгов пользователя,
  /// при отсутствии создаёт её один раз (детерминированный id).
  Future<String> getOrCreateDebtRepaymentCategory({required String userId});
}