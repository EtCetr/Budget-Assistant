import '../entities/debt.dart';

/// Просроченные активные долги (красный бейдж, 6.3.13.6).
class CheckOverdueDebtsUseCase {
  List<Debt> call(List<Debt> debts, {DateTime? nowUtc}) {
    final now = nowUtc ?? DateTime.now().toUtc();
    return debts.where((d) => d.isOverdueAt(now)).toList();
  }
}