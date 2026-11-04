import 'package:budget_assistant/core/errors/failures.dart';
import 'package:budget_assistant/core/errors/result.dart';
import 'package:logger/logger.dart';
import '../entities/loyalty_card.dart';
import '../repositories/loyalty_cards_repository.dart';

/// Обновление карты. Только создатель (ТЗ 6.3.20.13: семейную карту
/// редактирует только её автор).
class UpdateLoyaltyCardUseCase {
  UpdateLoyaltyCardUseCase({
    required LoyaltyCardsRepository repo,
    required Logger logger,
  })  : _repo = repo,
        _logger = logger;

  final LoyaltyCardsRepository _repo;
  final Logger _logger;

  Future<Result<LoyaltyCard>> call(LoyaltyCard card) async {
    try {
      final existing = await _repo.getById(card.id);
      if (existing == null) {
        return const Error<LoyaltyCard>(Failure.notFound('Карта не найдена'));
      }
      if (existing.userId != card.userId) {
        return const Error<LoyaltyCard>(
            Failure.authorization('Изменить карту может только её создатель'));
      }
      await _repo.update(card);
      return Success<LoyaltyCard>(card);
    } catch (e, st) {
      _logger.e('UpdateLoyaltyCard failed', error: e, stackTrace: st);
      return Error<LoyaltyCard>(Failure.database('Не удалось обновить карту: $e'));
    }
  }
}