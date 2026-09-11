import 'package:logger/logger.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/errors/result.dart';
import '../repositories/transactions_log_repository.dart';

class UnhideTransactionAsGiftUseCase {
  UnhideTransactionAsGiftUseCase(this._repository);

  final TransactionsLogRepository _repository;
  final Logger _log = Logger();

  Future<Result<void>> call(String transactionId) async {
    try {
      await _repository.unhideAsGift(transactionId);
      return const Success(null);
    } catch (e, s) {
      _log.e('Unhide gift failed: $e', error: e, stackTrace: s);
      return Error(Failure.unexpected('Не удалось отменить подарок: $e', s));
    }
  }
}
