// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'split_drafts_dao.dart';

// ignore_for_file: type=lint
mixin _$SplitDraftsDaoMixin on DatabaseAccessor<AppDatabase> {
  $UsersTable get users => attachedDatabase.users;
  $SpacesTable get spaces => attachedDatabase.spaces;
  $AccountsTable get accounts => attachedDatabase.accounts;
  $CategoriesTable get categories => attachedDatabase.categories;
  $TransactionsTable get transactions => attachedDatabase.transactions;
  $SplitDraftsTable get splitDrafts => attachedDatabase.splitDrafts;
  SplitDraftsDaoManager get managers => SplitDraftsDaoManager(this);
}

class SplitDraftsDaoManager {
  final _$SplitDraftsDaoMixin _db;
  SplitDraftsDaoManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db.attachedDatabase, _db.users);
  $$SpacesTableTableManager get spaces =>
      $$SpacesTableTableManager(_db.attachedDatabase, _db.spaces);
  $$AccountsTableTableManager get accounts =>
      $$AccountsTableTableManager(_db.attachedDatabase, _db.accounts);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db.attachedDatabase, _db.categories);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db.attachedDatabase, _db.transactions);
  $$SplitDraftsTableTableManager get splitDrafts =>
      $$SplitDraftsTableTableManager(_db.attachedDatabase, _db.splitDrafts);
}
