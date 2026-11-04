import 'package:budget_assistant/core/errors/failures.dart';
import 'package:budget_assistant/core/errors/result.dart';
import 'package:logger/logger.dart';
import '../entities/loyalty_card.dart';
import '../repositories/loyalty_cards_repository.dart';

/// Чтение одной карты (экраны редактирования и показа кассиру).
class GetLoyaltyCardByIdUseCase {
  GetLoyaltyCardByIdUseCase({
    required LoyaltyCardsRepository repo,
    required Logger logger,
  })  : _repo = repo,
        _logger = logger;

  final LoyaltyCardsRepository _repo;
  final Logger _logger;

  Future<Result<LoyaltyCard?>> call(String cardId) async {
    try {
      return Success<LoyaltyCard?>(await _repo.getById(cardId));
    } catch (e, st) {
      _logger.e('GetLoyaltyCardById failed', error: e, stackTrace: st);
      return Error<LoyaltyCard?>(Failure.database('Не удалось загрузить карту: $e'));
    }
  }
}