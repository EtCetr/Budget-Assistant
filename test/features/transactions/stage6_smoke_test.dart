import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';

import 'package:budget_assistant/core/enums/transaction_enums.dart';
import 'package:budget_assistant/core/errors/failures.dart';
import 'package:budget_assistant/core/errors/result.dart';
import 'package:budget_assistant/core/ports/clock_port.dart';
import 'package:budget_assistant/features/privacy/domain/models/balance_visibility_mode.dart';
import 'package:budget_assistant/features/privacy/presentation/privacy_formatter.dart';
import 'package:budget_assistant/features/transactions/domain/models/secrecy_config.dart';
import 'package:budget_assistant/features/transactions/domain/models/transaction.dart';
import 'package:budget_assistant/features/transactions/domain/models/transaction_draft.dart';
import 'package:budget_assistant/features/transactions/domain/models/transaction_split.dart';
import 'package:budget_assistant/features/transactions/domain/repositories/transactions_repository.dart';
import 'package:budget_assistant/features/transactions/domain/usecases/create_transaction_usecase.dart';
import 'package:budget_assistant/features/transactions/domain/usecases/delete_transaction_usecase.dart';
import 'package:budget_assistant/features/transactions/domain/usecases/update_transaction_usecase.dart';

/// Заглушка часов: всегда возвращает 1000 мс с момента «загрузки устройства».
class FakeClock implements ClockPort {
  const FakeClock();

  @override
  Future<int> elapsedRealtimeMs() async => 1000;
}

/// Репозиторий-заглушка в памяти.
///
/// Нам не нужна реальная БД в этом тесте: здесь проверяется БИЗНЕС-ЛОГИКА
/// (валидация, pending, блокировка). Реальные Drift-тесты будут в Этапе 24.
class FakeTransactionsRepository implements TransactionsRepository {
  final Map<String, Transaction> store = {};
  final Map<String, List<TransactionSplit>> splitsStore = {};

  @override
  Future<void> createTransaction(
    Transaction transaction,
    List<TransactionSplit> splits,
  ) async {
    store[transaction.id] = transaction;
    splitsStore[transaction.id] = splits;
  }

  @override
  Future<void> updateTransaction(
    Transaction transaction,
    List<TransactionSplit> splits,
  ) async {
    store[transaction.id] = transaction;
    splitsStore[transaction.id] = splits;
  }

  @override
  Future<int> deleteTransaction(String id, String userId) async {
    final tx = store[id];
    if (tx == null || tx.userId != userId) return 0;
    store.remove(id);
    splitsStore.remove(id);
    return 1;
  }

  @override
  Future<Transaction?> getTransactionById(String id) async => store[id];

  @override
  Future<List<TransactionSplit>> getSplitsForTransaction(
    String transactionId,
  ) async {
    return splitsStore[transactionId] ?? const [];
  }
}

