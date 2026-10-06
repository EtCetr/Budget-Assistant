import 'package:drift/drift.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
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
            batch.insertAll(_db.receiptItems, items.map(_toReceiptItemCompanion).toList());
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
        await (_db.delete(_db.receiptItems)..where((i) => i.receiptId.equals(receipt.id))).go();
        if (items.isNotEmpty) {
          await _db.batch((batch) {
            batch.insertAll(_db.receiptItems, items.map(_toReceiptItemCompanion).toList());
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
        await (_db.delete(_db.receiptItems)..where((i) => i.receiptId.equals(id))).go();
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
      final row = await (_db.select(_db.receipts)..where((r) => r.id.equals(id))).getSingleOrNull();
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
      final rows = await (_db.select(_db.receiptItems)..where((i) => i.receiptId.equals(receiptId))).get();
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
}