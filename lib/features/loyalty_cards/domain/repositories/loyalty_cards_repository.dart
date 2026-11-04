import '../entities/loyalty_card.dart';
import '../entities/loyalty_card_form_draft.dart';

/// Репозиторий скидочных карт.
///
/// Синхронизация с Supabase — Этап 25 (серверных таблиц пока нет,
/// прецедент savings_goals): записи живут с sync_status='pending'.
abstract interface class LoyaltyCardsRepository {
  Stream<List<LoyaltyCard>> watchCards({
    required String userId,
    String? spaceId,
    required LoyaltyCardsScope scope,
    LoyaltyCardCategoryFilter categoryFilter = LoyaltyCardCategoryFilter.all,
    bool onlyFavorite = false,
    String searchQuery = '',
  });

  Future<LoyaltyCardsStats> stats({required String userId, String? spaceId});

  Future<LoyaltyCard?> getById(String cardId);

  Future<void> insert(LoyaltyCard card);
  Future<void> update(LoyaltyCard card);
  Future<void> delete(String cardId);

  Future<void> updateSortOrder(String cardId, int sortOrder);
  Future<void> setFavorite(String cardId, bool isFavorite);
  Future<void> setShared(String cardId, bool isShared);
  Future<void> setPreferredOrientation(String cardId, String? orientation);

  Future<LoyaltyCardFormDraft?> getFreshDraft(String userId);
  Future<void> saveDraft(String userId, LoyaltyCardFormDraft draft);
  Future<void> deleteDraftByUser(String userId);
}