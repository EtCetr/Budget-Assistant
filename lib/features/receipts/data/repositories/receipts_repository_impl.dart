import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:budget_assistant/features/transactions/domain/entities/split_position_draft.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/database/daos/app_settings_dao.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import 'package:budget_assistant/features/receipts/domain/dtos/receipt_category_lookup.dart';
import 'package:budget_assistant/features/receipts/domain/dtos/receipt_offer_settings.dart';
import 'package:budget_assistant/features/receipts/domain/dtos/transaction_match_candidate.dart';
import 'package:budget_assistant/features/receipts/domain/entities/receipt.dart';
import 'package:budget_assistant/features/receipts/domain/entities/receipt_item.dart';
import 'package:budget_assistant/features/receipts/domain/repositories/receipts_repository.dart';

class ReceiptsRepositoryImpl implements ReceiptsRepository {
  final AppDatabase _db;
  final Logger _logger;

  ReceiptsRepositoryImpl({required AppDatabase db, required Logger logger})
      : _db = db,
        _logger = logger;

  @override
  Future<void> createReceipt(Receipt receipt, List<ReceiptItem> items) async {
    try {
      await _db.transaction(() async {
        await _db.into(_db.receipts).insert(_toReceiptCompanion(receipt));
        if (items.isNotEmpty) {
          await _db.batch((batch) {
            batch.insertAll(
                _db.receiptItems, items.map(_toReceiptItemCompanion).toList());
          });
        }
      });
    } catch (e, stack) {
      _logger.e('Failed to create receipt', error: e, stackTrace: stack);
      rethrow;
    }
  }

  @override
  Future<void> updateReceipt(Receipt receipt, List<ReceiptItem> items) async {
    try {
      await _db.transaction(() async {
        await (_db.update(_db.receipts)..where((r) => r.id.equals(receipt.id)))
            .write(_toReceiptCompanion(receipt));
        await (_db.delete(_db.receiptItems)
              ..where((i) => i.receiptId.equals(receipt.id)))
            .go();
        if (items.isNotEmpty) {
          await _db.batch((batch) {
            batch.insertAll(
                _db.receiptItems, items.map(_toReceiptItemCompanion).toList());
          });
        }
      });
    } catch (e, stack) {
      _logger.e('Failed to update receipt', error: e, stackTrace: stack);
      rethrow;
    }
  }

  @override
  Future<void> deleteReceipt(String id) async {
    try {
      await _db.transaction(() async {
        await (_db.delete(_db.receiptItems)
              ..where((i) => i.receiptId.equals(id)))
            .go();
        await (_db.delete(_db.receipts)..where((r) => r.id.equals(id))).go();
      });
    } catch (e, stack) {
      _logger.e('Failed to delete receipt', error: e, stackTrace: stack);
      rethrow;
    }
  }

  @override
  Future<Receipt?> getReceiptById(String id) async {
    try {
      final row = await (_db.select(_db.receipts)
            ..where((r) => r.id.equals(id)))
          .getSingleOrNull();
      return row == null ? null : _fromDb(row);
    } catch (e, stack) {
      _logger.e('Failed to get receipt', error: e, stackTrace: stack);
      rethrow;
    }
  }

  @override
  Future<List<Receipt>> getReceiptsByUser(String userId) async {
    try {
      final rows = await (_db.select(_db.receipts)
            ..where((r) => r.userId.equals(userId))
            ..orderBy([(r) => OrderingTerm.desc(r.receiptDate)]))
          .get();
      return rows.map(_fromDb).toList();
    } catch (e, stack) {
      _logger.e('Failed to get receipts', error: e, stackTrace: stack);
      rethrow;
    }
  }

  @override
  Future<List<ReceiptItem>> getItemsByReceiptId(String receiptId) async {
    try {
      final rows = await (_db.select(_db.receiptItems)
            ..where((i) => i.receiptId.equals(receiptId)))
          .get();
      return rows.map(_receiptItemFromDb).toList();
    } catch (e, stack) {
      _logger.e('Failed to get receipt items', error: e, stackTrace: stack);
      rethrow;
    }
  }

  @override
  Future<void> updateReceiptStatus(String id, String status) async {
    try {
      await (_db.update(_db.receipts)..where((r) => r.id.equals(id)))
          .write(ReceiptsCompanion(
        status: Value(status),
        updatedAt: Value(DateTime.now().toUtc()),
      ));
    } catch (e, stack) {
      _logger.e('Failed to update receipt status', error: e, stackTrace: stack);
      rethrow;
    }
  }

