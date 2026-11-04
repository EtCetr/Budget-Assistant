import 'package:budget_assistant/core/errors/failures.dart';
import 'package:budget_assistant/core/errors/result.dart';
import 'package:logger/logger.dart';
import '../repositories/loyalty_cards_repository.dart';

/// Сохранение ориентации экрана per-card (ТЗ 6.3.21.13.8).
/// preferred_orientation — [LOCAL]: sync_status НЕ трогаем.
class UpdateLoyaltyCardPreferredOrientationUseCase {
  UpdateLoyaltyCardPreferredOrientationUseCase({
    required LoyaltyCardsRepository repo,
    required Logger logger,
  })  : _repo = repo,
        _logger = logger;

  final LoyaltyCardsRepository _repo;
  final Logger _logger;

  /// [orientation] — 'portrait' | 'landscape' | null (сброс).
  Future<Result<bool>> call({
    required String cardId,
    required String? orientation,
  }) async {
    if (orientation != null &&
        orientation != 'portrait' &&
        orientation != 'landscape') {
      return const Error<bool>(Failure.validation('Неизвестная ориентация экрана'));
    }
    try {
      await _repo.setPreferredOrientation(cardId, orientation);
      return const Success<bool>(true);
    } catch (e, st) {
      _logger.e('UpdatePreferredOrientation failed', error: e, stackTrace: st);
      return Error<bool>(Failure.database('Не удалось сохранить ориентацию: $e'));
    }
  }
}