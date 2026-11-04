import 'package:logger/logger.dart';
import '../entities/loyalty_card.dart';
import '../repositories/loyalty_cards_repository.dart';

/// Сводка экрана карт: всего / избранных / семейных (ТЗ 6.3.19.6).
class GetLoyaltyCardsStatsUseCase {
  GetLoyaltyCardsStatsUseCase({
    required LoyaltyCardsRepository repo,
    required Logger logger,
  })  : _repo = repo,
        _logger = logger;

  final LoyaltyCardsRepository _repo;
  final Logger _logger;

  Future<LoyaltyCardsStats> call({
    required String userId,
    String? spaceId,
  }) async {
    try {
      return await _repo.stats(userId: userId, spaceId: spaceId);
    } catch (e, st) {
      _logger.e('GetLoyaltyCardsStats failed', error: e, stackTrace: st);
      rethrow;
    }
  }
}