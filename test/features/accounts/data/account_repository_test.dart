import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
// Drift генерирует свой класс Account для таблицы accounts — скрываем его,
// чтобы имя Account означало доменную сущность.
import 'package:budget_assistant/core/database/app_database.dart' hide Account;
import 'package:budget_assistant/features/accounts/data/datasources/account_dao.dart';
import 'package:budget_assistant/features/accounts/data/datasources/mortgage_dao.dart';
import 'package:budget_assistant/features/accounts/data/models/account_model.dart';
import 'package:budget_assistant/features/accounts/data/models/mortgage_model.dart';
import 'package:budget_assistant/features/accounts/data/repositories/account_repository_impl.dart';
import 'package:budget_assistant/features/accounts/domain/entities/account.dart';
import 'package:budget_assistant/features/accounts/domain/entities/account_types.dart';
import '../../../helpers/sqlite_probe.dart';
import '../../../helpers/test_db.dart';

/// Этап 24: репозиторий счетов на реальной БД (Drift in-memory).
void main() {
  final skip = sqliteSkipReason();

  group('AccountRepositoryImpl (in-memory)', () {
    late AppDatabase db;
    late AccountDao accountDao;
    late MortgageDao mortgageDao;
    late AccountRepositoryImpl repo;
    late TestSeed seed;
    final now = DateTime.utc(2026, 7, 15, 12);

    setUp(() async {
      db = openTestDb();
      accountDao = AccountDao(db);
      mortgageDao = MortgageDao(db);
      seed = TestSeed(db);
      await seed.user(kUserId);
      repo = AccountRepositoryImpl(
        accountDao: accountDao,
        mortgageDao: mortgageDao,
        logger: Logger(level: Level.off),
        uuid: const Uuid(),
      );
    });

    tearDown(() async {
      await db.close();
    });

    AccountModel model({
      required String id,
      String type = AccountTypes.debit,
      int balance = 0,
      int? sortOrder,
      bool isSystem = false,
      String syncStatus = 'pending',
    }) =>
        AccountModel(
          id: id,
          userId: kUserId,
          bankName: 'Т-Банк',
          customName: 'Счёт $id',
          accountType: type,
          currency: 'RUB',
          currentBalance: balance,
          sortOrder: sortOrder,
          isSystem: isSystem,
          createdAt: now,
          updatedAt: now,
          syncStatus: syncStatus,
        );

    test('вставка и чтение счёта сохраняют копейки и поля', () async {
      await accountDao.insertAccount(model(id: 'a', balance: 123456));

      final accounts = await repo.getAccountsByUserId(kUserId);

      expect(accounts.length, 1);
      expect(accounts.single.id, 'a');
      expect(accounts.single.currentBalance, 123456);
      expect(accounts.single.currency, 'RUB');
      expect(accounts.single.customName, 'Счёт a');
    });

    test('ensureLocalUser идемпотентен и снимает FK-ошибку', () async {
      await repo.ensureLocalUser('new-user', email: 'a@b.ru');
      await repo.ensureLocalUser('new-user', email: 'a@b.ru');

      final users = await db.select(db.users).get();
      expect(users.where((u) => u.id == 'new-user').length, 1);

      await accountDao.insertAccount(
        AccountModel(
          id: 'x',
          userId: 'new-user',
          bankName: 'Банк',
          customName: 'Счёт',
          accountType: AccountTypes.cash,
          currency: 'RUB',
          currentBalance: 0,
          createdAt: now,
          updatedAt: now,
        ),
      );

      expect((await repo.getAccountsByUserId('new-user')).length, 1);
    });

    test('правка счёта возвращает запись в очередь синка (pending)', () async {
      await accountDao.insertAccount(
        model(id: 'a', balance: 100000, syncStatus: 'synced'),
      );

      final result = await repo.updateAccount(
        accountId: 'a',
        bankName: 'Сбер',
        customName: 'Новый',
        accountType: AccountTypes.credit,
        currency: 'RUB',
        currentBalance: 250000,
        cardNumberMask: '*9999',
        creditLimit: 10000000,
      );

      expect(result.isSuccess, isTrue);
      final row = await (db.select(db.accounts)
            ..where((t) => t.id.equals('a')))
          .getSingle();
      expect(row.currentBalance, 250000);
      expect(row.accountType, AccountTypes.credit);
      expect(row.cardNumberMask, '*9999');
      expect(row.creditLimit, 10000000);
      expect(row.syncStatus, 'pending');
    });

    test('сортировка влияет на порядок в watchAccountsByUserId', () async {
      await accountDao.insertAccount(model(id: 'a', sortOrder: 2));
      await accountDao.insertAccount(model(id: 'b', sortOrder: 0));
      await accountDao.insertAccount(model(id: 'c', sortOrder: 1));

      final first = await accountDao.watchAccountsByUserId(kUserId).first;
      expect(first.map((a) => a.id).toList(), ['b', 'c', 'a']);

      await repo.updateAccountSortOrder('a', -1);

      final next = await accountDao.watchAccountsByUserId(kUserId).first;
      expect(next.map((a) => a.id).toList(), ['a', 'b', 'c']);
    });

    test('удаление счёта каскадно удаляет ипотеку', () async {
      await accountDao.insertAccount(
        model(id: 'm', type: AccountTypes.mortgage, balance: 300000000),
      );
      await mortgageDao.insertMortgage(
        MortgageModel(
          id: 'mort',
          accountId: 'm',
          initialLoanAmount: 500000000,
          propertyValue: 800000000,
          interestRateBps: 1200,
          remainingTermMonths: 120,
          monthlyPayment: 5000000,
          createdAt: now,
          updatedAt: now,
        ),
      );

      await repo.deleteAccount('m');

      expect(await db.select(db.accounts).get(), isEmpty);
      expect(await db.select(db.mortgages).get(), isEmpty);
    });

    test('ипотека читается по счёту и сохраняет копейки', () async {
      await accountDao.insertAccount(
        model(id: 'm', type: AccountTypes.mortgage, balance: 300000000),
      );
      await mortgageDao.insertMortgage(
        MortgageModel(
          id: 'mort',
          accountId: 'm',
          initialLoanAmount: 500000000,
          propertyValue: 800000000,
          interestRateBps: 1200,
          remainingTermMonths: 120,
          monthlyPayment: 5000000,
          createdAt: now,
          updatedAt: now,
        ),
      );

      final mortgage = await repo.getMortgageByAccountId('m');

      expect(mortgage, isNotNull);
      expect(mortgage!.propertyValue, 800000000);
      expect(mortgage.interestRateBps, 1200);
      expect(mortgage.calculateNetWorthContribution(300000000), 500000000);
    });

    test('системный счёт находится только по флагу isSystem', () async {
      await accountDao.insertAccount(model(id: 'plain', type: AccountTypes.safe));
      await accountDao.insertAccount(
        model(id: 'sys', type: AccountTypes.safe, isSystem: true),
      );

      final found = await repo.getSystemAccountByType(AccountTypes.safe);

      expect(found?.id, 'sys');
      expect(await repo.getSystemAccountByType(AccountTypes.credit), isNull);
    });

    test('Account <-> AccountModel сохраняет все поля', () {
      final original = Account(
        id: 'a',
        userId: kUserId,
        spaceId: null,
        bankName: 'Т-Банк',
        customName: 'Black',
        cardNumberMask: '*1234',
        accountType: AccountTypes.credit,
        currency: 'USD',
        currentBalance: 123456,
        creditLimit: 5000000,
        minPaymentAmount: 300000,
        includeInFamilyBalance: true,
        isSharedBalance: true,
        sortOrder: 7,
        createdAt: now,
        updatedAt: now,
      );

      final restored = Account.fromModel(original.toModel());

      expect(restored.id, original.id);
      expect(restored.currentBalance, original.currentBalance);
      expect(restored.creditLimit, original.creditLimit);
      expect(restored.minPaymentAmount, original.minPaymentAmount);
      expect(restored.cardNumberMask, original.cardNumberMask);
      expect(restored.currency, original.currency);
      expect(restored.includeInFamilyBalance, isTrue);
      expect(restored.isSharedBalance, isTrue);
      expect(restored.sortOrder, 7);
      expect(restored.syncStatus, 'pending');
    });
  }, skip: skip);
}