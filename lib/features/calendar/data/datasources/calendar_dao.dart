import 'package:drift/drift.dart';
import 'package:budget_assistant/core/database/app_database.dart';

part 'calendar_dao.g.dart';

/// Строка агрегата расходов за день по категории.
class DayCategoryTotalRow {
  const DayCategoryTotalRow({
    required this.day,
    required this.categoryId,
    required this.total,
  });
  final String day;
  final String? categoryId;
  final int total;
}

/// Строка счётчика напоминаний за день.
class DayReminderCountRow {
  const DayReminderCountRow({required this.day, required this.count});
  final String day;
  final int count;
}

/// P&L-поток за день: доход и расход в копейках (ABS).
class DayFlowRow {
  const DayFlowRow({
    required this.day,
    required this.income,
    required this.expense,
  });
  final String day;
  final int income;
  final int expense;
}

/// Агрегаты календаря (ТЗ 6.3.5/6.3.6/6.3.7).
///
/// ВАЖНО (фикс 14.4e-2): Drift хранит DateTime как unix-epoch (int),
/// поэтому strftime ОБЯЗАН содержать модификатор 'unixepoch', иначе
/// SQLite читает число как юлианский день и возвращает NULL.
@DriftAccessor(tables: [Transactions, TransactionSplits, Reminders])
class CalendarDao extends DatabaseAccessor<AppDatabase>
    with _$CalendarDaoMixin {
  CalendarDao(super.db);

  static const String _pnlFilter =
      "t.audit_status != 'ignored' AND t.savings_goal_id IS NULL "
      'AND t.is_withdrawal = 0';

  /// Расходы по дням и категориям (маркеры, stacked-bar, легенда).
  Stream<List<DayCategoryTotalRow>> watchMonthExpenseTotals({
    required String userId,
    String? spaceId,
    required DateTime startUtc,
    required DateTime endUtc,
  }) {
    return _expenseTotalsSelect(userId, spaceId, startUtc, endUtc, true)
        .watch()
        .map((rows) => [
              for (final r in rows)
                DayCategoryTotalRow(
                  day: r.read<String>('day'),
                  categoryId: r.readNullable<String>('cat_id'),
                  total: r.read<int>('total'),
                ),
            ]);
  }

  /// Категории за один день (stacked-bar в статистике/панели).
  Stream<List<DayCategoryTotalRow>> watchDayCategoryTotals({
    required String userId,
    String? spaceId,
    required DateTime startUtc,
    required DateTime endUtc,
  }) {
    return _expenseTotalsSelect(userId, spaceId, startUtc, endUtc, true)
        .watch()
        .map((rows) => [
              for (final r in rows)
                DayCategoryTotalRow(
                  day: r.read<String>('day'),
                  categoryId: r.readNullable<String>('cat_id'),
                  total: r.read<int>('total'),
                ),
            ]);
  }

  /// Суммы расходов по дням (streak «бесплатных дней»).
  Future<Map<String, int>> getExpenseTotalsByDay({
    required String userId,
    String? spaceId,
    required DateTime startUtc,
    required DateTime endUtc,
  }) async {
    final rows =
        await _expenseTotalsSelect(userId, spaceId, startUtc, endUtc, false)
            .get();
    final map = <String, int>{};
    for (final r in rows) {
      final day = r.read<String>('day');
      map[day] = (map[day] ?? 0) + r.read<int>('total');
    }
    return map;
  }

  Selectable<QueryRow> _expenseTotalsSelect(
    String userId,
    String? spaceId,
    DateTime startUtc,
    DateTime endUtc,
    bool groupByCategory,
  ) {
    final scopeSql =
        spaceId == null ? 't.user_id = ?' : '(t.user_id = ? OR t.space_id = ?)';
    final scopeVars = spaceId == null
        ? <Variable>[Variable.withString(userId)]
        : <Variable>[
            Variable.withString(userId),
            Variable.withString(spaceId),
          ];
    final groupBy = groupByCategory ? 'GROUP BY day, cat_id' : 'GROUP BY day';
    final selectCols = groupByCategory
        ? 'day, cat_id, SUM(total) AS total'
        : 'day, SUM(total) AS total';
    final sql = '''
SELECT $selectCols FROM (
  SELECT strftime('%Y-%m-%d', t.date, 'unixepoch', 'localtime') AS day,
         t.custom_category_id AS cat_id,
         ABS(t.amount) AS total
  FROM transactions t
  WHERE t.type = 'expense'
    AND t.is_hidden_by_calendar = 0
    AND $_pnlFilter
    AND t.date >= ? AND t.date < ?
    AND $scopeSql
  UNION ALL
  SELECT strftime('%Y-%m-%d', t.date, 'unixepoch', 'localtime') AS day,
         s.category_id AS cat_id,
         ABS(s.amount) AS total
  FROM transaction_splits s
  JOIN transactions t ON t.id = s.transaction_id
  WHERE t.type = 'expense'
    AND t.is_hidden_by_calendar = 0
    AND $_pnlFilter
    AND t.date >= ? AND t.date < ?
    AND $scopeSql
) $groupBy
''';
    return customSelect(
      sql,
      variables: [
        Variable.withDateTime(startUtc),
        Variable.withDateTime(endUtc),
        ...scopeVars,
        Variable.withDateTime(startUtc),
        Variable.withDateTime(endUtc),
        ...scopeVars,
      ],
      readsFrom: {transactions, transactionSplits},
    );
  }

  /// P&L-поток (доход/расход) по дням месяца: bar-chart календаря.
  Stream<List<DayFlowRow>> watchMonthFlowTotals({
    required String userId,
    String? spaceId,
    required DateTime startUtc,
    required DateTime endUtc,
  }) {
    return _flowSelect(userId, spaceId, startUtc, endUtc)
        .watch()
        .map((rows) => [
              for (final r in rows)
                DayFlowRow(
                  day: r.read<String>('day'),
                  income: r.read<int>('income'),
                  expense: r.read<int>('expense'),
                ),
            ]);
  }

  /// P&L-поток за один день (Summary Card).
  Future<DayFlowRow?> getDayFlow({
    required String userId,
    String? spaceId,
    required DateTime startUtc,
    required DateTime endUtc,
  }) async {
    final rows = await _flowSelect(userId, spaceId, startUtc, endUtc).get();
    if (rows.isEmpty) return null;
    final r = rows.first;
    return DayFlowRow(
      day: r.read<String>('day'),
      income: r.read<int>('income'),
      expense: r.read<int>('expense'),
    );
  }

  Selectable<QueryRow> _flowSelect(
    String userId,
    String? spaceId,
    DateTime startUtc,
    DateTime endUtc,
  ) {
    final scopeSql =
        spaceId == null ? 't.user_id = ?' : '(t.user_id = ? OR t.space_id = ?)';
    final scopeVars = spaceId == null
        ? <Variable>[Variable.withString(userId)]
        : <Variable>[
            Variable.withString(userId),
            Variable.withString(spaceId),
          ];
    final sql = '''
SELECT day,
       SUM(CASE WHEN type = 'income' THEN total ELSE 0 END) AS income,
       SUM(CASE WHEN type = 'expense' THEN total ELSE 0 END) AS expense
FROM (
  SELECT strftime('%Y-%m-%d', t.date, 'unixepoch', 'localtime') AS day,
         t.type AS type,
         ABS(t.amount) AS total
  FROM transactions t
  WHERE t.type IN ('income', 'expense')
    AND t.is_hidden_by_calendar = 0
    AND $_pnlFilter
    AND t.date >= ? AND t.date < ?
    AND $scopeSql
  UNION ALL
  SELECT strftime('%Y-%m-%d', t.date, 'unixepoch', 'localtime') AS day,
         t.type AS type,
         ABS(s.amount) AS total
  FROM transaction_splits s
  JOIN transactions t ON t.id = s.transaction_id
  WHERE t.type = 'expense'
    AND t.is_hidden_by_calendar = 0
    AND $_pnlFilter
    AND t.date >= ? AND t.date < ?
    AND $scopeSql
) GROUP BY day
''';
    return customSelect(
      sql,
      variables: [
        Variable.withDateTime(startUtc),
        Variable.withDateTime(endUtc),
        ...scopeVars,
        Variable.withDateTime(startUtc),
        Variable.withDateTime(endUtc),
        ...scopeVars,
      ],
      readsFrom: {transactions, transactionSplits},
    );
  }

  /// Счётчики незавершённых напоминаний по дням.
  Stream<List<DayReminderCountRow>> watchMonthReminderCounts({
    required String userId,
    String? spaceId,
    required DateTime startUtc,
    required DateTime endUtc,
  }) {
    final scopeSql =
        spaceId == null ? 'user_id = ?' : '(user_id = ? OR space_id = ?)';
    final scopeVars = spaceId == null
        ? <Variable>[Variable.withString(userId)]
        : <Variable>[
            Variable.withString(userId),
            Variable.withString(spaceId),
          ];
    final sql = '''
SELECT strftime('%Y-%m-%d', remind_at, 'unixepoch', 'localtime') AS day,
       COUNT(*) AS c
FROM reminders
WHERE is_completed = 0
  AND remind_at >= ? AND remind_at < ?
  AND $scopeSql
GROUP BY day
''';
    return customSelect(
      sql,
      variables: [
        Variable.withDateTime(startUtc),
        Variable.withDateTime(endUtc),
        ...scopeVars,
      ],
      readsFrom: {reminders},
    ).watch().map((rows) => [
          for (final r in rows)
            DayReminderCountRow(
              day: r.read<String>('day'),
              count: r.read<int>('c'),
            ),
        ]);
  }

  /// Незавершённые напоминания диапазона (события прогноза/превью/панель).
  Stream<List<ReminderDb>> watchMonthReminders({
    required String userId,
    String? spaceId,
    required DateTime startUtc,
    required DateTime endUtc,
  }) {
    return (select(reminders)
      ..where((r) =>
          _reminderScope(userId, spaceId, r) &
          r.remindAt.isBiggerOrEqualValue(startUtc) &
          r.remindAt.isSmallerThanValue(endUtc) &
          r.isCompleted.equals(false))
      ..orderBy([(r) => OrderingTerm.asc(r.remindAt)]))
        .watch();
  }

  /// Транзакции дня (список, включая секретные).
  Stream<List<TransactionDb>> watchDayTransactions({
    required String userId,
    String? spaceId,
    required DateTime startUtc,
    required DateTime endUtc,
  }) {
    return (select(transactions)
      ..where((t) =>
          _scope(userId, spaceId, t) &
          t.date.isBiggerOrEqualValue(startUtc) &
          t.date.isSmallerThanValue(endUtc))
      ..orderBy([(t) => OrderingTerm.desc(t.date)]))
        .watch();
  }

  Expression<bool> _scope(String userId, String? spaceId, Transactions t) {
    if (spaceId == null) return t.userId.equals(userId);
    return t.userId.equals(userId) | t.spaceId.equals(spaceId);
  }

  Expression<bool> _reminderScope(String userId, String? spaceId, Reminders r) {
    if (spaceId == null) return r.userId.equals(userId);
    return r.userId.equals(userId) | r.spaceId.equals(spaceId);
  }
}