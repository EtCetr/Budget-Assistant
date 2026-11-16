import 'package:budget_assistant/features/debts/domain/services/system_category_port.dart';

/// Этап 24: заглушка порта системных категорий.
class FakeSystemCategoryPort implements SystemCategoryPort {
  String? lastUserId;
  String result = 'cat_sys_debt_repayment';

  @override
  Future<String> getOrCreateDebtRepaymentCategory({
    required String userId,
  }) async {
    lastUserId = userId;
    return result;
  }
}