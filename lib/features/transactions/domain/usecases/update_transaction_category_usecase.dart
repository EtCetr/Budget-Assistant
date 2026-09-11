import 'package:logger/logger.dart';

import '../../../../core/errors/result.dart';
import '../../../../core/errors/failures.dart';
import '../repositories/transactions_log_repository.dart';

class UpdateTransactionCategoryUseCase {
  UpdateTransactionCategoryUseCase(this._repository);

  final TransactionsLogRepository _repository;
  final Logger _log = Logger();

  Future<Result<void>> call({
    required String transactionId,
    required String categoryId,
  }) async {
    try {
      await _repository.updateCategory(
        transactionId: transactionId,
        categoryId: categoryId,
      );
      return const Success(null);
    } catch (e, s) {
      _log.e('Failed to update category', error: e, stackTrace: s);
      return Error(Failure.unexpected('Не удалось изменить категорию: $e', s));
    }
  }
}
