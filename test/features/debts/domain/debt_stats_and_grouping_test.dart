import 'package:flutter_test/flutter_test.dart';
import 'package:budget_assistant/features/debts/domain/entities/debt.dart';
import 'package:budget_assistant/features/debts/domain/usecases/calculate_debts_stats_usecase.dart';
import 'package:budget_assistant/features/debts/domain/usecases/check_overdue_debts_usecase.dart';
import 'package:budget_assistant/features/debts/domain/usecases/group_debts_by_status_usecase.dart';
import '../../../helpers/fake_debts_repository.dart';

/// Этап 24: статистика долгов, просрочка и группировка по вкладкам.
void main() {
  late CalculateDebtsStatsUseCase stats;
  late CheckOverdueDebtsUseCase overdue;
  late GroupDebtsByStatusUseCase group;

  setUp(() {
    stats = CalculateDebtsStatsUseCase();
    overdue = CheckOverdueDebtsUseCase();
    group = GroupDebtsByStatusUseCase();
  });

  final now = DateTime.utc(2026, 7, 15);

  test('статистика: payable, receivable и просрочка', () {
    final debts = [
      makeDebt(
        id: '1',
        debtorId: 'me',
        creditorId: 'o',
        createdBy: 'me',
      ),
      makeDebt(
        id: '2',
        debtorId: 'o',
        creditorId: 'me',
        createdBy: 'o',
        amount: 200000,
      ),
      makeDebt(
        id: '3',
        debtorId: 'me',
        creditorId: 'o',
        createdBy: 'me',
        amount: 50000,
        dueDate: DateTime.utc(2026, 1, 1),
      ),
      makeDebt(
        id: '4',
        debtorId: 'me',
        creditorId: 'o',
        createdBy: 'me',
        amount: 30000,
        resolutionStatus: DebtResolutionStatus.resolved,
      ),
    ];

    final s = stats(debts, userId: 'me', nowUtc: now);

    expect(s.payableTotalKopecks, 150000);
    expect(s.receivableTotalKopecks, 200000);
    expect(s.overdueCount, 1);
  });

  test('статистика: чужие долги не считаются', () {
    final debts = [
      makeDebt(id: '1', debtorId: 'a', creditorId: 'b', createdBy: 'a'),
    ];

    expect(stats(debts, userId: 'me', nowUtc: now).payableTotalKopecks, 0);
  });

  test('просрочка: только активные с dueDate в прошлом', () {
    final debts = [
      makeDebt(
        id: '1',
        debtorId: 'me',
        creditorId: 'o',
        createdBy: 'me',
        dueDate: DateTime.utc(2026, 1, 1),
      ),
      makeDebt(
        id: '2',
        debtorId: 'me',
        creditorId: 'o',
        createdBy: 'me',
        dueDate: DateTime.utc(2027, 1, 1),
      ),
      makeDebt(
        id: '3',
        debtorId: 'me',
        creditorId: 'o',
        createdBy: 'me',
        dueDate: DateTime.utc(2026, 1, 1),
        resolutionStatus: DebtResolutionStatus.resolved,
      ),
    ];

    final result = overdue(debts, nowUtc: now);

    expect(result.length, 1);
    expect(result.single.id, '1');
  });

  test('группировка: активные и закрытые по направлению', () {
    final debts = [
      makeDebt(id: '1', debtorId: 'me', creditorId: 'o', createdBy: 'me'),
      makeDebt(id: '2', debtorId: 'o', creditorId: 'me', createdBy: 'o'),
      makeDebt(
        id: '3',
        debtorId: 'me',
        creditorId: 'o',
        createdBy: 'me',
        resolutionStatus: DebtResolutionStatus.resolved,
      ),
      makeDebt(
        id: '4',
        debtorId: 'o',
        creditorId: 'me',
        createdBy: 'o',
        resolutionStatus: DebtResolutionStatus.forgiven,
      ),
    ];

    final g = group(debts, userId: 'me');

    expect(g.payableActive.map((d) => d.id), ['1']);
    expect(g.receivableActive.map((d) => d.id), ['2']);
    expect(g.payableClosed.map((d) => d.id), ['3']);
    expect(g.receivableClosed.map((d) => d.id), ['4']);
  });

  test('группировка: чужие долги игнорируются', () {
    final debts = [
      makeDebt(id: '1', debtorId: 'a', creditorId: 'b', createdBy: 'a'),
    ];

    final g = group(debts, userId: 'me');

    expect(g.payableActive, isEmpty);
    expect(g.receivableActive, isEmpty);
  });
}