import '../entities/debt.dart';
import '../entities/debts_stats.dart';

/// Статистика для шапки DebtsScreen (6.3.13.4): суммы только активных
/// долгов, просрочка — по due_date < now (UTC).
class CalculateDebtsStatsUseCase {
  DebtsStats call(List<Debt> debts, {required String userId, DateTime? nowUtc}) {
    final now = nowUtc ?? DateTime.now().toUtc();
    var payable = 0;
    var receivable = 0;
    var overdue = 0;
    for (final d in debts) {
      if (!d.isActive) continue;
      final dir = d.directionFor(userId);
      if (dir == null) continue;
      if (dir == DebtDirection.payable) {
        payable += d.amount;
      } else {
        receivable += d.amount;
      }
      if (d.isOverdueAt(now)) overdue++;
    }
    return DebtsStats(
      payableTotalKopecks: payable,
      receivableTotalKopecks: receivable,
      overdueCount: overdue,
    );
  }
}