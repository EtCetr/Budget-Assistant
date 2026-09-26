import '../entities/debt.dart';
import '../entities/debts_groups.dart';

/// Группировка по вкладкам «Я должен» / «Мне должны» и секциям
/// активные/закрытые (6.3.13.3/.5). Порядок — как из репозитория
/// (due_date nulls last, затем createdAt desc).
class GroupDebtsByStatusUseCase {
  DebtsGroups call(List<Debt> debts, {required String userId}) {
    final payableActive = <Debt>[];
    final payableClosed = <Debt>[];
    final receivableActive = <Debt>[];
    final receivableClosed = <Debt>[];
    for (final d in debts) {
      final dir = d.directionFor(userId);
      if (dir == null) continue;
      if (dir == DebtDirection.payable) {
        d.isActive ? payableActive.add(d) : payableClosed.add(d);
      } else {
        d.isActive ? receivableActive.add(d) : receivableClosed.add(d);
      }
    }
    return DebtsGroups(
      payableActive: payableActive,
      payableClosed: payableClosed,
      receivableActive: receivableActive,
      receivableClosed: receivableClosed,
    );
  }
}