void main() {
  late FakeTransactionsRepository repo;
  late Logger logger;
  late CreateTransactionUseCase createUseCase;
  late UpdateTransactionUseCase updateUseCase;
  late DeleteTransactionUseCase deleteUseCase;

  setUp(() {
    repo = FakeTransactionsRepository();
    logger = Logger(level: Level.off);
    createUseCase = CreateTransactionUseCase(
      repository: repo,
      logger: logger,
      clock: const FakeClock(),
    );
    updateUseCase = UpdateTransactionUseCase(
      repository: repo,
      logger: logger,
      clock: const FakeClock(),
    );
    deleteUseCase = DeleteTransactionUseCase(
      repository: repo,
      logger: logger,
    );
  });

  TransactionDraft draft({
    int amount = 5000,
    TransactionType type = TransactionType.expense,
    String? linkedAccountId,
    List<TransactionSplitDraft>? splits,
  }) {
    return TransactionDraft(
      accountId: 'acc-1',
      linkedAccountId: linkedAccountId,
      date: DateTime.utc(2026, 7, 10, 12, 0),
      amount: amount,
      type: type,
      merchantName: 'Перекрёсток',
      splits: splits,
    );
  }

  test('DoD 1: транзакция создаётся с sync_status = pending', () async {
    final result = await createUseCase(draft: draft(), userId: 'user-1');

    expect(result, isA<Success<Transaction>>());
    final tx = (result as Success<Transaction>).value;

    expect(tx.syncStatus, SyncStatus.pending);
    expect(repo.store.containsKey(tx.id), isTrue);
    expect(repo.store[tx.id]!.syncStatus, SyncStatus.pending);
  });

  test('Валидация: amount <= 0 отклоняется', () async {
    final result = await createUseCase(draft: draft(amount: 0), userId: 'user-1');

    expect(result, isA<Error<Transaction>>());
    expect((result as Error<Transaction>).failure, isA<ValidationFailure>());
    expect(repo.store, isEmpty);
  });

  test('Валидация: перевод на тот же счёт отклоняется', () async {
    final result = await createUseCase(
      draft: draft(type: TransactionType.transfer, linkedAccountId: 'acc-1'),
      userId: 'user-1',
    );

    expect(result, isA<Error<Transaction>>());
    expect((result as Error<Transaction>).failure, isA<ValidationFailure>());
  });

  test('Валидация: сумма сплитов должна равняться сумме транзакции', () async {
    final result = await createUseCase(
      draft: draft(
        splits: [
          TransactionSplitDraft(categoryId: 'cat-1', amount: 1000),
        ],
      ),
      userId: 'user-1',
    );

    expect(result, isA<Error<Transaction>>());
    expect((result as Error<Transaction>).failure, isA<ValidationFailure>());
  });

  test('DoD 2: крупная трата блокирует синхронизацию', () async {
    final result = await createUseCase(
      draft: draft(amount: 15000000), // 150 000 ₽ > порога 100 000 ₽
      userId: 'user-1',
      secrecyConfig: SecrecyConfig(
        enabled: true,
        threshold: 10000000,
        timeoutSeconds: 120,
      ),
    );

    final tx = (result as Success<Transaction>).value;

    expect(tx.syncLockedStartedAt, 1000); // значение FakeClock
    expect(tx.syncLockedDurationMs, 120000); // 120 сек * 1000
  });

  test('Обновление: isUserEdited = true и снова pending', () async {
    final created = (await createUseCase(draft: draft(), userId: 'user-1')
            as Success<Transaction>)
        .value;

    final result = await updateUseCase(
      draft: draft(amount: 7000).copyWith(id: created.id),
      userId: 'user-1',
    );

    final tx = (result as Success<Transaction>).value;

    expect(tx.isUserEdited, isTrue);
    expect(tx.syncStatus, SyncStatus.pending);
    expect(tx.amount, 7000);
  });

  test('Удаление несуществующей транзакции -> NotFound', () async {
    final result = await deleteUseCase(id: 'missing', userId: 'user-1');

    expect(result, isA<Error<void>>());
    expect((result as Error<void>).failure, isA<NotFoundFailure>());
  });

  group('DoD 3: PrivacyFormatter', () {
    const formatter = PrivacyFormatter();

    test('суммы маскируются в partial и hidden', () {
      expect(
        formatter.formatAmount(15000000, 'RUB', BalanceVisibilityMode.visible),
        isNot('•••'),
      );
      expect(
        formatter.formatAmount(15000000, 'RUB', BalanceVisibilityMode.partial),
        '•••',
      );
      expect(
        formatter.formatAmount(15000000, 'RUB', BalanceVisibilityMode.hidden),
        '•••',
      );
    });

    test('мерчант виден в partial, скрыт в hidden', () {
      expect(
        formatter.formatMerchant('Перекрёсток', BalanceVisibilityMode.partial),
        'Перекрёсток',
      );
      expect(
        formatter.formatMerchant('Перекрёсток', BalanceVisibilityMode.hidden),
        '•••',
      );
    });
  });
}