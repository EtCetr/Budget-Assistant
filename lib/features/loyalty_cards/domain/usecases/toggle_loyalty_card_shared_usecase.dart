import 'package:budget_assistant/core/errors/failures.dart';
import 'package:budget_assistant/core/errors/result.dart';
import 'package:logger/logger.dart';
import '../repositories/loyalty_cards_repository.dart';

/// Переключение is_shared («Поделиться с семьёй» / «Сделать личной»).
/// Только создатель (ТЗ 6.3.19.8, 6.3.20.13).
class ToggleLoyaltyCardSharedUseCase {
  ToggleLoyaltyCardSharedUseCase({
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
        return const Error<bool>(Failure.authorization(
            'Настройки видимости меняет только создатель карты'));
      }
      await _repo.setShared(cardId, !existing.isShared);
      return const Success<bool>(true);
    } catch (e, st) {
      _logger.e('ToggleLoyaltyCardShared failed', error: e, stackTrace: st);
      return Error<bool>(Failure.database('Не удалось изменить видимость: $e'));
    }
  }
}