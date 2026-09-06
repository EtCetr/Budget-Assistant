// lib/features/accounts/data/repositories/account_repository_impl.dart
import '../../domain/entities/account.dart';
import '../../domain/entities/mortgage.dart';
import '../../domain/repositories/account_repository.dart';
import '../datasources/account_dao.dart';
import '../datasources/mortgage_dao.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

class AccountRepositoryImpl implements AccountRepository {
  final AccountDao _accountDao;
  final MortgageDao _mortgageDao;
  final Logger _logger;
  final Uuid _uuid;

  AccountRepositoryImpl({
    required AccountDao accountDao,
    required MortgageDao mortgageDao,
    required Logger logger,
    required Uuid uuid,
  }) : _accountDao = accountDao,
       _mortgageDao = mortgageDao,
       _logger = logger,
       _uuid = uuid;

  @override
  Future<List<Account>> getAccountsByUserId(String userId) async {
    try {
      final models = await _accountDao.getAccountsByUserId(userId);
      return models.map((m) => Account.fromModel(m)).toList();
    } catch (e, stackTrace) {
      _logger.e(
        'AccountRepository.getAccountsByUserId',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<void> insertAccount(Account account) async {
    try {
      final model = account.toModel();
      await _accountDao.insertAccount(model);
    } catch (e, stackTrace) {
      _logger.e(
        'AccountRepository.insertAccount',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<void> updateAccountSortOrder(String accountId, int? sortOrder) async {
    try {
      await _accountDao.updateAccountSortOrder(accountId, sortOrder);
    } catch (e, stackTrace) {
      _logger.e(
        'AccountRepository.updateAccountSortOrder',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<Account?> getSystemAccountByType(String accountType) async {
    try {
      final model = await _accountDao.getSystemAccountByType(accountType);
      return model != null ? Account.fromModel(model) : null;
    } catch (e, stackTrace) {
      _logger.e(
        'AccountRepository.getSystemAccountByType',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<Account> getOrCreateSystemAccount(String accountType) async {
    try {
      var account = await getSystemAccountByType(accountType);

      if (account == null) {
        account = Account(
          id: _uuid.v4(),
          userId: '', // Will be set by UseCase
          bankName: 'System',
          customName: 'Virtual Envelope',
          accountType: accountType,
          currency: 'RUB',
          currentBalance: 0,
          isSystem: true,
          createdAt: DateTime.now().toUtc(),
          updatedAt: DateTime.now().toUtc(),
          syncStatus: 'pending',
        );

        await insertAccount(account);
      }

      return account;
    } catch (e, stackTrace) {
      _logger.e(
        'AccountRepository.getOrCreateSystemAccount',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<Mortgage?> getMortgageByAccountId(String accountId) async {
    try {
      final model = await _mortgageDao.getMortgageByAccountId(accountId);
      return model != null ? Mortgage.fromModel(model) : null;
    } catch (e, stackTrace) {
      _logger.e(
        'AccountRepository.getMortgageByAccountId',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<void> insertMortgage(Mortgage mortgage) async {
    try {
      final model = mortgage.toModel();
      await _mortgageDao.insertMortgage(model);
    } catch (e, stackTrace) {
      _logger.e(
        'AccountRepository.insertMortgage',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<void> ensureLocalUser(String userId, {String email = ''}) async {
    try {
      await _accountDao.ensureLocalUser(userId, email: email);
    } catch (e, stackTrace) {
      _logger.e(
        'AccountRepository.ensureLocalUser',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }

    @override
  Future<void> deleteAccount(String accountId) async {
    try {
      await _accountDao.deleteAccount(accountId);
    } catch (e, stackTrace) {
      _logger.e(
        'AccountRepository.deleteAccount',
        error: e,
        stackTrace: stackTrace,
      );
      rethrow;
    }
  }
}