  @override
  Future<void> saveReceipt(Receipt receipt) async {
    try {
      await (_db.update(_db.receipts)..where((r) => r.id.equals(receipt.id)))
          .write(_toReceiptCompanion(receipt));
    } catch (e, stack) {
      _logger.e('Failed to save receipt meta', error: e, stackTrace: stack);
      rethrow;
    }
  }

  @override
  Future<void> saveItems(String receiptId, List<ReceiptItem> items) async {
    try {
      await _db.transaction(() async {
        await (_db.delete(_db.receiptItems)
              ..where((i) => i.receiptId.equals(receiptId)))
            .go();
        if (items.isNotEmpty) {
          await _db.batch((batch) {
            batch.insertAll(
                _db.receiptItems, items.map(_toReceiptItemCompanion).toList());
          });
        }
      });
    } catch (e, stack) {
      _logger.e('Failed to save receipt items', error: e, stackTrace: stack);
      rethrow;
    }
  }

  @override
  Future<List<TransactionMatchCandidate>> findMatchCandidates({
    required int totalKop,
    required DateTime dateUtc,
  }) async {
    try {
      final min = (totalKop * 0.95).round();
      final max = (totalKop * 1.05).round();
      final start = dateUtc.subtract(const Duration(hours: 48));
      final end = dateUtc.add(const Duration(hours: 48));
      final rows = await (_db.select(_db.transactions)
            ..where((t) =>
                t.type.equals('expense') &
                t.amount.isBetweenValues(min, max) &
                t.date.isBetweenValues(start, end))
            ..orderBy([(t) => OrderingTerm.desc(t.date)]))
          .get();
      return rows
          .map((t) => TransactionMatchCandidate(
                id: t.id,
                dateUtc: t.date,
                amountKop: t.amount,
                auditStatus: t.auditStatus.name,
                hasReceipt: t.receiptId != null,
              ))
          .toList();
    } catch (e, stack) {
      _logger.e('Failed to find match candidates', error: e, stackTrace: stack);
      rethrow;
    }
  }

  @override
  Future<void> linkReceiptToTransaction({
    required String receiptId,
    required String transactionId,
  }) async {
    try {
      if (transactionId.isEmpty) {
        throw StateError('Empty transactionId');
      }
      await _db.transaction(() async {
        final tx = await (_db.select(_db.transactions)
              ..where((t) => t.id.equals(transactionId)))
            .getSingleOrNull();
        if (tx == null) {
          throw StateError('Transaction not found: $transactionId');
        }
        // ТЗ 6.3.23.5: привязка к hold-операциям запрещена.
        if (tx.auditStatus == AuditStatus.pending) {
          throw StateError('Cannot link receipt to pending transaction');
        }
        final now = DateTime.now().toUtc();
        await (_db.update(_db.receipts)..where((r) => r.id.equals(receiptId)))
            .write(ReceiptsCompanion(
          transactionId: Value(transactionId),
          status: const Value('matched'),
          updatedAt: Value(now),
          syncStatus: const Value('pending'),
        ));
        await (_db.update(_db.transactions)
              ..where((t) => t.id.equals(transactionId)))
            .write(TransactionsCompanion(
          receiptId: Value(receiptId),
          updatedAt: Value(now),
          syncStatus: const Value(SyncStatus.pending),
        ));
      });
    } catch (e, stack) {
      _logger.e('Failed to link receipt', error: e, stackTrace: stack);
      rethrow;
    }
  }

  @override
  Future<List<ReceiptCategoryLookup>> getExpenseCategories({
    required String? spaceId,
  }) async {
    try {
      final query = _db.select(_db.categories)
        ..where((c) {
          final isExpense = c.type.equals('expense');
          if (spaceId == null) {
            return isExpense & c.spaceId.isNull();
          }
          return isExpense & (c.spaceId.equals(spaceId) | c.spaceId.isNull());
        })
        ..orderBy([(c) => OrderingTerm.asc(c.name)]);
      final rows = await query.get();
      return rows
          .map((c) => ReceiptCategoryLookup(
                id: c.id,
                name: c.name,
                iconEmoji: c.iconEmoji,
                colorHex: c.colorHex,
              ))
          .toList();
    } catch (e, stack) {
      _logger.e('Failed to get expense categories', error: e, stackTrace: stack);
      rethrow;
    }
  }

