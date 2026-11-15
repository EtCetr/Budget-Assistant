import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/errors/failures.dart';
import 'package:budget_assistant/core/utils/result.dart';
import 'package:budget_assistant/features/accounts/domain/entities/account_types.dart';
import 'package:budget_assistant/features/accounts/domain/usecases/update_account_usecase.dart';
import '../../../helpers/fake_account_repository.dart';

/// Этап 24: правка счёта — валидация до записи, обрезка пробелов.
void main() {
  late FakeAccountRepository repo;
  late UpdateAccountUseCase useCase;

  setUp(() {
    repo = FakeAccountRepository();
    repo.accounts['a'] = makeAccount(id: 'a', balance: 100000);
    useCase = UpdateAccountUseCase(
      repository: repo,
      logger: Logger(level: Level.off),
    );
  });

  Future<Result<void>> run({
    String customName = 'Black',
    String bankName = 'Т-Банк',
    String accountType = AccountTypes.debit,
    int currentBalance = 200000,
    String? cardNumberMask,
    int? creditLimit,
  }) =>
      useCase.execute(
        accountId: 'a',
        bankName: bankName,
        customName: customName,
        accountType: accountType,
        currency: 'RUB',
        currentBalance: currentBalance,
        cardNumberMask: cardNumberMask,
        creditLimit: creditLimit,
      );

  test('пустое название отклоняется, запись не выполняется', () async {
    final result = await run(customName: '');

    expect(result.isFailure, isTrue);
    expect(result.error, isA<ValidationFailure>());
    expect(repo.calls, isEmpty);
  });

  test('название из пробелов отклоняется', () async {
    final result = await run(customName: '   ');

    expect(result.error, isA<ValidationFailure>());
    expect(repo.calls, isEmpty);
  });

  test('неизвестный тип счёта отклоняется', () async {
    final result = await run(accountType: 'crypto_wallet');

    expect(result.error, isA<ValidationFailure>());
    expect(repo.calls, isEmpty);
  });

  test('все допустимые типы проходят валидацию', () async {
    for (final type in AccountTypes.all) {
      final result = await run(accountType: type);
      expect(result.isSuccess, isTrue, reason: 'Тип $type должен проходить');
    }
  });

  test('пробелы по краям банка и названия обрезаются', () async {
    await run(bankName: '  Т-Банк  ', customName: '  Black  ');

    expect(repo.lastUpdate?.bankName, 'Т-Банк');
    expect(repo.lastUpdate?.customName, 'Black');
  });

  test('поля пробрасываются в репозиторий без изменений', () async {
    await run(
      currentBalance: 777777,
      cardNumberMask: '*4321',
      creditLimit: 10000000,
    );

    final u = repo.lastUpdate!;
    expect(u.accountId, 'a');
    expect(u.currency, 'RUB');
    expect(u.currentBalance, 777777);
    expect(u.cardNumberMask, '*4321');
    expect(u.creditLimit, 10000000);
  });

  test('исключение репозитория превращается в DatabaseFailure', () async {
    repo.error = Exception('db down');

    final result = await run();

    expect(result.isFailure, isTrue);
    expect(result.error, isA<DatabaseFailure>());
  });

  test('готовая ошибка репозитория пробрасывается как есть', () async {
    repo.updateFailure = const Failure.notFound('Счёт не найден');

    final result = await run();

    expect(result.isFailure, isTrue);
    expect(result.error, isA<NotFoundFailure>());
  });
}