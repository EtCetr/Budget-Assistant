import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:mocktail/mocktail.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import 'package:budget_assistant/core/errors/failures.dart';
import 'package:budget_assistant/core/errors/result.dart';
import 'package:budget_assistant/features/savings_goals/domain/usecases/contribute_to_savings_goal_usecase.dart';
import 'package:budget_assistant/features/savings_goals/domain/usecases/get_goal_history_usecase.dart';
import 'package:budget_assistant/features/savings_goals/domain/usecases/withdraw_from_savings_goal_usecase.dart';
import 'package:budget_assistant/features/transactions/domain/models/transaction.dart';
import 'package:budget_assistant/features/transactions/domain/models/transaction_draft.dart';
import 'package:budget_assistant/features/transactions/domain/repositories/transactions_repository.dart';
import 'package:budget_assistant/features/transactions/domain/usecases/create_transaction_usecase.dart';
import '../../../helpers/fake_savings_goals_repository.dart';

class _MockCreateTransaction extends Mock implements CreateTransactionUseCase {}

class _MockTransactionsRepository extends Mock
    implements TransactionsRepository {}

/// Этап 24: пополнение и изъятие цели создают правильные транзакции,
/// история строит кумулятивный график без изъятий (ТЗ 6.3.16 / 6.3.47.6).
Transaction _txFromDraft(TransactionDraft d) => Transaction(
      id: 'tx-1',
      accountId: d.accountId,
      userId: 'u1',
      spaceId: d.spaceId,
      date: d.date,
      amount: d.amount,
      type: d.type,
      savingsGoalId: d.savingsGoalId,
      isWithdrawal: d.isWithdrawal ?? false,
      comment: d.comment,
      createdAt: DateTime.utc(2026, 7, 15),
      updatedAt: DateTime.utc(2026, 7, 15),
    );

Transaction _goalTx({
  required String id,
  required int amount,
  bool withdrawal = false,
  DateTime? date,
}) =>
    Transaction(
      id: id,
      accountId: 'a1',
      userId: 'u1',
      date: date ?? DateTime.utc(2026, 7, 1),
      amount: amount,
      type: withdrawal ? TransactionType.income : TransactionType.expense,
      savingsGoalId: 'g1',
      isWithdrawal: withdrawal,
      createdAt: DateTime.utc(2026, 7, 1),
      updatedAt: DateTime.utc(2026, 7, 1),
    );

