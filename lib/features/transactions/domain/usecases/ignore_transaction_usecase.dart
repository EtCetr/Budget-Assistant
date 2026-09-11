import 'package:logger/logger.dart';

import '../../../../core/errors/result.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/transactions_log_repository.dart';

class IgnoreTransactionUseCase {
  IgnoreTransactionUseCase(this._repository);

  final TransactionsLogRepository _repository;
  final Logger _log = Logger();

  Future<Result<void>> call(String transactionId) async {
    try {
      await _repository.ignore(transactionId);
      return const Success(null);
    } catch (e, s) {
      _log.e('Failed to ignore transaction', error: e, stackTrace: s);
      return Error(
        Failure.unexpected('Не удалось исключить транзакцию из учёта: $e', s),
      );
    }
  }
}
