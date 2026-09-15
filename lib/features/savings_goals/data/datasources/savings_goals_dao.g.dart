// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'savings_goals_dao.dart';

// ignore_for_file: type=lint
mixin _$SavingsGoalsDaoMixin on DatabaseAccessor<AppDatabase> {
  $UsersTable get users => attachedDatabase.users;
  $SpacesTable get spaces => attachedDatabase.spaces;
  $AccountsTable get accounts => attachedDatabase.accounts;
  $SavingsGoalsTable get savingsGoals => attachedDatabase.savingsGoals;
  $SavingsGoalDraftsTable get savingsGoalDrafts =>
      attachedDatabase.savingsGoalDrafts;
  SavingsGoalsDaoManager get managers => SavingsGoalsDaoManager(this);
}

class SavingsGoalsDaoManager {
  final _$SavingsGoalsDaoMixin _db;
  SavingsGoalsDaoManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db.attachedDatabase, _db.users);
  $$SpacesTableTableManager get spaces =>
      $$SpacesTableTableManager(_db.attachedDatabase, _db.spaces);
  $$AccountsTableTableManager get accounts =>
      $$AccountsTableTableManager(_db.attachedDatabase, _db.accounts);
  $$SavingsGoalsTableTableManager get savingsGoals =>
      $$SavingsGoalsTableTableManager(_db.attachedDatabase, _db.savingsGoals);
  $$SavingsGoalDraftsTableTableManager get savingsGoalDrafts =>
      $$SavingsGoalDraftsTableTableManager(
        _db.attachedDatabase,
        _db.savingsGoalDrafts,
      );
}
