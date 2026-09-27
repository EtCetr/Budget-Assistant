// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_dao.dart';

// ignore_for_file: type=lint
mixin _$CalendarDaoMixin on DatabaseAccessor<AppDatabase> {
  $UsersTable get users => attachedDatabase.users;
  $SpacesTable get spaces => attachedDatabase.spaces;
  $AccountsTable get accounts => attachedDatabase.accounts;
  $CategoriesTable get categories => attachedDatabase.categories;
  $TransactionsTable get transactions => attachedDatabase.transactions;
  $TransactionSplitsTable get transactionSplits =>
      attachedDatabase.transactionSplits;
  $MembershipsTable get memberships => attachedDatabase.memberships;
  $RemindersTable get reminders => attachedDatabase.reminders;
  CalendarDaoManager get managers => CalendarDaoManager(this);
}

class CalendarDaoManager {
  final _$CalendarDaoMixin _db;
  CalendarDaoManager(this._db);
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
  $$TransactionSplitsTableTableManager get transactionSplits =>
      $$TransactionSplitsTableTableManager(
        _db.attachedDatabase,
        _db.transactionSplits,
      );
  $$MembershipsTableTableManager get memberships =>
      $$MembershipsTableTableManager(_db.attachedDatabase, _db.memberships);
  $$RemindersTableTableManager get reminders =>
      $$RemindersTableTableManager(_db.attachedDatabase, _db.reminders);
}
