import 'package:logger/logger.dart';

import '../../../../core/errors/failures.dart';
import '../../../../core/errors/result.dart';
import '../repositories/transactions_log_repository.dart';

class RestoreTransactionUseCase {
  RestoreTransactionUseCase(this._repository);

  final TransactionsLogRepository _repository;
  final Logger _log = Logger();

  Future<Result<void>> call(String transactionId) async {
    try {
      await _repository.restoreFromIgnored(transactionId);
      return const Success(null);
    } catch (e, s) {
      _log.e('Restore transaction failed: $e', error: e, stackTrace: s);
      return Error(Failure.unexpected('Не удалось вернуть в учёт: $e', s));
    }
  }
}
