// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'year_budget_dao.dart';

// ignore_for_file: type=lint
mixin _$YearBudgetDaoMixin on DatabaseAccessor<AppDatabase> {
  $UsersTable get users => attachedDatabase.users;
  $SpacesTable get spaces => attachedDatabase.spaces;
  $AccountsTable get accounts => attachedDatabase.accounts;
  $CategoriesTable get categories => attachedDatabase.categories;
  $TransactionsTable get transactions => attachedDatabase.transactions;
  $TransactionSplitsTable get transactionSplits =>
      attachedDatabase.transactionSplits;
  $BudgetLimitsTable get budgetLimits => attachedDatabase.budgetLimits;
  YearBudgetDaoManager get managers => YearBudgetDaoManager(this);
}

class YearBudgetDaoManager {
  final _$YearBudgetDaoMixin _db;
  YearBudgetDaoManager(this._db);
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
  $$BudgetLimitsTableTableManager get budgetLimits =>
      $$BudgetLimitsTableTableManager(_db.attachedDatabase, _db.budgetLimits);
}
