// lib/core/database/tables/sync_logs.dart
import 'package:drift/drift.dart';
import 'users.dart';

class SyncLogs extends Table {
  TextColumn get id => text().named('id')();
  TextColumn get userId => text().named('user_id').references(Users, #id)();
  DateTimeColumn get timestamp => dateTime().named('timestamp')();
  TextColumn get status =>
      text().named('status')(); // success | partial | failed
  TextColumn get errorMessage => text().named('error_message').nullable()();
  IntColumn get entitiesSyncedCount =>
      integer().named('entities_synced_count').withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};
}
