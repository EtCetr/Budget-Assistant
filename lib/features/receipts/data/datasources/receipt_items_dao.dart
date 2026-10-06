import 'package:drift/drift.dart';
import 'package:budget_assistant/core/database/app_database.dart';

part 'receipt_items_dao.g.dart';

@DriftAccessor(tables: [ReceiptItems])
class ReceiptItemsDao extends DatabaseAccessor<AppDatabase> with _$ReceiptItemsDaoMixin {
  ReceiptItemsDao(super.db);

  Future<void> insert(ReceiptItemsCompanion item) async {
    await into(receiptItems).insert(item);
  }

  Future<void> insertAll(List<ReceiptItemsCompanion> items) async {
    await batch((batch) {
      batch.insertAll(receiptItems, items);
    });
  }

  Future<void> updateItem(ReceiptItemDb item) async {
    await (update(receiptItems)..where((i) => i.id.equals(item.id))).write(item.toCompanion(false));
  }

  Future<void> deleteById(String id) async {
    await (delete(receiptItems)..where((i) => i.id.equals(id))).go();
  }

  Future<void> deleteByReceiptId(String receiptId) async {
    await (delete(receiptItems)..where((i) => i.receiptId.equals(receiptId))).go();
  }

  Future<List<ReceiptItemDb>> getByReceiptId(String receiptId) async {
    return await (select(receiptItems)
      ..where((i) => i.receiptId.equals(receiptId))
      ..orderBy([(i) => OrderingTerm.asc(i.id)]))
      .get();
  }
}