  @override
  Future<ReceiptOfferSettings> getReceiptOfferSettings(String userId) async {
    try {
      final s = await AppSettingsDao(_db).getForUser(userId);
      return ReceiptOfferSettings(
        autoOfferNaming: s.autoOfferProductNaming,
        offerNamingCount: s.offerProductNamingCount,
        autoOfferSplit: s.autoOfferReceiptSplit,
        offerSplitCount: s.offerReceiptSplitCount,
        syncImagesToCloud: s.syncImagesToCloud,
      );
    } catch (e, stack) {
      _logger.e('Failed to get settings', error: e, stackTrace: stack);
      rethrow;
    }
  }

  @override
  Future<void> recordNamingDecision(
    String userId, {
    required bool accepted,
  }) async {
    try {
      final dao = AppSettingsDao(_db);
      if (accepted) {
        await dao.updateForUser(
          userId,
          const AppSettingsCompanion(
            offerProductNamingCount: Value(0),
            autoOfferProductNaming: Value(true),
          ),
        );
        return;
      }
      final settings = await dao.getForUser(userId);
      final newCount = settings.offerProductNamingCount + 1;
      await dao.updateForUser(
        userId,
        AppSettingsCompanion(
          offerProductNamingCount: Value(newCount),
          autoOfferProductNaming: Value(newCount < 3),
        ),
      );
    } catch (e, stack) {
      _logger.e('Failed to record naming decision', error: e, stackTrace: stack);
      rethrow;
    }
  }

  ReceiptsCompanion _toReceiptCompanion(Receipt r) {
    return ReceiptsCompanion(
      id: Value(r.id),
      userId: Value(r.userId),
      spaceId: Value(r.spaceId),
      transactionId: Value(r.transactionId),
      storeName: Value(r.storeName),
      totalAmount: Value(r.totalAmount),
      receiptDate: Value(r.receiptDate),
      fiscalData: Value(r.fiscalData),
      rawOcrText: Value(r.rawOcrText),
      imagePath: Value(r.imagePath),
      status: Value(r.status),
      currency: Value(r.currency),
      createdAt: Value(r.createdAt),
      updatedAt: Value(r.updatedAt),
      syncStatus: Value(r.syncStatus.name),
    );
  }

  ReceiptItemsCompanion _toReceiptItemCompanion(ReceiptItem i) {
    return ReceiptItemsCompanion(
      id: Value(i.id),
      receiptId: Value(i.receiptId),
      originalName: Value(i.originalName),
      normalizedName: Value(i.normalizedName),
      quantity: Value(i.quantity),
      unitPrice: Value(i.unitPrice),
      totalPrice: Value(i.totalPrice),
      categoryId: Value(i.categoryId),
      isExcluded: Value(i.isExcluded),
      createdAt: Value(i.createdAt),
      updatedAt: Value(i.updatedAt),
      syncStatus: Value(i.syncStatus.name),
    );
  }

  Receipt _fromDb(ReceiptDb db) {
    return Receipt(
      id: db.id,
      userId: db.userId,
      spaceId: db.spaceId,
      transactionId: db.transactionId,
      storeName: db.storeName,
      totalAmount: db.totalAmount,
      receiptDate: db.receiptDate,
      fiscalData: db.fiscalData,
      rawOcrText: db.rawOcrText,
      imagePath: db.imagePath,
      status: db.status,
      currency: db.currency,
      createdAt: db.createdAt,
      updatedAt: db.updatedAt,
      syncStatus: _parseSyncStatus(db.syncStatus),
    );
  }

  ReceiptItem _receiptItemFromDb(ReceiptItemDb db) {
    return ReceiptItem(
      id: db.id,
      receiptId: db.receiptId,
      originalName: db.originalName,
      normalizedName: db.normalizedName,
      quantity: db.quantity,
      unitPrice: db.unitPrice,
      totalPrice: db.totalPrice,
      categoryId: db.categoryId,
      isExcluded: db.isExcluded,
      createdAt: db.createdAt,
      updatedAt: db.updatedAt,
      syncStatus: _parseSyncStatus(db.syncStatus),
    );
  }

