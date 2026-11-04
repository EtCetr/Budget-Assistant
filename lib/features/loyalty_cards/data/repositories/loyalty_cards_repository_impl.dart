import 'dart:convert';

import 'package:drift/drift.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import '../../domain/entities/loyalty_card.dart';
import '../../domain/entities/loyalty_card_form_draft.dart';
import '../../domain/repositories/loyalty_cards_repository.dart';
import '../datasources/loyalty_cards_dao.dart';

class LoyaltyCardsRepositoryImpl implements LoyaltyCardsRepository {
  LoyaltyCardsRepositoryImpl({
    required LoyaltyCardsDao dao,
    required Logger logger,
  })  : _dao = dao,
        _logger = logger;

  final LoyaltyCardsDao _dao;
  final Logger _logger;

  @override
  Stream<List<LoyaltyCard>> watchCards({
    required String userId,
    String? spaceId,
    required LoyaltyCardsScope scope,
    LoyaltyCardCategoryFilter categoryFilter = LoyaltyCardCategoryFilter.all,
    bool onlyFavorite = false,
    String searchQuery = '',
  }) {
    try {
      return _dao
          .watchCards(
            userId: userId,
            spaceId: spaceId,
            scope: scope,
            categoryFilter: categoryFilter,
            onlyFavorite: onlyFavorite,
            searchQuery: searchQuery,
          )
          .map((rows) => rows.map(_mapCard).toList());
    } catch (e, st) {
      _logger.e('watchCards failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<LoyaltyCardsStats> stats({
    required String userId,
    String? spaceId,
  }) async {
    try {
      final (total, favorites, family) =
          await _dao.stats(userId: userId, spaceId: spaceId);
      return LoyaltyCardsStats(
        total: total,
        favorites: favorites,
        family: family,
      );
    } catch (e, st) {
      _logger.e('stats failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<LoyaltyCard?> getById(String cardId) async {
    try {
      final row = await _dao.getById(cardId);
      return row == null ? null : _mapCard(row);
    } catch (e, st) {
      _logger.e('getById failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> insert(LoyaltyCard card) async {
    try {
      await _dao.writeCard(_companion(card));
    } catch (e, st) {
      _logger.e('insert failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> update(LoyaltyCard card) async {
    try {
      await _dao.writeCard(_companion(card));
    } catch (e, st) {
      _logger.e('update failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> delete(String cardId) async {
    try {
      await _dao.deleteCard(cardId);
    } catch (e, st) {
      _logger.e('delete failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> updateSortOrder(String cardId, int sortOrder) async {
    try {
      await _dao.updateSortOrder(cardId, sortOrder);
    } catch (e, st) {
      _logger.e('updateSortOrder failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> setFavorite(String cardId, bool isFavorite) async {
    try {
      await _dao.setFavorite(cardId, isFavorite);
    } catch (e, st) {
      _logger.e('setFavorite failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> setShared(String cardId, bool isShared) async {
    try {
      await _dao.setShared(cardId, isShared);
    } catch (e, st) {
      _logger.e('setShared failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> setPreferredOrientation(String cardId, String? orientation) async {
    try {
      await _dao.setPreferredOrientation(cardId, orientation);
    } catch (e, st) {
      _logger.e('setPreferredOrientation failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<LoyaltyCardFormDraft?> getFreshDraft(String userId) async {
    try {
      final since = DateTime.now().toUtc().subtract(const Duration(hours: 24));
      final row = await _dao.getFreshDraft('loyalty_draft_$userId', since);
      if (row == null) return null;
      return LoyaltyCardFormDraft.fromJson(
          jsonDecode(row.formDataJson) as Map<String, dynamic>);
    } on FormatException catch (e) {
      _logger.w('Corrupt loyalty draft ignored: $e');
      return null;
    } catch (e, st) {
      _logger.e('getFreshDraft failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> saveDraft(String userId, LoyaltyCardFormDraft draft) async {
    try {
      final now = DateTime.now().toUtc();
      await _dao.upsertDraft(
        id: 'loyalty_draft_$userId',
        userId: userId,
        cardId: draft.cardId,
        formDataJson: jsonEncode(draft.toJson()),
        updatedAt: now,
      );
      await _dao.cleanupOldDrafts(now.subtract(const Duration(days: 7)));
    } catch (e, st) {
      _logger.e('saveDraft failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  @override
  Future<void> deleteDraftByUser(String userId) async {
    try {
      await _dao.deleteDraft('loyalty_draft_$userId');
    } catch (e, st) {
      _logger.e('deleteDraft failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  LoyaltyCardsCompanion _companion(LoyaltyCard c) {
    return LoyaltyCardsCompanion(
      id: Value(c.id),
      userId: Value(c.userId),
      spaceId: Value(c.spaceId),
      storeName: Value(c.storeName),
      cardNumber: Value(c.cardNumber),
      barcodeType: Value(c.barcodeType.name),
      barcodeData: Value(c.barcodeData),
      brandColor: Value(c.brandColor),
      iconAsset: Value(c.iconAsset),
      category: Value(c.category.name),
      isFavorite: Value(c.isFavorite),
      isShared: Value(c.isShared),
      sortOrder: Value(c.sortOrder),
      preferredOrientation: Value(c.preferredOrientation),
      createdAt: Value(c.createdAt),
      updatedAt: Value(c.updatedAt),
      syncStatus: Value(c.syncStatus.name),
    );
  }

  LoyaltyCard _mapCard(LoyaltyCardDb db) {
    return LoyaltyCard(
      id: db.id,
      userId: db.userId,
      spaceId: db.spaceId,
      storeName: db.storeName,
      cardNumber: db.cardNumber,
      barcodeType: BarcodeType.values.firstWhere(
        (t) => t.name == db.barcodeType,
        orElse: () => BarcodeType.manual,
      ),
      barcodeData: db.barcodeData,
      brandColor: db.brandColor,
      iconAsset: db.iconAsset,
      category: LoyaltyCardCategory.values.firstWhere(
        (c) => c.name == db.category,
        orElse: () => LoyaltyCardCategory.other,
      ),
      isFavorite: db.isFavorite,
      isShared: db.isShared,
      sortOrder: db.sortOrder,
      preferredOrientation: db.preferredOrientation,
      createdAt: db.createdAt,
      updatedAt: db.updatedAt,
      syncStatus: SyncStatus.values.firstWhere(
        (s) => s.name == db.syncStatus,
        orElse: () => SyncStatus.pending,
      ),
    );
  }
}