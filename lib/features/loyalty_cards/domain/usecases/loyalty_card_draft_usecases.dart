import 'package:budget_assistant/core/errors/failures.dart';
import 'package:budget_assistant/core/errors/result.dart';
import 'package:logger/logger.dart';
import '../entities/loyalty_card_form_draft.dart';
import '../repositories/loyalty_cards_repository.dart';

/// Автосейв черновика формы каждые 5 сек (ТЗ 6.3.20.13).
class SaveLoyaltyCardDraftUseCase {
  SaveLoyaltyCardDraftUseCase({
    required LoyaltyCardsRepository repo,
    required Logger logger,
  })  : _repo = repo,
        _logger = logger;

  final LoyaltyCardsRepository _repo;
  final Logger _logger;

  Future<Result<bool>> call({
    required String userId,
    required LoyaltyCardFormDraft draft,
  }) async {
    try {
      await _repo.saveDraft(userId, draft);
      return const Success<bool>(true);
    } catch (e, st) {
      _logger.e('SaveLoyaltyCardDraft failed', error: e, stackTrace: st);
      return Error<bool>(Failure.database('Не удалось сохранить черновик: $e'));
    }
  }
}

/// Восстановление черновика моложе 24 часов (иначе Success(null)).
class RestoreLoyaltyCardDraftUseCase {
  RestoreLoyaltyCardDraftUseCase({
    required LoyaltyCardsRepository repo,
    required Logger logger,
  })  : _repo = repo,
        _logger = logger;

  final LoyaltyCardsRepository _repo;
  final Logger _logger;

  Future<Result<LoyaltyCardFormDraft?>> call(String userId) async {
    try {
      return Success<LoyaltyCardFormDraft?>(await _repo.getFreshDraft(userId));
    } catch (e, st) {
      _logger.e('RestoreLoyaltyCardDraft failed', error: e, stackTrace: st);
      return Error<LoyaltyCardFormDraft?>(
          Failure.database('Не удалось прочитать черновик: $e'));
    }
  }
}

/// Удаление черновика после успешного сохранения карты.
class ClearLoyaltyCardDraftUseCase {
  ClearLoyaltyCardDraftUseCase({
    required LoyaltyCardsRepository repo,
    required Logger logger,
  })  : _repo = repo,
        _logger = logger;

  final LoyaltyCardsRepository _repo;
  final Logger _logger;

  Future<Result<bool>> call(String userId) async {
    try {
      await _repo.deleteDraftByUser(userId);
      return const Success<bool>(true);
    } catch (e, st) {
      _logger.e('ClearLoyaltyCardDraft failed', error: e, stackTrace: st);
      return Error<bool>(Failure.database('Не удалось удалить черновик: $e'));
    }
  }
}