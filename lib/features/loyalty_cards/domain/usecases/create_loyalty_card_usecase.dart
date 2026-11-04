import 'package:budget_assistant/core/errors/failures.dart';
import 'package:budget_assistant/core/errors/result.dart';
import 'package:logger/logger.dart';
import '../entities/loyalty_card.dart';
import '../repositories/loyalty_cards_repository.dart';

/// Создание карты. Запись уходит в БД с sync_status='pending' (Offline-First);
/// E2E AES-256-GCM применяется только к sync-пейлоаду (Этап 25).
class CreateLoyaltyCardUseCase {
  CreateLoyaltyCardUseCase({
    required LoyaltyCardsRepository repo,
    required Logger logger,
  })  : _repo = repo,
        _logger = logger;

  final LoyaltyCardsRepository _repo;
  final Logger _logger;

  Future<Result<LoyaltyCard>> call(LoyaltyCard card) async {
    try {
      await _repo.insert(card);
      return Success<LoyaltyCard>(card);
    } catch (e, st) {
      _logger.e('CreateLoyaltyCard failed', error: e, stackTrace: st);
      return Error<LoyaltyCard>(Failure.database('Не удалось сохранить карту: $e'));
    }
  }
}