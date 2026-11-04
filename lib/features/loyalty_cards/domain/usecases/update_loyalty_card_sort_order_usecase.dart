import 'package:budget_assistant/core/errors/failures.dart';
import 'package:budget_assistant/core/errors/result.dart';
import 'package:logger/logger.dart';
import '../repositories/loyalty_cards_repository.dart';

/// Локальная сортировка drag-and-drop (ТЗ 6.3.19.7).
/// sort_order — [LOCAL]: sync_status НЕ трогаем, в sync-пейлоад поле
/// не попадает (Этап 25), race conditions между членами семьи исключены.
class UpdateLoyaltyCardSortOrderUseCase {
  UpdateLoyaltyCardSortOrderUseCase({
    required LoyaltyCardsRepository repo,
    required Logger logger,
  })  : _repo = repo,
        _logger = logger;

  final LoyaltyCardsRepository _repo;
  final Logger _logger;

  /// [orderedCardIds] — ids в новом порядке (индекс = sort_order).
  Future<Result<bool>> call({required List<String> orderedCardIds}) async {
    try {
      for (var i = 0; i < orderedCardIds.length; i++) {
        await _repo.updateSortOrder(orderedCardIds[i], i);
      }
      return const Success<bool>(true);
    } catch (e, st) {
      _logger.e('UpdateLoyaltyCardSortOrder failed', error: e, stackTrace: st);
      return Error<bool>(Failure.database('Не удалось сохранить порядок: $e'));
    }
  }
}