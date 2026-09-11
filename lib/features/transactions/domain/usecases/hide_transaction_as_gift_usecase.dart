import 'package:logger/logger.dart';

import '../../../../core/errors/result.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/transactions_log_repository.dart';

class HideTransactionAsGiftUseCase {
  HideTransactionAsGiftUseCase(this._repository);

  final TransactionsLogRepository _repository;
  final Logger _log = Logger();

  Future<Result<void>> call(String transactionId) async {
    try {
      await _repository.hideAsGift(transactionId);
      return const Success(null);
    } catch (e, s) {
      _log.e('Failed to hide transaction as gift', error: e, stackTrace: s);
      return Error(
        Failure.unexpected('Не удалось засекретить транзакцию: $e', s),
      );
    }
  }
}
