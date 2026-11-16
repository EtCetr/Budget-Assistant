import 'package:flutter_test/flutter_test.dart';
import 'package:budget_assistant/features/debts/domain/entities/debt.dart';
import '../../../helpers/fake_debts_repository.dart';

/// Этап 24: DebtX — directionFor, isExternal, isOverdueAt, isActive.
void main() {
  test('направление: я должник -> payable', () {
    final d = makeDebt(id: 'd1', debtorId: 'me', creditorId: 'other', createdBy: 'me');
    expect(d.directionFor('me'), DebtDirection.payable);
  });

  test('направление: я кредитор -> receivable', () {
    final d = makeDebt(id: 'd1', debtorId: 'other', creditorId: 'me', createdBy: 'me');
    expect(d.directionFor('me'), DebtDirection.receivable);
  });

  test('направление: чужой долг -> null', () {
    final d = makeDebt(id: 'd1', debtorId: 'a', creditorId: 'b', createdBy: 'a');
    expect(d.directionFor('me'), isNull);
  });

  test('внешний контрагент: одна сторона NULL', () {
    final d = makeDebt(id: 'd1', debtorId: null, creditorId: 'me', createdBy: 'me');
    expect(d.isExternal, isTrue);
  });

  test('семейный долг: обе стороны заполнены', () {
    final d = makeDebt(id: 'd1', debtorId: 'a', creditorId: 'b', createdBy: 'a');
    expect(d.isExternal, isFalse);
  });

  test('просрочка: dueDate в прошлом и активен', () {
    final d = makeDebt(
      id: 'd1',
      debtorId: 'a',
      creditorId: 'b',
      createdBy: 'a',
      dueDate: DateTime.utc(2026, 1, 1),
    );
    expect(d.isOverdueAt(DateTime.utc(2026, 7, 15)), isTrue);
  });

  test('просрочка: закрытый долг не просрочен', () {
    final d = makeDebt(
      id: 'd1',
      debtorId: 'a',
      creditorId: 'b',
      createdBy: 'a',
      dueDate: DateTime.utc(2026, 1, 1),
      resolutionStatus: DebtResolutionStatus.resolved,
    );
    expect(d.isOverdueAt(DateTime.utc(2026, 7, 15)), isFalse);
  });

  test('просрочка: без dueDate не просрочен', () {
    final d = makeDebt(id: 'd1', debtorId: 'a', creditorId: 'b', createdBy: 'a');
    expect(d.isOverdueAt(DateTime.utc(2026, 7, 15)), isFalse);
  });

  test('isActive только при active статусе', () {
    expect(
      makeDebt(id: 'd1', debtorId: 'a', creditorId: 'b', createdBy: 'a').isActive,
      isTrue,
    );
    expect(
      makeDebt(
        id: 'd1',
        debtorId: 'a',
        creditorId: 'b',
        createdBy: 'a',
        resolutionStatus: DebtResolutionStatus.forgiven,
      ).isActive,
      isFalse,
    );
  });
}