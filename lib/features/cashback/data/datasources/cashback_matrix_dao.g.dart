// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cashback_matrix_dao.dart';

// ignore_for_file: type=lint
mixin _$CashbackMatrixDaoMixin on DatabaseAccessor<AppDatabase> {
  $UsersTable get users => attachedDatabase.users;
  $SpacesTable get spaces => attachedDatabase.spaces;
  $AccountsTable get accounts => attachedDatabase.accounts;
  $CategoriesTable get categories => attachedDatabase.categories;
  $CashbackMatrixTable get cashbackMatrix => attachedDatabase.cashbackMatrix;
  CashbackMatrixDaoManager get managers => CashbackMatrixDaoManager(this);
}

class CashbackMatrixDaoManager {
  final _$CashbackMatrixDaoMixin _db;
  CashbackMatrixDaoManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db.attachedDatabase, _db.users);
  $$SpacesTableTableManager get spaces =>
      $$SpacesTableTableManager(_db.attachedDatabase, _db.spaces);
  $$AccountsTableTableManager get accounts =>
      $$AccountsTableTableManager(_db.attachedDatabase, _db.accounts);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db.attachedDatabase, _db.categories);
  $$CashbackMatrixTableTableManager get cashbackMatrix =>
      $$CashbackMatrixTableTableManager(
        _db.attachedDatabase,
        _db.cashbackMatrix,
      );
}
