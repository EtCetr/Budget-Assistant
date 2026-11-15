import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/errors/failures.dart';
import 'package:budget_assistant/features/accounts/domain/usecases/delete_account_usecase.dart';
import 'package:budget_assistant/features/accounts/domain/usecases/update_account_sort_order_usecase.dart';
import '../../../helpers/fake_account_repository.dart';

/// Этап 24: удаление счёта и локальная сортировка (sort_order не синкается).
void main() {
  late FakeAccountRepository repo;
  late DeleteAccountUseCase delete;
  late UpdateAccountSortOrderUseCase sort;

  setUp(() {
    repo = FakeAccountRepository();
    repo.accounts['a'] = makeAccount(id: 'a');
    repo.accounts['b'] = makeAccount(id: 'b');
    repo.accounts['c'] = makeAccount(id: 'c');
    final logger = Logger(level: Level.off);
    delete = DeleteAccountUseCase(repository: repo, logger: logger);
    sort = UpdateAccountSortOrderUseCase(repository: repo, logger: logger);
  });

  test('удаление делегируется репозиторию', () async {
    final result = await delete.execute('a');

    expect(result.isSuccess, isTrue);
    expect(repo.calls, contains('deleteAccount'));
    expect(repo.accounts.containsKey('a'), isFalse);
  });

  test('удаление вместе с ипотекой', () async {
    repo.mortgages['a'] = makeMortgage(accountId: 'a');

    await delete.execute('a');

    expect(repo.mortgages.containsKey('a'), isFalse);
  });

  test('ошибка удаления возвращается как DatabaseFailure', () async {
    repo.error = Exception('db down');

    final result = await delete.execute('a');

    expect(result.isFailure, isTrue);
    expect(result.error, isA<DatabaseFailure>());
  });

  test('сортировка одного счёта', () async {
    final result = await sort.execute(accountId: 'b', sortOrder: 5);

    expect(result.isSuccess, isTrue);
    expect(repo.sortUpdates, [(id: 'b', order: 5)]);
  });

  test('сортировку можно сбросить в null', () async {
    await sort.execute(accountId: 'b', sortOrder: null);

    expect(repo.sortUpdates, [(id: 'b', order: null)]);
  });

  test('пакетная сортировка проставляет индексы по порядку списка', () async {
    final result = await sort.executeBatch(orderedAccountIds: ['c', 'a', 'b']);

    expect(result.isSuccess, isTrue);
    expect(repo.sortUpdates, [
      (id: 'c', order: 0),
      (id: 'a', order: 1),
      (id: 'b', order: 2),
    ]);
  });

  test('пустой список — успех без обращений к репозиторию', () async {
    final result = await sort.executeBatch(orderedAccountIds: const []);

    expect(result.isSuccess, isTrue);
    expect(repo.sortUpdates, isEmpty);
  });

  test('ошибка сортировки возвращается как DatabaseFailure', () async {
    repo.error = Exception('db down');

    final result = await sort.execute(accountId: 'a', sortOrder: 1);

    expect(result.isFailure, isTrue);
    expect(result.error, isA<DatabaseFailure>());
  });
}
