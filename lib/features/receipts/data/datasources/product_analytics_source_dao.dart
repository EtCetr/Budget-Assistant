import 'package:drift/drift.dart';
import 'package:budget_assistant/core/database/app_database.dart';

part 'product_analytics_source_dao.g.dart';

/// Источник сырых данных для аналитики товаров (ТЗ 6.3.24):
/// чеки, позиции, алиасы, категории. DAO Этапа 16 не изменяем.
@DriftAccessor(tables: [Categories, Receipts, ReceiptItems, ProductAliases])
class ProductAnalyticsSourceDao extends DatabaseAccessor<AppDatabase>
    with _$ProductAnalyticsSourceDaoMixin {
  ProductAnalyticsSourceDao(super.db);

  Future<List<ReceiptDb>> receiptsByUser(String userId) {
    return (select(receipts)..where((r) => r.userId.equals(userId))).get();
  }

  Future<List<ReceiptItemDb>> itemsForReceipts(List<String> receiptIds) {
    if (receiptIds.isEmpty) return Future.value(const <ReceiptItemDb>[]);
    return (select(receiptItems)
          ..where((i) => i.receiptId.isIn(receiptIds)))
        .get();
  }

  Future<List<ProductAliasDb>> aliasesByUser(String userId) {
    return (select(productAliases)..where((a) => a.userId.equals(userId)))
        .get();
  }

  /// Категории пользователя + текущего пространства (имя/цвет/эмодзи для UI).
  Future<List<Category>> categoriesFor(String userId, String? spaceId) {
    return (select(categories)
          ..where((c) => spaceId == null
              ? c.userId.equals(userId)
              : (c.userId.equals(userId) | c.spaceId.equals(spaceId))))
        .get();
  }
}