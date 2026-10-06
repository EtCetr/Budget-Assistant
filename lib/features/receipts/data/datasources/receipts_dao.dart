import 'package:drift/drift.dart';
import 'package:budget_assistant/core/database/app_database.dart';

part 'receipts_dao.g.dart';

@DriftAccessor(tables: [Receipts])
class ReceiptsDao extends DatabaseAccessor<AppDatabase> with _$ReceiptsDaoMixin {
  ReceiptsDao(super.db);

  Future<void> insert(ReceiptsCompanion receipt) async {
    await into(receipts).insert(receipt);
  }

  Future<void> updateReceipt(ReceiptDb receipt) async {
    await (update(receipts)..where((r) => r.id.equals(receipt.id))).write(receipt.toCompanion(false));
  }

  Future<void> deleteById(String id) async {
    await (delete(receipts)..where((r) => r.id.equals(id))).go();
  }

  Future<ReceiptDb?> getById(String id) async {
    return await (select(receipts)..where((r) => r.id.equals(id))).getSingleOrNull();
  }

  Future<List<ReceiptDb>> getByUser(String userId) async {
    return await (select(receipts)
      ..where((r) => r.userId.equals(userId))
      ..orderBy([(r) => OrderingTerm.desc(r.receiptDate)]))
      .get();
  }

  Future<void> updateStatus(String id, String status) async {
    await (update(receipts)..where((r) => r.id.equals(id)))
        .write(ReceiptsCompanion(status: Value(status), updatedAt: Value(DateTime.now().toUtc())));
  }
}