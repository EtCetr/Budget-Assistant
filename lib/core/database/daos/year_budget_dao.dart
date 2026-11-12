import 'package:drift/drift.dart';
import 'package:budget_assistant/core/database/app_database.dart';
part 'year_budget_dao.g.dart';

/// Строка агрегата «категория × месяц» (внутренняя для слоя данных).
class CatMonthSum {
  const CatMonthSum(this.categoryId, this.month, this.total);
  final String categoryId;
  final int month;
  final int total;
}

/// DAO годовых матриц (Этап 23.5). Не зарегистрирован в daos: —
/// создаётся конструктором YearBudgetDao(db) (правило R21-4).
@DriftAccessor(tables: [Transactions, TransactionSplits, BudgetLimits, Categories])
class YearBudgetDao extends DatabaseAccessor<AppDatabase>
    with _$YearBudgetDaoMixin {
  YearBudgetDao(super.db);

  static const _monthExpr =
      "CAST(strftime('%m', datetime(t.date, 'unixepoch', 'localtime')) AS INTEGER)";
  static const _yearExpr =
      "CAST(strftime('%Y', datetime(t.date, 'unixepoch', 'localtime')) AS INTEGER)";

  String _scopeSql(String? spaceId) => spaceId == null
      ? 't.space_id IS NULL AND t.user_id = ?'
      : 't.space_id = ?';

  List<Variable> _scopeVars(String userId, String? spaceId) => spaceId == null
      ? [Variable.withString(userId)]
      : [Variable.withString(spaceId)];

  /// Траты: сплит-родители исключены (позиции считаем отдельно),
  /// крупные (is_large_expense) — в синтетическую '__large__' (D23.5-2).
  Future<List<CatMonthSum>> expenseMatrix({
    required String userId,
    required String? spaceId,
    required int year,
  }) async {
    final base = await customSelect(
      "SELECT CASE WHEN t.is_large_expense = 1 THEN '__large__' "
      "ELSE COALESCE(t.custom_category_id, '__none__') END AS cat, "
      '$_monthExpr AS m, SUM(t.amount) AS total '
      'FROM transactions t WHERE ${_scopeSql(spaceId)} AND $_yearExpr = ? '
      "AND t.type = 'expense' AND t.audit_status != 'ignored' "
      'AND t.savings_goal_id IS NULL AND t.is_withdrawal = 0 AND t.is_split = 0 '
      'GROUP BY cat, m',
      variables: [..._scopeVars(userId, spaceId), Variable.withInt(year)],
    ).get();
    final splits = await customSelect(
      "SELECT CASE WHEN t.is_large_expense = 1 THEN '__large__' "
      "ELSE COALESCE(s.category_id, '__none__') END AS cat, "
      '$_monthExpr AS m, SUM(s.amount) AS total '
      'FROM transaction_splits s JOIN transactions t ON t.id = s.transaction_id '
      'WHERE ${_scopeSql(spaceId)} AND $_yearExpr = ? '
      "AND t.type = 'expense' AND t.audit_status != 'ignored' "
      'AND t.savings_goal_id IS NULL AND t.is_withdrawal = 0 '
      'GROUP BY cat, m',
      variables: [..._scopeVars(userId, spaceId), Variable.withInt(year)],
    ).get();
    return [...base, ...splits]
        .map((r) => CatMonthSum(
              r.read<String>('cat'),
              r.read<int>('m'),
              r.read<int>('total'),
            ))
        .toList();
  }

  Future<List<CatMonthSum>> incomeMatrix({
    required String userId,
    required String? spaceId,
    required int year,
  }) async {
    final rows = await customSelect(
      "SELECT COALESCE(t.custom_category_id, '__none__') AS cat, "
      '$_monthExpr AS m, SUM(t.amount) AS total '
      'FROM transactions t WHERE ${_scopeSql(spaceId)} AND $_yearExpr = ? '
      "AND t.type = 'income' AND t.audit_status != 'ignored' "
      'AND t.is_withdrawal = 0 AND t.savings_goal_id IS NULL '
      'GROUP BY cat, m',
      variables: [..._scopeVars(userId, spaceId), Variable.withInt(year)],
    ).get();
    return rows
        .map((r) => CatMonthSum(
              r.read<String>('cat'),
              r.read<int>('m'),
              r.read<int>('total'),
            ))
        .toList();
  }

  /// Лимиты месяца. Возвращаем record-ы, чтобы не зависеть от имени
  /// сгенерированного data-класса таблицы.
  Future<List<({String categoryId, int month, int limitAmount})>> limitsForMonth({
    required String userId,
    required String? spaceId,
    required int year,
    required int month,
  }) async {
    final rows = await (select(budgetLimits)
          ..where((b) =>
              b.status.equals('active') &
              b.year.equals(year) &
              b.month.equals(month) &
              (spaceId == null
                  ? (b.spaceId.isNull() & b.userId.equals(userId))
                  : b.spaceId.equals(spaceId))))
        .get();
    return rows
        .map((r) => (
              categoryId: r.categoryId,
              month: r.month,
              limitAmount: r.limitAmount,
            ))
        .toList();
  }

  Future<List<({String id, String name, String type, String? colorHex, String? iconEmoji})>>
      scopeCategories({
    required String userId,
    required String? spaceId,
  }) async {
    final rows = await (select(categories)
          ..where((c) => spaceId == null
              ? (c.spaceId.isNull() & c.userId.equals(userId))
              : c.spaceId.equals(spaceId))
          ..orderBy([
            (c) => OrderingTerm.asc(c.sortOrder),
            (c) => OrderingTerm.asc(c.name),
          ]))
        .get();
    return rows
        .map((c) => (
              id: c.id,
              name: c.name,
              type: c.type,
              colorHex: c.colorHex,
              iconEmoji: c.iconEmoji,
            ))
        .toList();
  }

  Future<List<int>> availableYears({
    required String userId,
    required String? spaceId,
  }) async {
    final rows = await customSelect(
      'SELECT DISTINCT $_yearExpr AS y FROM transactions t '
      'WHERE ${_scopeSql(spaceId)} ORDER BY y',
      variables: _scopeVars(userId, spaceId),
    ).get();
    return rows.map((r) => r.read<int>('y')).toList();
  }

  /// Операции месяца + позиции сплитов (ispos=1).
  Future<List<QueryRow>> monthTransactions({
    required String userId,
    required String? spaceId,
    required int year,
    required int month,
    required String type,
  }) {
    return customSelect(
      'SELECT t.id AS id, t.date AS d, t.amount AS amt, t.comment AS cmt, '
      "COALESCE(c.name, 'Без категории') AS cat, "
      'COALESCE(a.custom_name, a.bank_name) AS acc, 0 AS ispos '
      'FROM transactions t '
      'LEFT JOIN categories c ON c.id = t.custom_category_id '
      'LEFT JOIN accounts a ON a.id = t.account_id '
      'WHERE ${_scopeSql(spaceId)} AND $_yearExpr = ? AND $_monthExpr = ? '
      "AND t.type = ? AND t.audit_status != 'ignored' "
      'AND t.savings_goal_id IS NULL AND t.is_split = 0 '
      'UNION ALL '
      'SELECT s.id AS id, t.date AS d, s.amount AS amt, s.description AS cmt, '
      "COALESCE(c.name, 'Без категории') AS cat, "
      'COALESCE(a.custom_name, a.bank_name) AS acc, 1 AS ispos '
      'FROM transaction_splits s '
      'JOIN transactions t ON t.id = s.transaction_id '
      'LEFT JOIN categories c ON c.id = s.category_id '
      'LEFT JOIN accounts a ON a.id = t.account_id '
      'WHERE ${_scopeSql(spaceId)} AND $_yearExpr = ? AND $_monthExpr = ? '
      "AND t.type = 'expense' AND t.audit_status != 'ignored' "
      'AND t.savings_goal_id IS NULL '
      'ORDER BY d',
      variables: [
        ..._scopeVars(userId, spaceId),
        Variable.withInt(year),
        Variable.withInt(month),
        Variable.withString(type),
        ..._scopeVars(userId, spaceId),
        Variable.withInt(year),
        Variable.withInt(month),
      ],
    ).get();
  }
}