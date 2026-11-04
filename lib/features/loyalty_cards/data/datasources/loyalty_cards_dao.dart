import 'package:drift/drift.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/database/tables/loyalty_cards.dart';
import 'package:budget_assistant/core/database/tables/loyalty_card_drafts.dart';
import '../../domain/entities/loyalty_card.dart';

part 'loyalty_cards_dao.g.dart';

@DriftAccessor(tables: [LoyaltyCards, LoyaltyCardDrafts])
class LoyaltyCardsDao extends DatabaseAccessor<AppDatabase>
    with _$LoyaltyCardsDaoMixin {
  LoyaltyCardsDao(super.db);

  /// Список карт: scope + категория + избранное + поиск — всё в SQL (DECISIONS:
  /// фильтры только в WHERE). Сортировка: sort_order (NULL в конце),
  /// затем избранное, затем имя (ТЗ 6.3.19.14.4).
  Stream<List<LoyaltyCardDb>> watchCards({
    required String userId,
    String? spaceId,
    required LoyaltyCardsScope scope,
    LoyaltyCardCategoryFilter categoryFilter = LoyaltyCardCategoryFilter.all,
    bool onlyFavorite = false,
    String searchQuery = '',
  }) {
    return (select(loyaltyCards)
          ..where((c) => _filter(
                c,
                userId: userId,
                spaceId: spaceId,
                scope: scope,
                categoryFilter: categoryFilter,
                onlyFavorite: onlyFavorite,
                searchQuery: searchQuery,
              ))
          ..orderBy([
            (c) => OrderingTerm.asc(c.sortOrder, nulls: NullsOrder.last),
            (c) => OrderingTerm.desc(c.isFavorite),
            (c) => OrderingTerm.asc(c.storeName),
          ]))
        .watch();
  }

  /// Сводка: всего / избранных / семейных (созданы другими членами семьи).
  /// Возвращает запись (total, favorites, family).
  Future<(int, int, int)> stats({
    required String userId,
    String? spaceId,
  }) async {
    if (spaceId == null) {
      final rows = await customSelect(
        'SELECT COUNT(*) AS total, '
        'COALESCE(SUM(CASE WHEN is_favorite = 1 THEN 1 ELSE 0 END), 0) AS favorites '
        'FROM loyalty_cards WHERE user_id = ?',
        variables: [Variable.withString(userId)],
      ).get();
      final r = rows.isEmpty ? null : rows.first;
      return (r?.read<int>('total') ?? 0, r?.read<int>('favorites') ?? 0, 0);
    }
    final rows = await customSelect(
      'SELECT COUNT(*) AS total, '
      'COALESCE(SUM(CASE WHEN is_favorite = 1 THEN 1 ELSE 0 END), 0) AS favorites, '
      'COALESCE(SUM(CASE WHEN space_id = ? AND user_id != ? THEN 1 ELSE 0 END), 0) AS family '
      'FROM loyalty_cards '
      'WHERE user_id = ? OR (space_id = ? AND is_shared = 1)',
      variables: [
        Variable.withString(spaceId),
        Variable.withString(userId),
        Variable.withString(userId),
        Variable.withString(spaceId),
      ],
    ).get();
    final r = rows.isEmpty ? null : rows.first;
    return (
      r?.read<int>('total') ?? 0,
      r?.read<int>('favorites') ?? 0,
      r?.read<int>('family') ?? 0,
    );
  }

  Future<LoyaltyCardDb?> getById(String cardId) {
    return (select(loyaltyCards)..where((c) => c.id.equals(cardId)))
        .getSingleOrNull();
  }

  /// Insert и update одним путём (конфликт по id → обновление).
  /// Вызывающий обязан выставить updatedAt и syncStatus в companion.
  Future<int> writeCard(LoyaltyCardsCompanion card) {
    return into(loyaltyCards).insertOnConflictUpdate(card);
  }

  Future<int> deleteCard(String cardId) {
    return (delete(loyaltyCards)..where((c) => c.id.equals(cardId))).go();
  }

  /// sort_order — [LOCAL]: sync_status НЕ трогаем (поле не синхронизируется).
  Future<int> updateSortOrder(String cardId, int sortOrder) {
    return (update(loyaltyCards)..where((c) => c.id.equals(cardId))).write(
      LoyaltyCardsCompanion(
        sortOrder: Value(sortOrder),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }

  Future<int> setFavorite(String cardId, bool isFavorite) {
    return (update(loyaltyCards)..where((c) => c.id.equals(cardId))).write(
      LoyaltyCardsCompanion(
        isFavorite: Value(isFavorite),
        updatedAt: Value(DateTime.now().toUtc()),
        syncStatus: const Value('pending'),
      ),
    );
  }

  Future<int> setShared(String cardId, bool isShared) {
    return (update(loyaltyCards)..where((c) => c.id.equals(cardId))).write(
      LoyaltyCardsCompanion(
        isShared: Value(isShared),
        updatedAt: Value(DateTime.now().toUtc()),
        syncStatus: const Value('pending'),
      ),
    );
  }

  /// preferred_orientation — [LOCAL]: sync_status НЕ трогаем.
  Future<int> setPreferredOrientation(String cardId, String? orientation) {
    return (update(loyaltyCards)..where((c) => c.id.equals(cardId))).write(
      LoyaltyCardsCompanion(
        preferredOrientation: Value(orientation),
        updatedAt: Value(DateTime.now().toUtc()),
      ),
    );
  }

  // ─── Черновики формы (локальные, без sync) ───

  Future<LoyaltyCardDraftDb?> getFreshDraft(String draftId, DateTime sinceUtc) {
    return (select(loyaltyCardDrafts)
          ..where((d) =>
              d.id.equals(draftId) &
              d.updatedAt.isBiggerOrEqualValue(sinceUtc)))
        .getSingleOrNull();
  }

  Future<void> upsertDraft({
    required String id,
    required String userId,
    String? cardId,
    required String formDataJson,
    required DateTime updatedAt,
  }) {
    return into(loyaltyCardDrafts).insertOnConflictUpdate(
      LoyaltyCardDraftsCompanion(
        id: Value(id),
        userId: Value(userId),
        cardId: Value(cardId),
        formDataJson: Value(formDataJson),
        createdAt: Value(updatedAt),
        updatedAt: Value(updatedAt),
      ),
    );
  }

  Future<int> deleteDraft(String draftId) {
    return (delete(loyaltyCardDrafts)..where((d) => d.id.equals(draftId))).go();
  }

  Future<int> cleanupOldDrafts(DateTime olderThanUtc) {
    return (delete(loyaltyCardDrafts)
          ..where((d) => d.updatedAt.isSmallerThanValue(olderThanUtc)))
        .go();
  }

  Expression<bool> _filter(
    LoyaltyCards c, {
    required String userId,
    required String? spaceId,
    required LoyaltyCardsScope scope,
    required LoyaltyCardCategoryFilter categoryFilter,
    required bool onlyFavorite,
    required String searchQuery,
  }) {
    Expression<bool> expr;
    if (scope == LoyaltyCardsScope.personal) {
      expr = c.userId.equals(userId);
    } else {
      final familyPart = spaceId == null
          ? const Constant<bool>(false)
          : c.spaceId.equals(spaceId) & c.isShared.equals(true);
      expr = c.userId.equals(userId) | familyPart;
    }
    if (categoryFilter != LoyaltyCardCategoryFilter.all) {
      expr = expr & c.category.equals(categoryFilter.name);
    }
    if (onlyFavorite) {
      expr = expr & c.isFavorite.equals(true);
    }
    final q = searchQuery.trim();
    if (q.isNotEmpty) {
      // store_name хранится открыто (метаданные магазина) — поиск без расшифровки.
      expr = expr & c.storeName.like('%$q%');
    }
    return expr;
  }
}