  SyncStatus _parseSyncStatus(String status) {
    return SyncStatus.values.firstWhere(
      (s) => s.name == status,
      orElse: () => SyncStatus.pending,
    );
  }
  @override
  Future<List<SplitPositionDraft>?> getFreshSplitDraft(
      String transactionId) async {
    try {
      final row = await (_db.select(_db.splitDrafts)
            ..where((d) => d.transactionId.equals(transactionId)))
          .getSingleOrNull();
      if (row == null) return null;
      if (DateTime.now().toUtc().difference(row.updatedAt) >
          const Duration(hours: 24)) {
        return null;
      }
      final decoded = jsonDecode(row.positionsJson);
      if (decoded is! List) return null;
      return decoded
          .map((e) =>
              SplitPositionDraft.fromJson((e as Map).cast<String, dynamic>()))
          .toList();
    } catch (e, stack) {
      _logger.e('Failed to read split draft', error: e, stackTrace: stack);
      return null;
    }
  }

  @override
  Future<void> saveSplitDraft(
      String transactionId, List<SplitPositionDraft> positions) async {
    try {
      final now = DateTime.now().toUtc();
      await (_db.delete(_db.splitDrafts)
            ..where((d) => d.transactionId.equals(transactionId)))
          .go();
      await _db.into(_db.splitDrafts).insert(SplitDraftsCompanion(
            id: Value('draft_$transactionId'),
            transactionId: Value(transactionId),
            positionsJson:
                Value(jsonEncode(positions.map((e) => e.toJson()).toList())),
            createdAt: Value(now),
            updatedAt: Value(now),
          ));
    } catch (e, stack) {
      _logger.e('Failed to save split draft', error: e, stackTrace: stack);
    }
  }

  @override
  Future<void> applyReceiptSplit({
    required String receiptId,
    required String transactionId,
    required String actorUserId,
    required List<SplitPositionDraft> positions,
  }) async {
    try {
      await _db.transaction(() async {
        final tx = await (_db.select(_db.transactions)
              ..where((t) => t.id.equals(transactionId)))
            .getSingleOrNull();
        if (tx == null) {
          throw StateError('Transaction not found: $transactionId');
        }
        if (tx.userId != actorUserId) {
          throw StateError('Only owner can split transaction: $transactionId');
        }
        final now = DateTime.now().toUtc();
        await (_db.update(_db.transactions)
              ..where((t) => t.id.equals(transactionId)))
            .write(TransactionsCompanion(
          isSplit: const Value(true),
          updatedAt: Value(now),
          syncStatus: const Value(SyncStatus.pending),
        ));
        await (_db.delete(_db.transactionSplits)
              ..where((s) => s.transactionId.equals(transactionId)))
            .go();
        await _db.batch((batch) {
          batch.insertAll(
            _db.transactionSplits,
            positions
                .map((p) => TransactionSplitsCompanion(
                      id: Value(p.id),
                      transactionId: Value(transactionId),
                      categoryId: Value(p.categoryId!),
                      amount: Value(p.amount),
                      description: Value(p.description),
                      createdAt: Value(now),
                      updatedAt: Value(now),
                      syncStatus: const Value(SyncStatus.pending),
                    ))
                .toList(),
          );
        });
        await (_db.delete(_db.splitDrafts)
              ..where((d) => d.transactionId.equals(transactionId)))
            .go();
      });
    } catch (e, stack) {
      _logger.e('Failed to apply receipt split', error: e, stackTrace: stack);
      rethrow;
    }
  }

  @override
  Future<void> recordSplitDecision(
    String userId, {
    required bool accepted,
  }) async {
    try {
      final dao = AppSettingsDao(_db);
      if (accepted) {
        await dao.updateForUser(
          userId,
          const AppSettingsCompanion(
            offerReceiptSplitCount: Value(0),
            autoOfferReceiptSplit: Value(true),
          ),
        );
        return;
      }
      final settings = await dao.getForUser(userId);
      final newCount = settings.offerReceiptSplitCount + 1;
      await dao.updateForUser(
        userId,
        AppSettingsCompanion(
          offerReceiptSplitCount: Value(newCount),
          autoOfferReceiptSplit: Value(newCount < 3),
        ),
      );
    } catch (e, stack) {
      _logger.e('Failed to record split decision', error: e, stackTrace: stack);
      rethrow;
    }
  }
}