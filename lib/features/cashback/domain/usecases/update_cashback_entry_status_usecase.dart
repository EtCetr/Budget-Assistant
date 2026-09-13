import 'package:logger/logger.dart';
import 'package:budget_assistant/core/errors/failures.dart';
import 'package:budget_assistant/core/errors/result.dart';
import '../repositories/cashback_repository.dart';

/// Ручная смена статуса записи матрицы кэшбэка: 'potential' <-> 'approved'.
///
/// До банковской логики (Этапы 17/21) подтверждение ставит пользователь.
class UpdateCashbackEntryStatusUseCase {
  const UpdateCashbackEntryStatusUseCase({
    required CashbackRepository repository,
    required Logger logger,
  })  : _repository = repository,
        _logger = logger;

  final CashbackRepository _repository;
  final Logger _logger;

  Future<Result<void>> call({
    required String entryId,
    required String status,
  }) async {
    if (status != 'potential' && status != 'approved') {
      return Error(Failure.validation('Unknown cashback status: $status'));
    }
    try {
      await _repository.updateEntryStatus(entryId, status);
      return const Success(null);
    } catch (e, st) {
      _logger.e(
        'UpdateCashbackEntryStatusUseCase failed',
        error: e,
        stackTrace: st,
      );
      return Error(Failure.database(e.toString()));
    }
  }
}