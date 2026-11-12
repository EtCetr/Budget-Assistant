import 'package:drift/drift.dart' show GeneratedDatabase;

import 'package:budget_assistant/core/logger.dart';

/// Этап 23: аудит горячих запросов через EXPLAIN QUERY PLAN (debug).
///
/// Включается при старте флагом -dart-define PERF_EXPLAIN=true:
///   flutter run --dart-define=PERF_EXPLAIN=true
///
/// Запрос идёт полным сканом таблицы (SCAN без USING INDEX) —
/// не хватает индекса (DECISIONS.md: обязательные индексы).
class DriftQueryExplainer {
  DriftQueryExplainer._();

  /// Горячие запросы приложения (проверяют существующие индексы).
  static const List<String> hotQueries = <String>[
    // Лог транзакций (idx_transactions_user_space_date).
    "SELECT * FROM transactions WHERE user_id = 'u' AND space_id = 's' "
        'AND date >= 0 AND date <= 9999999999 ORDER BY date DESC LIMIT 30',
    // Pending-записи для синка (idx_transactions_sync_status).
    "SELECT COUNT(*) FROM transactions WHERE sync_status = 'pending'",
    // Транзакции цели накопления (idx_transactions_savings_goal).
    "SELECT * FROM transactions WHERE savings_goal_id = 'goal'",
    // Ближайшие напоминания (idx_reminders_schedule).
    'SELECT * FROM reminders WHERE remind_at >= 0 AND is_completed = 0 '
        'ORDER BY remind_at LIMIT 3',
    // Активные долги (idx_debts_creditor).
    "SELECT * FROM debts WHERE creditor_id = 'u' "
        "AND resolution_status = 'active'",
    // Активные цели накопления (idx_savings_goals_user_status).
    "SELECT * FROM savings_goals WHERE user_id = 'u' AND status = 'active'",
    // Лимиты бюджета (idx_budget_limits_unique).
    "SELECT * FROM budget_limits WHERE space_id = 's' "
        'AND year = 2026 AND month = 1',
    // Карты лояльности (idx_loyalty_cards_user).
    "SELECT * FROM loyalty_cards WHERE user_id = 'u' AND space_id = ''",
    // Аналитика товаров (idx_product_analytics_scope).
    "SELECT * FROM product_analytics_cache WHERE user_id = 'u' "
        "AND space_id = '' AND day >= '2026-01-01'",
    // Годовые агрегаты (idx_yearly_aggregates_lookup).
    "SELECT * FROM yearly_aggregates WHERE user_id = 'u' AND year = 2025",
  ];

  static Future<void> audit(GeneratedDatabase db) async {
    AppLogger.i(
      'DriftQueryExplainer: аудит EXPLAIN QUERY PLAN '
      '(${hotQueries.length} запросов)',
    );
    var fullScans = 0;
    for (final sql in hotQueries) {
      try {
        final rows = await db.customSelect('EXPLAIN QUERY PLAN $sql').get();
        final plan = rows
            .map((r) => (r.data['detail'] ?? '').toString())
            .join(' | ');
        final isFullScan =
            plan.contains('SCAN') && !plan.contains('USING INDEX');
        if (isFullScan) {
          fullScans++;
          AppLogger.w('DriftQueryExplainer ПОЛНЫЙ СКАН: $sql -> $plan');
        } else {
          AppLogger.i('DriftQueryExplainer: $sql -> $plan');
        }
      } catch (e, st) {
        AppLogger.e('DriftQueryExplainer не выполнен для: $sql', e, st);
      }
    }
    AppLogger.i(
      'DriftQueryExplainer: аудит завершён, полных сканов: $fullScans',
    );
  }
}