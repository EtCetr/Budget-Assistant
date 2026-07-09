// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mortgage_dao.dart';

// ignore_for_file: type=lint
mixin _$MortgageDaoMixin on DatabaseAccessor<AppDatabase> {
  $UsersTable get users => attachedDatabase.users;
  $SpacesTable get spaces => attachedDatabase.spaces;
  $AccountsTable get accounts => attachedDatabase.accounts;
  $MortgagesTable get mortgages => attachedDatabase.mortgages;
  MortgageDaoManager get managers => MortgageDaoManager(this);
}

class MortgageDaoManager {
  final _$MortgageDaoMixin _db;
  MortgageDaoManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db.attachedDatabase, _db.users);
  $$SpacesTableTableManager get spaces =>
      $$SpacesTableTableManager(_db.attachedDatabase, _db.spaces);
  $$AccountsTableTableManager get accounts =>
      $$AccountsTableTableManager(_db.attachedDatabase, _db.accounts);
  $$MortgagesTableTableManager get mortgages =>
      $$MortgagesTableTableManager(_db.attachedDatabase, _db.mortgages);
}
