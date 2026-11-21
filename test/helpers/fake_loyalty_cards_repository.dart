import 'package:budget_assistant/core/enums/transaction_enums.dart';
import 'package:budget_assistant/features/loyalty_cards/domain/entities/loyalty_card.dart';
import 'package:budget_assistant/features/loyalty_cards/domain/entities/loyalty_card_form_draft.dart';
import 'package:budget_assistant/features/loyalty_cards/domain/repositories/loyalty_cards_repository.dart';

/// Этап 24: заглушка репозитория карт лояльности.
/// Фильтрация списка в SQL — здесь только делегирование и запись вызовов.
class FakeLoyaltyCardsRepository implements LoyaltyCardsRepository {
  final Map<String, LoyaltyCard> cards = <String, LoyaltyCard>{};
  LoyaltyCardFormDraft? draft;
  LoyaltyCardsStats statsResult =
      const LoyaltyCardsStats(total: 0, favorites: 0, family: 0);

  Object? error;
  final List<String> calls = <String>[];
  final List<({String id, int order})> sortUpdates =
      <({String id, int order})>[];
  final List<({String id, bool value})> favoriteUpdates =
      <({String id, bool value})>[];
  final List<({String id, bool value})> sharedUpdates =
      <({String id, bool value})>[];
  final List<({String id, String? orientation})> orientationUpdates =
      <({String id, String? orientation})>[];

  String? lastUserId;
  String? lastSpaceId;
  LoyaltyCardsScope? lastScope;
  LoyaltyCardCategoryFilter? lastCategoryFilter;
  bool? lastOnlyFavorite;
  String? lastSearchQuery;

  void _enter(String name) {
    calls.add(name);
    final e = error;
    if (e != null) throw e;
  }

  @override
  Stream<List<LoyaltyCard>> watchCards({
    required String userId,
    String? spaceId,
    required LoyaltyCardsScope scope,
    LoyaltyCardCategoryFilter categoryFilter = LoyaltyCardCategoryFilter.all,
    bool onlyFavorite = false,
    String searchQuery = '',
  }) {
    _enter('watchCards');
    lastUserId = userId;
    lastSpaceId = spaceId;
    lastScope = scope;
    lastCategoryFilter = categoryFilter;
    lastOnlyFavorite = onlyFavorite;
    lastSearchQuery = searchQuery;
    return Stream.value(cards.values.toList());
  }

  @override
  Future<LoyaltyCardsStats> stats({
    required String userId,
    String? spaceId,
  }) async {
    _enter('stats');
    lastUserId = userId;
    lastSpaceId = spaceId;
    return statsResult;
  }

  @override
  Future<LoyaltyCard?> getById(String cardId) async {
    _enter('getById');
    return cards[cardId];
  }

  @override
  Future<void> insert(LoyaltyCard card) async {
    _enter('insert');
    cards[card.id] = card;
  }

  @override
  Future<void> update(LoyaltyCard card) async {
    _enter('update');
    cards[card.id] = card;
  }

  @override
  Future<void> delete(String cardId) async {
    _enter('delete');
    cards.remove(cardId);
  }

  @override
  Future<void> updateSortOrder(String cardId, int sortOrder) async {
    _enter('updateSortOrder');
    sortUpdates.add((id: cardId, order: sortOrder));
    final c = cards[cardId];
    if (c != null) cards[cardId] = c.copyWith(sortOrder: sortOrder);
  }

  @override
  Future<void> setFavorite(String cardId, bool isFavorite) async {
    _enter('setFavorite');
    favoriteUpdates.add((id: cardId, value: isFavorite));
    final c = cards[cardId];
    if (c != null) cards[cardId] = c.copyWith(isFavorite: isFavorite);
  }

  @override
  Future<void> setShared(String cardId, bool isShared) async {
    _enter('setShared');
    sharedUpdates.add((id: cardId, value: isShared));
    final c = cards[cardId];
    if (c != null) cards[cardId] = c.copyWith(isShared: isShared);
  }

  @override
  Future<void> setPreferredOrientation(
    String cardId,
    String? orientation,
  ) async {
    _enter('setPreferredOrientation');
    orientationUpdates.add((id: cardId, orientation: orientation));
    final c = cards[cardId];
    if (c != null) {
      cards[cardId] = c.copyWith(preferredOrientation: orientation);
    }
  }

  @override
  Future<LoyaltyCardFormDraft?> getFreshDraft(String userId) async {
    _enter('getFreshDraft');
    return draft;
  }

  @override
  Future<void> saveDraft(String userId, LoyaltyCardFormDraft formDraft) async {
    _enter('saveDraft');
    draft = formDraft;
  }

  @override
  Future<void> deleteDraftByUser(String userId) async {
    _enter('deleteDraftByUser');
    draft = null;
  }
}

/// Фабрика карты лояльности для тестов.
LoyaltyCard makeCard({
  required String id,
  String userId = 'u1',
  String? spaceId,
  String storeName = 'Пятёрочка',
  String? cardNumber = '12345678',
  BarcodeType barcodeType = BarcodeType.manual,
  String barcodeData = '12345678',
  LoyaltyCardCategory category = LoyaltyCardCategory.grocery,
  bool isFavorite = false,
  bool isShared = true,
  int? sortOrder,
  String? preferredOrientation,
}) =>
    LoyaltyCard(
      id: id,
      userId: userId,
      spaceId: spaceId,
      storeName: storeName,
      cardNumber: cardNumber,
      barcodeType: barcodeType,
      barcodeData: barcodeData,
      category: category,
      isFavorite: isFavorite,
      isShared: isShared,
      sortOrder: sortOrder,
      preferredOrientation: preferredOrientation,
      createdAt: DateTime.utc(2026, 7, 1),
      updatedAt: DateTime.utc(2026, 7, 1),
      syncStatus: SyncStatus.pending,
    );

/// Фабрика черновика формы карты.
LoyaltyCardFormDraft makeCardDraft({
  String? cardId,
  String storeName = 'Пятёрочка',
  String barcodeType = 'manual',
  String barcodeData = '12345678',
  String category = 'grocery',
  String visibility = 'personal',
}) =>
    LoyaltyCardFormDraft(
      cardId: cardId,
      storeName: storeName,
      barcodeType: barcodeType,
      barcodeData: barcodeData,
      category: category,
      visibility: visibility,
      updatedAt: DateTime.utc(2026, 7, 15),
    );