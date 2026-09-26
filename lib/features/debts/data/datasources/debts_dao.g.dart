// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'debts_dao.dart';

// ignore_for_file: type=lint
mixin _$DebtsDaoMixin on DatabaseAccessor<AppDatabase> {
  $UsersTable get users => attachedDatabase.users;
  $SpacesTable get spaces => attachedDatabase.spaces;
  $CategoriesTable get categories => attachedDatabase.categories;
  $AccountsTable get accounts => attachedDatabase.accounts;
  $TransactionsTable get transactions => attachedDatabase.transactions;
  $TransactionSplitsTable get transactionSplits =>
      attachedDatabase.transactionSplits;
  $DebtsTable get debts => attachedDatabase.debts;
  $DebtDraftsTable get debtDrafts => attachedDatabase.debtDrafts;
  DebtsDaoManager get managers => DebtsDaoManager(this);
}

class DebtsDaoManager {
  final _$DebtsDaoMixin _db;
  DebtsDaoManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db.attachedDatabase, _db.users);
  $$SpacesTableTableManager get spaces =>
      $$SpacesTableTableManager(_db.attachedDatabase, _db.spaces);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db.attachedDatabase, _db.categories);
  $$AccountsTableTableManager get accounts =>
      $$AccountsTableTableManager(_db.attachedDatabase, _db.accounts);
  $$TransactionsTableTableManager get transactions =>
      $$TransactionsTableTableManager(_db.attachedDatabase, _db.transactions);
  $$TransactionSplitsTableTableManager get transactionSplits =>
      $$TransactionSplitsTableTableManager(
        _db.attachedDatabase,
        _db.transactionSplits,
      );
  $$DebtsTableTableManager get debts =>
      $$DebtsTableTableManager(_db.attachedDatabase, _db.debts);
  $$DebtDraftsTableTableManager get debtDrafts =>
      $$DebtDraftsTableTableManager(_db.attachedDatabase, _db.debtDrafts);
}
