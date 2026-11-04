import 'package:budget_assistant/core/errors/failures.dart';
import 'package:budget_assistant/core/errors/result.dart';
import 'package:logger/logger.dart';
import '../repositories/loyalty_cards_repository.dart';

/// Переключение избранного (ТЗ 6.3.19.8): доступно всегда, инвертирует флаг.
class ToggleLoyaltyCardFavoriteUseCase {
  ToggleLoyaltyCardFavoriteUseCase({
    required LoyaltyCardsRepository repo,
    required Logger logger,
  })  : _repo = repo,
        _logger = logger;

  final LoyaltyCardsRepository _repo;
  final Logger _logger;

  Future<Result<bool>> call(String cardId) async {
    try {
      final existing = await _repo.getById(cardId);
      if (existing == null) {
        return const Error<bool>(Failure.notFound('Карта не найдена'));
      }
      await _repo.setFavorite(cardId, !existing.isFavorite);
      return const Success<bool>(true);
    } catch (e, st) {
      _logger.e('ToggleLoyaltyCardFavorite failed', error: e, stackTrace: st);
      return Error<bool>(Failure.database('Не удалось изменить избранное: $e'));
    }
  }
}