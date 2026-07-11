// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_logs_dao.dart';

// ignore_for_file: type=lint
mixin _$SyncLogsDaoMixin on DatabaseAccessor<AppDatabase> {
  $UsersTable get users => attachedDatabase.users;
  $SyncLogsTable get syncLogs => attachedDatabase.syncLogs;
  SyncLogsDaoManager get managers => SyncLogsDaoManager(this);
}

class SyncLogsDaoManager {
  final _$SyncLogsDaoMixin _db;
  SyncLogsDaoManager(this._db);
  $$UsersTableTableManager get users =>
      $$UsersTableTableManager(_db.attachedDatabase, _db.users);
  $$SyncLogsTableTableManager get syncLogs =>
      $$SyncLogsTableTableManager(_db.attachedDatabase, _db.syncLogs);
}
