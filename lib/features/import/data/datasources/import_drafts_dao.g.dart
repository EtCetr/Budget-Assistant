// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'import_drafts_dao.dart';

// ignore_for_file: type=lint
mixin _$ImportDraftsDaoMixin on DatabaseAccessor<AppDatabase> {
  $UsersTable get users => attachedDatabase.users;
  $ImportDraftsTable get importDrafts => attachedDatabase.importDrafts;
  ImportDraftsDaoManager get managers => ImportDraftsDaoManager(this);
}

class ImportDraftsDaoManager {
  final _$ImportDraftsDaoMixin _db;
  ImportDraftsDaoManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db.attachedDatabase, _db.users);
  $$ImportDraftsTableTableManager get importDrafts =>
      $$ImportDraftsTableTableManager(_db.attachedDatabase, _db.importDrafts);
}
