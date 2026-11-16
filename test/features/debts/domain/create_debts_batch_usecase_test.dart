import 'package:flutter_test/flutter_test.dart';
import 'package:budget_assistant/features/debts/domain/usecases/create_debts_batch_usecase.dart';
import '../../../helpers/fake_debts_repository.dart';

/// Этап 24: создание долгов — деление суммы поровну, внешний контрагент.
void main() {
  late FakeDebtsRepository repo;
  late CreateDebtsBatchUseCase useCase;

  setUp(() {
    repo = FakeDebtsRepository();
    useCase = CreateDebtsBatchUseCase(repository: repo);
  });

  test('один член семьи: один долг на полную сумму', () async {
    final debts = await useCase(
      creatorUserId: 'me',
      spaceId: 's1',
      debtType: 'payable',
      memberIds: const ['other'],
      amountKopecks: 100000,
    );

    expect(debts.length, 1);
    expect(debts.single.amount, 100000);
    expect(debts.single.debtorId, 'me');
    expect(debts.single.creditorId, 'other');
    expect(debts.single.spaceId, 's1');
  });

  test('два члена семьи: сумма делится поровну, остаток первому', () async {
    final debts = await useCase(
      creatorUserId: 'me',
      spaceId: 's1',
      debtType: 'receivable',
      memberIds: const ['a', 'b'],
      amountKopecks: 100001,
    );

    expect(debts.length, 2);
    expect(debts[0].amount, 50001); // остаток первому
    expect(debts[1].amount, 50000);
    expect(debts[0].creditorId, 'me');
    expect(debts[0].debtorId, 'a');
    expect(debts[1].creditorId, 'me');
    expect(debts[1].debtorId, 'b');
  });

  test('внешний контрагент: NULL-сторона + имя в дательном', () async {
    final debts = await useCase(
      creatorUserId: 'me',
      spaceId: null,
      debtType: 'payable',
      memberIds: const [],
      externalNameDative: 'Ивану',
      amountKopecks: 50000,
    );

    expect(debts.length, 1);
    expect(debts.single.debtorId, 'me');
    expect(debts.single.creditorId, isNull);
    expect(debts.single.counterpartyNameDative, 'Ивану');
  });

  test('создатель исключается из memberIds', () async {
    final debts = await useCase(
      creatorUserId: 'me',
      spaceId: null,
      debtType: 'payable',
      memberIds: const ['me', 'other'],
      amountKopecks: 100000,
    );

    expect(debts.length, 1);
    expect(debts.single.debtorId, 'me');
    expect(debts.single.creditorId, 'other');
  });

  test('нет контрагента -> ArgumentError', () async {
    await expectLater(
      useCase(
        creatorUserId: 'me',
        spaceId: null,
        debtType: 'payable',
        memberIds: const [],
        externalNameDative: '',
        amountKopecks: 100000,
      ),
      throwsA(isA<ArgumentError>()),
    );
  });

  test('сумма <= 0 -> ArgumentError', () async {
    await expectLater(
      useCase(
        creatorUserId: 'me',
        spaceId: null,
        debtType: 'payable',
        memberIds: const ['other'],
        amountKopecks: 0,
      ),
      throwsA(isA<ArgumentError>()),
    );
  });

  test('сумма меньше числа членов -> ArgumentError', () async {
    await expectLater(
      useCase(
        creatorUserId: 'me',
        spaceId: null,
        debtType: 'payable',
        memberIds: const ['a', 'b', 'c'],
        amountKopecks: 2,
      ),
      throwsA(isA<ArgumentError>()),
    );
  });

  test('все долги имеют syncStatus=pending и UTC-даты', () async {
    final debts = await useCase(
      creatorUserId: 'me',
      spaceId: null,
      debtType: 'payable',
      memberIds: const ['other'],
      amountKopecks: 100000,
    );

    expect(debts.single.syncStatus.name, 'pending');
    expect(debts.single.createdAt.isUtc, isTrue);
    expect(debts.single.updatedAt.isUtc, isTrue);
  });
}