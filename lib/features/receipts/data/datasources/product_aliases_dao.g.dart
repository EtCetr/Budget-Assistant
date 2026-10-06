// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_aliases_dao.dart';

// ignore_for_file: type=lint
mixin _$ProductAliasesDaoMixin on DatabaseAccessor<AppDatabase> {
  $UsersTable get users => attachedDatabase.users;
  $SpacesTable get spaces => attachedDatabase.spaces;
  $CategoriesTable get categories => attachedDatabase.categories;
  $ProductAliasesTable get productAliases => attachedDatabase.productAliases;
  ProductAliasesDaoManager get managers => ProductAliasesDaoManager(this);
}

class ProductAliasesDaoManager {
  final _$ProductAliasesDaoMixin _db;
  ProductAliasesDaoManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db.attachedDatabase, _db.users);
  $$SpacesTableTableManager get spaces =>
      $$SpacesTableTableManager(_db.attachedDatabase, _db.spaces);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db.attachedDatabase, _db.categories);
  $$ProductAliasesTableTableManager get productAliases =>
      $$ProductAliasesTableTableManager(
        _db.attachedDatabase,
        _db.productAliases,
      );
}
