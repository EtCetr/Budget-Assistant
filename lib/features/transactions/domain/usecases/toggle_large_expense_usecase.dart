import 'package:logger/logger.dart';

import 'package:budget_assistant/core/errors/failures.dart';
import 'package:budget_assistant/core/errors/result.dart';
import '../repositories/transactions_log_repository.dart';

/// Переключает флаг "Крупная трата" на конкретной транзакции.
/// Используется из long-press меню в TransactionsLogScreen.
class ToggleLargeExpenseUseCase {
  ToggleLargeExpenseUseCase(this._repository);

  final TransactionsLogRepository _repository;
  final Logger _log = Logger();

  Future<Result<void>> call(String transactionId) async {
    try {
      await _repository.toggleLargeExpense(transactionId);
      return const Success(null);
    } catch (e, s) {
      _log.e('ToggleLargeExpenseUseCase failed', error: e, stackTrace: s);
      return Error(Failure.database('Не удалось изменить флаг: $e'));
    }
  }
}
