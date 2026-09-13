import 'package:logger/logger.dart';
import 'package:budget_assistant/core/errors/failures.dart';
import 'package:budget_assistant/core/errors/result.dart';
import '../repositories/spaces_repository.dart';

/// Подключает личные транзакции пользователя (space_id IS NULL)
/// к активной группе (вариант A для empty-state сегмента «Семейные»).
class AttachPersonalTransactionsUseCase {
  const AttachPersonalTransactionsUseCase({
    required SpacesRepository repository,
    required Logger logger,
  })  : _repository = repository,
        _logger = logger;

  final SpacesRepository _repository;
  final Logger _logger;

  /// Возвращает количество подключённых транзакций.
  Future<Result<int>> call({
    required String userId,
    required String spaceId,
  }) async {
    try {
      final count = await _repository.attachPersonalTransactionsToSpace(
        userId: userId,
        spaceId: spaceId,
      );
      return Success(count);
    } catch (e, st) {
      _logger.e(
        'AttachPersonalTransactionsUseCase failed',
        error: e,
        stackTrace: st,
      );
      return Error(Failure.database(e.toString()));
    }
  }
}