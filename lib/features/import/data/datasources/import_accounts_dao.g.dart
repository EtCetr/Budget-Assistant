// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'import_accounts_dao.dart';

// ignore_for_file: type=lint
mixin _$ImportAccountsDaoMixin on DatabaseAccessor<AppDatabase> {
  $UsersTable get users => attachedDatabase.users;
  $SpacesTable get spaces => attachedDatabase.spaces;
  $AccountsTable get accounts => attachedDatabase.accounts;
  ImportAccountsDaoManager get managers => ImportAccountsDaoManager(this);
}

class ImportAccountsDaoManager {
  final _$ImportAccountsDaoMixin _db;
  ImportAccountsDaoManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db.attachedDatabase, _db.users);
  $$SpacesTableTableManager get spaces =>
      $$SpacesTableTableManager(_db.attachedDatabase, _db.spaces);
  $$AccountsTableTableManager get accounts =>
      $$AccountsTableTableManager(_db.attachedDatabase, _db.accounts);
}
