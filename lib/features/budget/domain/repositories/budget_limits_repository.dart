import 'package:budget_assistant/core/errors/result.dart';
import '../entities/budget_limit.dart';
import '../entities/monthly_pnl.dart';

abstract interface class BudgetLimitsRepository {
  Future<List<BudgetLimit>> getForMonth({
    required String userId,
    String? spaceId,
    required int year,
    required int month,
  });

  Stream<List<BudgetLimit>> watchForMonth({
    required String userId,
    String? spaceId,
    required int year,
    required int month,
  });

  /// Получить лимит по его ID (для префилла экрана редактирования).
  Future<BudgetLimit?> getById(String id);

  Future<BudgetLimit?> getForCategory({
    required String userId,
    String? spaceId,
    required String categoryId,
    required int year,
    required int month,
  });

  Future<Result<BudgetLimit>> upsert(BudgetLimit limit);

  Future<Result<void>> delete(String id);

  Future<Result<MonthlyPnl>> calculateMonthlyPnl({
    required String userId,
    String? spaceId,
    required int year,
    required int month,
    bool excludeLargeExpenses = false,
  });

  Future<Result<int>> calculateCategoryExpense({
    required String userId,
    String? spaceId,
    required String categoryId,
    required int year,
    required int month,
  });

  /// Реактивный триггер: эмитит суммарный объём релевантных транзакций
  /// за месяц. Любое изменение транзакций (добавление/удаление/правка суммы)
  /// меняет сумму и пушит новое значение — провайдеры бюджета пересчитываются.
  /// Применяются жёсткие фильтры P&L (ТОМ 4): без переводов/копилок/изъятий.
  Stream<int> watchMonthlyTransactionChanges({
    required String userId,
    String? spaceId,
    required int year,
    required int month,
  });
}
