// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recurring_transactions_dao.dart';

// ignore_for_file: type=lint
mixin _$RecurringTransactionsDaoMixin on DatabaseAccessor<AppDatabase> {
  $UsersTable get users => attachedDatabase.users;
  $SpacesTable get spaces => attachedDatabase.spaces;
  $CategoriesTable get categories => attachedDatabase.categories;
  $RecurringTransactionsTable get recurringTransactions =>
      attachedDatabase.recurringTransactions;
  RecurringTransactionsDaoManager get managers =>
      RecurringTransactionsDaoManager(this);
}

class RecurringTransactionsDaoManager {
  final _$RecurringTransactionsDaoMixin _db;
  RecurringTransactionsDaoManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db.attachedDatabase, _db.users);
  $$SpacesTableTableManager get spaces =>
      $$SpacesTableTableManager(_db.attachedDatabase, _db.spaces);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db.attachedDatabase, _db.categories);
  $$RecurringTransactionsTableTableManager get recurringTransactions =>
      $$RecurringTransactionsTableTableManager(
        _db.attachedDatabase,
        _db.recurringTransactions,
      );
}
