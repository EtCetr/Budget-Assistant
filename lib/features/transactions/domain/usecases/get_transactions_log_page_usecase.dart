import 'package:logger/logger.dart';

import '../../../../core/errors/result.dart';
import '../../../../core/errors/failures.dart';
import '../entities/transaction_day_group.dart';
import '../entities/transactions_filter_state.dart';
import '../repositories/transactions_log_repository.dart';

class GetTransactionsLogPageUseCase {
  GetTransactionsLogPageUseCase(this._repository);

  final TransactionsLogRepository _repository;
  final Logger _log = Logger();

  Future<Result<TransactionPageUi>> call({
    required TransactionsFilterState filter,
    required String currentUserId,
    required String? currentSpaceId,
    required int page,
    int pageSize = 50,
  }) async {
    try {
      final items = await _repository.fetchPage(
        filter: filter,
        currentUserId: currentUserId,
        currentSpaceId: currentSpaceId,
        limit: pageSize,
        offset: page * pageSize,
      );

      return Success(
        TransactionPageUi(items: items, hasMore: items.length == pageSize),
      );
    } catch (e, s) {
      _log.e('Failed to load transactions page', error: e, stackTrace: s);
      return Error(
        Failure.unexpected('Не удалось загрузить транзакции: $e', s),
      );
    }
  }
}
