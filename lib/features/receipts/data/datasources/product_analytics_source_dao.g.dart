// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_analytics_source_dao.dart';

// ignore_for_file: type=lint
mixin _$ProductAnalyticsSourceDaoMixin on DatabaseAccessor<AppDatabase> {
  $SpacesTable get spaces => attachedDatabase.spaces;
  $UsersTable get users => attachedDatabase.users;
  $CategoriesTable get categories => attachedDatabase.categories;
  $AccountsTable get accounts => attachedDatabase.accounts;
  $TransactionsTable get transactions => attachedDatabase.transactions;
  $ReceiptsTable get receipts => attachedDatabase.receipts;
  $ReceiptItemsTable get receiptItems => attachedDatabase.receiptItems;
  $ProductAliasesTable get productAliases => attachedDatabase.productAliases;
  ProductAnalyticsSourceDaoManager get managers =>
      ProductAnalyticsSourceDaoManager(this);
}

class ProductAnalyticsSourceDaoManager {
  final _$ProductAnalyticsSourceDaoMixin _db;
  ProductAnalyticsSourceDaoManager(this._db);
  $$SpacesTableTableManager get spaces =>
      $$SpacesTableTableManager(_db.attachedDatabase, _db.spaces);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db.attachedDatabase, _db.users);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db.attachedDatabase, _db.categories);
  $$AccountsTableTableManager get accounts =>
      $$AccountsTableTableManager(_db.attachedDatabase, _db.accounts);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db.attachedDatabase, _db.transactions);
  $$ReceiptsTableTableManager get receipts =>
      $$ReceiptsTableTableManager(_db.attachedDatabase, _db.receipts);
  $$ReceiptItemsTableTableManager get receiptItems =>
      $$ReceiptItemsTableTableManager(_db.attachedDatabase, _db.receiptItems);
  $$ProductAliasesTableTableManager get productAliases =>
      $$ProductAliasesTableTableManager(
        _db.attachedDatabase,
        _db.productAliases,
      );
}
