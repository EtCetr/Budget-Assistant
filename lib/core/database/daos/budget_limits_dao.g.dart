// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'budget_limits_dao.dart';

// ignore_for_file: type=lint
mixin _$BudgetLimitsDaoMixin on DatabaseAccessor<AppDatabase> {
  $SpacesTable get spaces => attachedDatabase.spaces;
  $UsersTable get users => attachedDatabase.users;
  $CategoriesTable get categories => attachedDatabase.categories;
  $BudgetLimitsTable get budgetLimits => attachedDatabase.budgetLimits;
  BudgetLimitsDaoManager get managers => BudgetLimitsDaoManager(this);
}

class BudgetLimitsDaoManager {
  final _$BudgetLimitsDaoMixin _db;
  BudgetLimitsDaoManager(this._db);
  $$SpacesTableTableManager get spaces =>
      $$SpacesTableTableManager(_db.attachedDatabase, _db.spaces);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db.attachedDatabase, _db.users);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db.attachedDatabase, _db.categories);
  $$BudgetLimitsTableTableManager get budgetLimits =>
      $$BudgetLimitsTableTableManager(_db.attachedDatabase, _db.budgetLimits);
}
