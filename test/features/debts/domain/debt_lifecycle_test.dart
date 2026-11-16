import 'package:flutter_test/flutter_test.dart';
import 'package:budget_assistant/features/debts/domain/usecases/delete_debt_usecase.dart';
import 'package:budget_assistant/features/debts/domain/usecases/extend_debt_due_date_usecase.dart';
import 'package:budget_assistant/features/debts/domain/usecases/mark_debts_as_ex_member_usecase.dart';
import 'package:budget_assistant/features/debts/domain/usecases/resolve_debt_usecase.dart';
import 'package:budget_assistant/features/debts/domain/usecases/update_debt_usecase.dart';
import '../../../helpers/fake_debts_repository.dart';

/// Этап 24: жизненный цикл долга — закрытие, продление, удаление, ex-member.
/// Все действия доступны только создателю записи.
void main() {
  late FakeDebtsRepository repo;
  late ResolveDebtUseCase resolve;
  late ExtendDebtDueDateUseCase extend;
  late DeleteDebtUseCase delete;
  late UpdateDebtUseCase update;
  late MarkDebtsAsExMemberUseCase markEx;

  setUp(() {
    repo = FakeDebtsRepository();
    resolve = ResolveDebtUseCase(repository: repo);
    extend = ExtendDebtDueDateUseCase(repository: repo);
    delete = DeleteDebtUseCase(repository: repo);
    update = UpdateDebtUseCase(repository: repo);
    markEx = MarkDebtsAsExMemberUseCase(repository: repo);
  });

  test('закрытие долга: только создатель', () async {
    await repo.insert(makeDebt(
      id: 'd1',
      debtorId: 'a',
      creditorId: 'b',
      createdBy: 'a',
    ));

    await resolve(debtId: 'd1', status: 'resolved', actorUserId: 'a');

    expect(repo.resolves.single.status, 'resolved');
  });

  test('закрытие долга: не создатель -> StateError', () async {
    await repo.insert(makeDebt(
      id: 'd1',
      debtorId: 'a',
      creditorId: 'b',
      createdBy: 'a',
    ));

    await expectLater(
      resolve(debtId: 'd1', status: 'resolved', actorUserId: 'b'),
      throwsA(isA<StateError>()),
    );
  });

  test('продление срока: только создатель', () async {
    await repo.insert(makeDebt(
      id: 'd1',
      debtorId: 'a',
      creditorId: 'b',
      createdBy: 'a',
    ));
    final newDue = DateTime.utc(2027, 1, 1);

    await extend(debtId: 'd1', newDueDateUtc: newDue, actorUserId: 'a');

    expect(repo.extensions.single.due, newDue);
  });

  test('удаление: только создатель', () async {
    await repo.insert(makeDebt(
      id: 'd1',
      debtorId: 'a',
      creditorId: 'b',
      createdBy: 'a',
    ));

    await delete(debtId: 'd1', actorUserId: 'a');

    expect(repo.calls, contains('delete'));
    expect(repo.debts, isEmpty);
  });

  test('удаление чужого долга -> StateError', () async {
    await repo.insert(makeDebt(
      id: 'd1',
      debtorId: 'a',
      creditorId: 'b',
      createdBy: 'a',
    ));

    await expectLater(
      delete(debtId: 'd1', actorUserId: 'b'),
      throwsA(isA<StateError>()),
    );
  });

  test('правка долга: только создатель', () async {
    final d = makeDebt(
      id: 'd1',
      debtorId: 'a',
      creditorId: 'b',
      createdBy: 'a',
    );
    await repo.insert(d);

    await update(debt: d.copyWith(amount: 200000), actorUserId: 'a');

    expect(repo.calls, contains('update'));
    expect(repo.debts['d1']!.amount, 200000);
  });

  test('ex-member: помечаются только активные долги участника', () async {
    await repo.insert(makeDebt(
      id: 'd1',
      debtorId: 'leaving',
      creditorId: 'b',
      createdBy: 'b',
    ));
    await repo.insert(makeDebt(
      id: 'd2',
      debtorId: 'a',
      creditorId: 'leaving',
      createdBy: 'a',
    ));
    await repo.insert(makeDebt(
      id: 'd3',
      debtorId: 'leaving',
      creditorId: 'b',
      createdBy: 'b',
      resolutionStatus: 'resolved',
    ));

    final count = await markEx(memberUserId: 'leaving');

    expect(count, 2);
    expect(repo.markedExMember, ['leaving']);
  });
}