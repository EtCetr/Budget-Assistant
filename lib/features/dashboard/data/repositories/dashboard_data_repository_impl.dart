import 'package:drift/drift.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/database/app_database.dart';

class ExpenseFlowPoint {
  const ExpenseFlowPoint({required this.day, required this.totalKopecks});
  final DateTime day;
  final int totalKopecks;
}

class ActiveCashbackUi {
  const ActiveCashbackUi({
    required this.id,
    required this.categoryName,
    required this.percentBps,
    required this.expiresAt,
  });
  final String id;
  final String categoryName;
  final int percentBps;
  final DateTime expiresAt;
}

class DashboardDataRepositoryImpl {
  DashboardDataRepositoryImpl({required AppDatabase db, required Logger logger})
      : _db = db,
        _logger = logger;

  final AppDatabase _db;
  final Logger _logger;

  /// Динамика расходов за 30 дней (решение владельца: месячное окно).
  Future<List<ExpenseFlowPoint>> getExpenseFlow({
    required String userId,
    String? spaceId,
    bool excludeLargeExpenses = false,
  }) async {
    try {
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final startLocal = today.subtract(const Duration(days: 29));
      final startUtc = startLocal.toUtc();
      final endUtc =
          DateTime(now.year, now.month, now.day, 23, 59, 59, 999).toUtc();
      final variables = <Variable>[Variable.withString(userId)];
      final spaceClause = spaceId == null
          ? 'AND space_id IS NULL'
          : 'AND (space_id = ? OR space_id IS NULL)';
      if (spaceId != null) {
        variables.add(Variable.withString(spaceId));
      }
      final largeClause =
          excludeLargeExpenses ? 'AND is_large_expense = 0' : '';
      variables.add(Variable.withDateTime(startUtc));
      variables.add(Variable.withDateTime(endUtc));
      final rows = await _db.customSelect(
        '''
SELECT date(date, 'unixepoch', 'localtime') AS day, IFNULL(SUM(amount), 0) AS total
FROM transactions
WHERE user_id = ?
AND type = 'expense'
AND savings_goal_id IS NULL
AND is_withdrawal = 0
AND audit_status != 'ignored'
$spaceClause
$largeClause
AND date >= ?
AND date <= ?
GROUP BY day
ORDER BY day
''',
        variables: variables,
      ).get();
      final byDay = <String, int>{};
      for (final row in rows) {
        byDay[row.read<String>('day')] = row.read<int>('total');
      }
      final result = <ExpenseFlowPoint>[];
      for (int i = 29; i >= 0; i--) {
        final day = today.subtract(Duration(days: i));
        final key =
            '${day.year.toString().padLeft(4, '0')}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';
        result.add(
          ExpenseFlowPoint(day: day, totalKopecks: byDay[key] ?? 0),
        );
      }
      return result;
    } catch (e, st) {
      _logger.e(
          'DashboardDataRepository.getExpenseFlow failed',
          error: e,
          stackTrace: st);
      rethrow;
    }
  }

  Future<List<ActiveCashbackUi>> getActiveCashback(String userId) async {
    try {
      final now = DateTime.now().toUtc();
      final rows = await _db.customSelect(
        '''
SELECT cm.id AS id,
       cm.category_name AS category_name,
       cm.percent_bps AS percent_bps,
       cm.expires_at AS expires_at
FROM cashback_matrix cm
JOIN accounts a ON a.id = cm.account_id
WHERE a.user_id = ?
AND cm.status = 'approved'
AND cm.expires_at > ?
ORDER BY cm.expires_at ASC
''',
        variables: [
          Variable.withString(userId),
          Variable.withDateTime(now),
        ],
      ).get();
      return rows.map((row) {
        return ActiveCashbackUi(
          id: row.read<String>('id'),
          categoryName: row.read<String>('category_name'),
          percentBps: row.read<int>('percent_bps'),
          expiresAt: _parseDate(row.data['expires_at']) ?? now,
        );
      }).toList();
    } catch (e, st) {
      _logger.e(
          'DashboardDataRepository.getActiveCashback failed',
          error: e,
          stackTrace: st);
      rethrow;
    }
  }

  DateTime? _parseDate(Object? value) {
    if (value == null) return null;
    if (value is DateTime) {
      return value.toUtc();
    }
    if (value is int) {
      if (value > 1000000000000000) {
        return DateTime.fromMicrosecondsSinceEpoch(value, isUtc: true);
      }
      if (value > 1000000000000) {
        return DateTime.fromMillisecondsSinceEpoch(value, isUtc: true);
      }
      return DateTime.fromMillisecondsSinceEpoch(value * 1000, isUtc: true);
    }
    if (value is String) {
      final direct = DateTime.tryParse(value);
      if (direct != null) return direct.toUtc();
      final withT = DateTime.tryParse(value.replaceFirst(' ', 'T'));
      if (withT != null) return withT.toUtc();
    }
    return null;
  }
}