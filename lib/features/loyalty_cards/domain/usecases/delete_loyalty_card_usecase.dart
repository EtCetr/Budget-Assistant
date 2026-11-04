import 'package:budget_assistant/core/errors/failures.dart';
import 'package:budget_assistant/core/errors/result.dart';
import 'package:logger/logger.dart';
import '../repositories/loyalty_cards_repository.dart';

/// Удаление карты. Только создатель (ТЗ 6.3.19.8).
class DeleteLoyaltyCardUseCase {
  DeleteLoyaltyCardUseCase({
    required LoyaltyCardsRepository repo,
    required Logger logger,
  })  : _repo = repo,
        _logger = logger;

  final LoyaltyCardsRepository _repo;
  final Logger _logger;

  Future<Result<bool>> call({
    required String cardId,
    required String currentUserId,
  }) async {
    try {
      final existing = await _repo.getById(cardId);
      if (existing == null) {
        return const Error<bool>(Failure.notFound('Карта не найдена'));
      }
      if (existing.userId != currentUserId) {
        return const Error<bool>(
            Failure.authorization('Удалить карту может только её создатель'));
      }
      await _repo.delete(cardId);
      return const Success<bool>(true);
    } catch (e, st) {
      _logger.e('DeleteLoyaltyCard failed', error: e, stackTrace: st);
      return Error<bool>(Failure.database('Не удалось удалить карту: $e'));
    }
  }
}