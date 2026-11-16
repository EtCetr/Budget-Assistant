import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import 'package:budget_assistant/features/debts/domain/entities/debt.dart';
import 'package:budget_assistant/features/debts/domain/usecases/close_debt_usecase.dart';
import '../../../helpers/fake_debts_repository.dart';
import '../../../helpers/fake_system_category_port.dart';
import '../../../helpers/fake_transactions_repository_for_debts.dart';

/// Этап 24: CloseDebtUseCase — Сценарии А/Б, компенсации, проверки.
///
/// Сценарий сравнивает месяц СОЗДАНИЯ долга с месяцем закрытия, а закрытие
/// использует DateTime.now(). Поэтому даты в тестах относительные:
/// «сейчас» = Сценарий А, минус 40 дней = Сценарий Б.
void main() {
  late FakeDebtsRepository debtsRepo;
  late FakeTransactionsRepositoryForDebts txRepo;
  late FakeSystemCategoryPort systemCategory;
  late CloseDebtUseCase useCase;

  setUp(() {
    debtsRepo = FakeDebtsRepository();
    txRepo = FakeTransactionsRepositoryForDebts();
    systemCategory = FakeSystemCategoryPort();
    useCase = CloseDebtUseCase(
      debtsRepository: debtsRepo,
      transactionsRepository: txRepo,
      systemCategory: systemCategory,
      logger: Logger(level: Level.off),
    );
  });

  Future<void> seedDebt({
    String id = 'd1',
    String? debtorId = 'debtor',
    String? creditorId = 'creditor',
    int amount = 100000,
    String? categoryId = 'c1',
    String? originalTxId,
    DateTime? createdAt,
    String resolutionStatus = DebtResolutionStatus.active,
  }) async {
    await debtsRepo.insert(makeDebt(
      id: id,
      debtorId: debtorId,
      creditorId: creditorId,
      amount: amount,
      categoryId: categoryId,
      originalTransactionId: originalTxId,
      resolutionStatus: resolutionStatus,
      createdBy: debtorId ?? creditorId ?? 'me',
      createdAt: createdAt ?? DateTime.now().toUtc(),
    ));
  }

  test('Сценарий А: тот же месяц -> категория исходной траты', () async {
    await seedDebt(categoryId: 'c1');

    await useCase(
      debtId: 'd1',
      actorUserId: 'debtor',
      compensationAccountId: 'acc',
      status: DebtResolutionStatus.resolved,
    );

    expect(txRepo.created.length, 2);
    final expense =
        txRepo.created.firstWhere((t) => t.type == TransactionType.expense);
    final income =
        txRepo.created.firstWhere((t) => t.type == TransactionType.income);

    expect(expense.customCategoryId, 'c1');
    expect(income.customCategoryId, 'c1');
    expect(expense.userId, 'debtor');
    expect(income.userId, 'creditor');
    expect(expense.amount, 100000);
    expect(income.amount, 100000);
    expect(expense.spaceId, isNull);
    expect(income.spaceId, isNull);
    expect(systemCategory.lastUserId, isNull);
  });

  test('Сценарий Б: другой месяц -> системная категория', () async {
    await seedDebt(
      categoryId: 'c1',
      createdAt: DateTime.now().toUtc().subtract(const Duration(days: 40)),
    );

    await useCase(
      debtId: 'd1',
      actorUserId: 'debtor',
      compensationAccountId: 'acc',
    );

    expect(systemCategory.lastUserId, 'debtor');
    final expense =
        txRepo.created.firstWhere((t) => t.type == TransactionType.expense);
    expect(expense.customCategoryId, 'cat_sys_debt_repayment');
  });

  test('долг не найден -> StateError', () async {
    await expectLater(
      useCase(
        debtId: 'missing',
        actorUserId: 'me',
        compensationAccountId: 'acc',
      ),
      throwsA(isA<StateError>()),
    );
  });

  test('долг уже закрыт -> StateError', () async {
    await seedDebt(resolutionStatus: DebtResolutionStatus.resolved);

    await expectLater(
      useCase(
        debtId: 'd1',
        actorUserId: 'debtor',
        compensationAccountId: 'acc',
      ),
      throwsA(isA<StateError>()),
    );
  });

  test('актёр не сторона долга -> StateError', () async {
    await seedDebt();

    await expectLater(
      useCase(
        debtId: 'd1',
        actorUserId: 'stranger',
        compensationAccountId: 'acc',
      ),
      throwsA(isA<StateError>()),
    );
  });

  test('внешний долг (NULL кредитор): компенсация только должнику', () async {
    await seedDebt(creditorId: null, debtorId: 'me');

    await useCase(
      debtId: 'd1',
      actorUserId: 'me',
      compensationAccountId: 'acc',
    );

    expect(txRepo.created.length, 1);
    expect(txRepo.created.single.type, TransactionType.expense);
  });

  test('долг закрывается после создания компенсаций', () async {
    await seedDebt();

    await useCase(
      debtId: 'd1',
      actorUserId: 'debtor',
      compensationAccountId: 'acc',
      status: DebtResolutionStatus.forgiven,
    );

    expect(debtsRepo.resolves.single.status, DebtResolutionStatus.forgiven);
  });

  test('autoResolveLinked делегирует репозиторию', () async {
    final count = await useCase.autoResolveLinked(transactionId: 'tx1');

    expect(count, 0);
    expect(debtsRepo.autoResolved, ['tx1']);
  });
}