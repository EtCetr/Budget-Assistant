// lib/features/accounts/domain/usecases/create_account_usecase.dart
import 'package:budget_assistant/core/errors/failures.dart';
import 'package:budget_assistant/core/utils/result.dart';
import '../entities/account.dart';
import '../repositories/account_repository.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

class CreateAccountUseCase {
  final AccountRepository _repository;
  final Logger _logger;
  final Uuid _uuid;

  CreateAccountUseCase({
    required AccountRepository repository,
    required Logger logger,
    required Uuid uuid,
  }) : _repository = repository,
       _logger = logger,
       _uuid = uuid;

  Future<Result<Account>> execute({
    required String userId,
    required String bankName,
    required String customName,
    required String accountType,
    required String currency,
    required int currentBalance,
    String? spaceId,
    String? cardNumberMask,
    int? creditLimit,
    DateTime? gracePeriodEnd,
    int? minPaymentAmount,
  }) async {
    try {
      // ✅ ГАРАНТИЯ: локальный профиль существует до INSERT в accounts (FK)
      await _repository.ensureLocalUser(userId);

      final now = DateTime.now().toUtc();

      final account = Account(
        id: _uuid.v4(),
        userId: userId,
        spaceId: spaceId,
        bankName: bankName,
        customName: customName,
        cardNumberMask: cardNumberMask,
        accountType: accountType,
        currency: currency,
        currentBalance: currentBalance,
        creditLimit: creditLimit,
        gracePeriodEnd: gracePeriodEnd,
        minPaymentAmount: minPaymentAmount,
        createdAt: now,
        updatedAt: now,
        syncStatus: 'pending',
      );

      await _repository.insertAccount(account);
      _logger.i('Account created: ${account.id}');

      return Result.success(account);
    } catch (e, stackTrace) {
      _logger.e(
        'CreateAccountUseCase failed',
        error: e,
        stackTrace: stackTrace,
      );
      return Result.failure(Failure.database(e.toString(), stackTrace));
    }
  }
}
