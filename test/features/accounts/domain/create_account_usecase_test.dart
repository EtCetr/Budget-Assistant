import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
import 'package:budget_assistant/core/utils/result.dart';
import 'package:budget_assistant/features/accounts/domain/entities/account.dart';
import 'package:budget_assistant/features/accounts/domain/entities/account_types.dart';
import 'package:budget_assistant/features/accounts/domain/usecases/create_account_usecase.dart';
import '../../../helpers/fake_account_repository.dart';

/// Этап 24: создание счёта — Offline-First (pending) и локальный профиль.
void main() {
  late FakeAccountRepository repo;
  late CreateAccountUseCase useCase;

  setUp(() {
    repo = FakeAccountRepository();
    useCase = CreateAccountUseCase(
      repository: repo,
      logger: Logger(level: Level.off),
      uuid: const Uuid(),
    );
  });

  Future<Result<Account>> run({
    String? spaceId,
    bool isSharedBalance = false,
    int? creditLimit,
    String? cardNumberMask,
    DateTime? gracePeriodEnd,
    int? minPaymentAmount,
  }) =>
      useCase.execute(
        userId: 'u1',
        bankName: 'Т-Банк',
        customName: 'Black',
        accountType: AccountTypes.debit,
        currency: 'RUB',
        currentBalance: 150000,
        spaceId: spaceId,
        isSharedBalance: isSharedBalance,
        creditLimit: creditLimit,
        cardNumberMask: cardNumberMask,
        gracePeriodEnd: gracePeriodEnd,
        minPaymentAmount: minPaymentAmount,
      );

  test('локальный профиль создаётся ДО вставки счёта (FK)', () async {
    final result = await run();

    expect(result.isSuccess, isTrue);
    expect(repo.lastEnsuredUserId, 'u1');
    expect(repo.calls, ['ensureLocalUser', 'insertAccount']);
  });

  test('новый счёт: pending, UTC-даты, непустой id', () async {
    final account = (await run()).value;

    expect(account.id, isNotEmpty);
    expect(account.syncStatus, 'pending');
    expect(account.createdAt.isUtc, isTrue);
    expect(account.updatedAt.isUtc, isTrue);
    expect(repo.accounts.containsKey(account.id), isTrue);
  });

  test('значения по умолчанию: личный баланс, не архив, не системный',
      () async {
    final account = (await run()).value;

    expect(account.includeInPersonalBalance, isTrue);
    expect(account.includeInFamilyBalance, isFalse);
    expect(account.isSharedBalance, isFalse);
    expect(account.isArchived, isFalse);
    expect(account.isSystem, isFalse);
    expect(account.spaceId, isNull);
  });

  test('семейный счёт и кредитные поля пробрасываются', () async {
    final grace = DateTime.utc(2026, 8, 1);
    final account = (await run(
      spaceId: 's1',
      isSharedBalance: true,
      creditLimit: 5000000,
      cardNumberMask: '*1234',
      gracePeriodEnd: grace,
      minPaymentAmount: 300000,
    ))
        .value;

    expect(account.spaceId, 's1');
    expect(account.isSharedBalance, isTrue);
    expect(account.creditLimit, 5000000);
    expect(account.cardNumberMask, '*1234');
    expect(account.gracePeriodEnd, grace);
    expect(account.minPaymentAmount, 300000);
  });

  test('сумма хранится в копейках без изменений', () async {
    expect((await run()).value.currentBalance, 150000);
  });

  test('ошибка репозитория: FailureResult, счёт не сохранён', () async {
    repo.error = Exception('db down');

    final result = await run();

    expect(result.isFailure, isTrue);
    expect(result, isA<FailureResult<Account>>());
    expect(repo.accounts, isEmpty);
  });
}