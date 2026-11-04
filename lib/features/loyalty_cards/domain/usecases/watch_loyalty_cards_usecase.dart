import 'package:logger/logger.dart';
import '../entities/loyalty_card.dart';
import '../repositories/loyalty_cards_repository.dart';

/// Комбинированный watch списка карт: scope + категория + избранное + поиск.
///
/// D20-2: спековые FilterLoyaltyCardsByScopeUseCase /
/// FilterLoyaltyCardsByCategoryUseCase / SearchLoyaltyCardsUseCase
/// (ТЗ 6.3.19.14.6 a-c) объединены в один UseCase: все фильтры уходят
/// в SQL WHERE одним запросом (DECISIONS: фильтры только в SQL),
/// прецедент — savings_goals watchActive.
class WatchLoyaltyCardsUseCase {
  WatchLoyaltyCardsUseCase({
    required LoyaltyCardsRepository repo,
    required Logger logger,
  })  : _repo = repo,
        _logger = logger;

  final LoyaltyCardsRepository _repo;
  final Logger _logger;

  Stream<List<LoyaltyCard>> call({
    required String userId,
    String? spaceId,
    required LoyaltyCardsScope scope,
    LoyaltyCardCategoryFilter categoryFilter = LoyaltyCardCategoryFilter.all,
    bool onlyFavorite = false,
    String searchQuery = '',
  }) {
    try {
      return _repo.watchCards(
        userId: userId,
        spaceId: spaceId,
        scope: scope,
        categoryFilter: categoryFilter,
        onlyFavorite: onlyFavorite,
        searchQuery: searchQuery,
      );
    } catch (e, st) {
      _logger.e('WatchLoyaltyCards failed', error: e, stackTrace: st);
      rethrow;
    }
  }
}