import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/utils/result.dart';
import 'package:budget_assistant/features/accounts/domain/entities/account_types.dart';
import 'package:budget_assistant/features/accounts/domain/usecases/calculate_net_worth_usecase.dart';
import '../../../helpers/fake_account_repository.dart';

/// Этап 24: Net Worth = активы − обязательства + капитал по ипотеке
/// (ТОМ 4 §5.2). Деньги — целые копейки.
void main() {
  late FakeAccountRepository repo;
  late CalculateNetWorthUseCase useCase;

  setUp(() {
    repo = FakeAccountRepository();
    useCase = CalculateNetWorthUseCase(
      repository: repo,
      logger: Logger(level: Level.off),
    );
  });

  Future<int> netWorth() async {
    final result = await useCase.execute('u1');
    expect(result.isSuccess, isTrue, reason: 'Ожидался успех: $result');
    return result.value;
  }

  test('нет счетов — Net Worth равен нулю', () async {
    expect(await netWorth(), 0);
  });

  test('обычные счета складываются', () async {
    repo.accounts['a'] = makeAccount(id: 'a', balance: 100000);
    repo.accounts['b'] =
        makeAccount(id: 'b', type: AccountTypes.cash, balance: 50000);
    repo.accounts['c'] =
        makeAccount(id: 'c', type: AccountTypes.savings, balance: 200000);

    expect(await netWorth(), 350000);
  });

  test('ипотека учитывается как капитал: стоимость минус остаток долга',
      () async {
    repo.accounts['a'] = makeAccount(id: 'a', balance: 100000);
    repo.accounts['m'] = makeAccount(
      id: 'm',
      type: AccountTypes.mortgage,
      balance: 300000000,
    );
    repo.mortgages['m'] =
        makeMortgage(accountId: 'm', propertyValue: 800000000);

    // 100000 + (800000000 - 300000000)
    expect(await netWorth(), 500100000);
  });

  test('ипотека без записи mortgages не влияет на Net Worth', () async {
    repo.accounts['a'] = makeAccount(id: 'a', balance: 100000);
    repo.accounts['m'] = makeAccount(
      id: 'm',
      type: AccountTypes.mortgage,
      balance: 300000000,
    );

    expect(await netWorth(), 100000);
  });

  test('кредит (loan) вычитается из Net Worth', () async {
    repo.accounts['a'] = makeAccount(id: 'a', balance: 100000);
    repo.accounts['l'] = makeAccount(id: 'l', type: 'loan', balance: 500000);

    expect(await netWorth(), -400000);
  });

  test('кредитка с отрицательным балансом уменьшает Net Worth', () async {
    repo.accounts['a'] = makeAccount(id: 'a', balance: 100000);
    repo.accounts['c'] = makeAccount(
      id: 'c',
      type: AccountTypes.credit,
      balance: -200000,
    );

    expect(await netWorth(), -100000);
  });

  test('текущее поведение: архивные и системные счета тоже считаются',
      () async {
    repo.accounts['arch'] =
        makeAccount(id: 'arch', balance: 50000, isArchived: true);
    repo.accounts['sys'] =
        makeAccount(id: 'sys', balance: 30000, isSystem: true);

    expect(await netWorth(), 80000);
  });

  test('чужие счета не попадают в расчёт', () async {
    repo.accounts['mine'] = makeAccount(id: 'mine', balance: 100000);
    repo.accounts['other'] =
        makeAccount(id: 'other', userId: 'u2', balance: 999999);

    expect(await netWorth(), 100000);
  });

  test('ошибка репозитория возвращается как FailureResult', () async {
    repo.error = Exception('db down');

    final result = await useCase.execute('u1');

    expect(result.isFailure, isTrue);
    expect(result, isA<FailureResult<int>>());
  });

  group('Mortgage.calculateNetWorthContribution', () {
    test('положительный капитал', () {
      final m = makeMortgage(accountId: 'm', propertyValue: 800000000);
      expect(m.calculateNetWorthContribution(300000000), 500000000);
    });

    test('отрицательный капитал, когда долг больше стоимости', () {
      final m = makeMortgage(accountId: 'm', propertyValue: 300000000);
      expect(m.calculateNetWorthContribution(500000000), -200000000);
    });
  });
}