void main() {
  late _MockCreateTransaction createTx;
  late _MockTransactionsRepository txRepo;
  late ContributeToSavingsGoalUseCase contribute;
  late WithdrawFromSavingsGoalUseCase withdraw;
  late GetGoalHistoryUseCase history;
  late Logger logger;

  setUpAll(() {
    registerFallbackValue(TransactionDraft(
      accountId: 'a1',
      date: DateTime.utc(2026, 7, 15),
      amount: 1,
      type: TransactionType.expense,
    ));
  });

  setUp(() {
    logger = Logger(level: Level.off);
    createTx = _MockCreateTransaction();
    txRepo = _MockTransactionsRepository();
    contribute = ContributeToSavingsGoalUseCase(
      createTransaction: createTx,
      logger: logger,
    );
    withdraw = WithdrawFromSavingsGoalUseCase(
      createTransaction: createTx,
      logger: logger,
    );
    history = GetGoalHistoryUseCase(repository: txRepo, logger: logger);

    when(() => createTx(
          draft: any(named: 'draft'),
          userId: any(named: 'userId'),
        )).thenAnswer((inv) async {
      final d = inv.namedArguments[#draft] as TransactionDraft;
      return Success(_txFromDraft(d));
    });
  });

  TransactionDraft capturedDraft() => verify(() => createTx(
        draft: captureAny(named: 'draft'),
        userId: any(named: 'userId'),
      )).captured.single as TransactionDraft;

  group('Пополнение цели', () {
    test('нулевая или отрицательная сумма отклоняется без транзакции',
        () async {
      final result = await contribute(
        goal: makeGoal(id: 'g1'),
        accountId: 'a1',
        amountKopecks: 0,
        userId: 'u1',
      );

      expect(result, isA<Error<Transaction>>());
      expect((result as Error<Transaction>).failure, isA<ValidationFailure>());
      verifyNever(() => createTx(
            draft: any(named: 'draft'),
            userId: any(named: 'userId'),
          ));
    });

    test('создаётся расход с привязкой к цели, без признака изъятия',
        () async {
      final result = await contribute(
        goal: makeGoal(id: 'g1', spaceId: 's1'),
        accountId: 'a1',
        amountKopecks: 500000,
        userId: 'u1',
      );

      expect(result, isA<Success<Transaction>>());
      final d = capturedDraft();
      expect(d.type, TransactionType.expense);
      expect(d.savingsGoalId, 'g1');
      expect(d.spaceId, 's1');
      expect(d.isWithdrawal, isFalse);
      expect(d.amount, 500000);
      expect(d.comment, contains('Отпуск'));
    });

    test('свой комментарий пробрасывается', () async {
      await contribute(
        goal: makeGoal(id: 'g1'),
        accountId: 'a1',
        amountKopecks: 100000,
        comment: 'Премия',
        userId: 'u1',
      );

      expect(capturedDraft().comment, 'Премия');
    });

    test('ошибка создания транзакции возвращается как Error', () async {
      when(() => createTx(
            draft: any(named: 'draft'),
            userId: any(named: 'userId'),
          )).thenThrow(Exception('db down'));

      final result = await contribute(
        goal: makeGoal(id: 'g1'),
        accountId: 'a1',
        amountKopecks: 100000,
        userId: 'u1',
      );

      expect(result, isA<Error<Transaction>>());
    });
  });

  group('Изъятие из цели', () {
    test('нулевая сумма отклоняется', () async {
      final result = await withdraw(
        goal: makeGoal(id: 'g1', current: 500000),
        accountId: 'a1',
        amountKopecks: 0,
        userId: 'u1',
      );

      expect((result as Error<Transaction>).failure, isA<ValidationFailure>());
    });

    test('сумма больше накопленного отклоняется без транзакции', () async {
      final result = await withdraw(
        goal: makeGoal(id: 'g1', current: 500000),
        accountId: 'a1',
        amountKopecks: 600000,
        userId: 'u1',
      );

      expect((result as Error<Transaction>).failure, isA<ValidationFailure>());
      verifyNever(() => createTx(
            draft: any(named: 'draft'),
            userId: any(named: 'userId'),
          ));
    });

    test('создаётся доход с признаком изъятия (исключён из P&L)', () async {
      final result = await withdraw(
        goal: makeGoal(id: 'g1', current: 500000, spaceId: 's1'),
        accountId: 'a1',
        amountKopecks: 200000,
        userId: 'u1',
      );

      expect(result, isA<Success<Transaction>>());
      final d = capturedDraft();
      expect(d.type, TransactionType.income);
      expect(d.isWithdrawal, isTrue);
      expect(d.savingsGoalId, 'g1');
      expect(d.spaceId, 's1');
      expect(d.amount, 200000);
    });

    test('изъятие ровно на всю накопленную сумму допустимо', () async {
      final result = await withdraw(
        goal: makeGoal(id: 'g1', current: 500000),
        accountId: 'a1',
        amountKopecks: 500000,
        userId: 'u1',
      );

      expect(result, isA<Success<Transaction>>());
    });
  });

  group('История цели', () {
    test('пустая история: ни транзакций, ни точек графика', () async {
      when(() => txRepo.getTransactionsByGoalId('g1'))
          .thenAnswer((_) async => const []);

      final h = await history('g1');

      expect(h.transactions, isEmpty);
      expect(h.chartData, isEmpty);
    });

    test('график накапливает пополнения по порядку', () async {
      when(() => txRepo.getTransactionsByGoalId('g1')).thenAnswer((_) async => [
            _goalTx(id: 't1', amount: 100000, date: DateTime.utc(2026, 7, 1)),
            _goalTx(id: 't2', amount: 50000, date: DateTime.utc(2026, 7, 5)),
          ]);

      final h = await history('g1');

      expect(h.chartData.map((p) => p.cumulativeAmountKopecks), [100000, 150000]);
    });

    test('изъятия остаются в списке, но не попадают в график', () async {
      when(() => txRepo.getTransactionsByGoalId('g1')).thenAnswer((_) async => [
            _goalTx(id: 't1', amount: 100000),
            _goalTx(id: 't2', amount: 30000, withdrawal: true),
            _goalTx(id: 't3', amount: 20000),
          ]);

      final h = await history('g1');

      expect(h.transactions.length, 3);
      expect(h.chartData.map((p) => p.cumulativeAmountKopecks), [100000, 120000]);
    });

    test('ошибка репозитория пробрасывается', () async {
      when(() => txRepo.getTransactionsByGoalId('g1'))
          .thenThrow(Exception('db down'));

      await expectLater(history('g1'), throwsA(isA<Exception>()));
    });
  });
}