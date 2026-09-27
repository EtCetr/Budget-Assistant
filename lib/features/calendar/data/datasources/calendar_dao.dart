import 'package:drift/drift.dart';
import 'package:budget_assistant/core/database/app_database.dart';

part 'calendar_dao.g.dart';

/// Строка агрегата расходов за день по категории (SQL UNION
/// transactions + transaction_splits, ABS — знак-независимо).
class DayCategoryTotalRow {
  const DayCategoryTotalRow({
    required this.day,
    required this.categoryId,
    required this.total,
  });
  /// 'YYYY-MM-DD' в локальном времени (strftime ... 'localtime').
  final String day;
  final String? categoryId;
  /// Копейки, ABS.
  final int total;
}

/// Строка счётчика напоминаний за день.
class DayReminderCountRow {
  const DayReminderCountRow({required this.day, required this.count});
  final String day;
  final int count;
}

/// Агрегаты календаря (ТЗ 6.3.5/6.3.6/6.3.7): доминирующая категория
/// дня, суммы расходов, счётчики напоминаний, транзакции дня,
/// напоминания месяца (события прогноза).
@DriftAccessor(tables: [Transactions, TransactionSplits, Reminders])
class CalendarDao extends DatabaseAccessor<AppDatabase>
    with _$CalendarDaoMixin {
  CalendarDao(super.db);

  /// Расходы по дням и категориям за диапазон (маркеры календаря).
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

  /// Суммы расходов по дням за диапазон (streak «бесплатных дней»).
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
    final selectCols =
        groupByCategory ? 'day, cat_id, SUM(total) AS total' : 'day, SUM(total) AS total';
    final sql = '''
SELECT $selectCols FROM (
  SELECT strftime('%Y-%m-%d', t.date, 'localtime') AS day,
         t.custom_category_id AS cat_id,
         ABS(t.amount) AS total
  FROM transactions t
  WHERE t.type = 'expense'
    AND t.is_hidden_by_calendar = 0
    AND t.date >= ? AND t.date < ?
    AND $scopeSql
  UNION ALL
  SELECT strftime('%Y-%m-%d', t.date, 'localtime') AS day,
         s.category_id AS cat_id,
         ABS(s.amount) AS total
  FROM transaction_splits s
  JOIN transactions t ON t.id = s.transaction_id
  WHERE t.type = 'expense'
    AND t.is_hidden_by_calendar = 0
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
SELECT strftime('%Y-%m-%d', remind_at, 'localtime') AS day,
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

  /// Незавершённые напоминания месяца (события прогноза, ТЗ 6.3.7).
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

  /// Транзакции дня (панель дня / статистика дня, ТЗ 6.3.6).
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
          t.date.isSmallerThanValue(endUtc) &
          t.isHiddenByCalendar.equals(false))
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