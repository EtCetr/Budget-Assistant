import 'package:logger/logger.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';

import '../../../../core/errors/result.dart';
import '../../../../core/errors/failures.dart';
import '../entities/transaction_ui_model.dart';
import '../repositories/transactions_log_repository.dart';

class MarkAsRefundUseCase {
  MarkAsRefundUseCase(this._repository);

  final TransactionsLogRepository _repository;
  final Logger _log = Logger();

  Future<Result<void>> call(TransactionUiModel original) async {
    try {
      if (original.type != TransactionType.expense) {
        return const Error(
          Failure.validation(
            'Компенсирующую операцию можно создавать только для расходов',
          ),
        );
      }

      await _repository.createCompensatingIncome(original.id);
      return const Success(null);
    } catch (e, s) {
      _log.e('Failed to create compensating income', error: e, stackTrace: s);
      return Error(
        Failure.unexpected('Не удалось создать компенсирующую операцию: $e', s),
      );
    }
  }
}
