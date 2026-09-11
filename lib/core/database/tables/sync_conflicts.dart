// lib/core/database/tables/sync_conflicts.dart
import 'package:drift/drift.dart';

class SyncConflicts extends Table {
  TextColumn get id => text().named('id')();
  TextColumn get entityType =>
      text().named('entity_type')(); // accounts, settings и т.д.
  TextColumn get entityId => text().named('entity_id')();
  TextColumn get localValue =>
      text().named('local_value')(); // [E2E] JSON локального состояния
  TextColumn get remoteValue =>
      text().named('remote_value')(); // [E2E] JSON серверного состояния
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get resolvedAt => dateTime().named('resolved_at').nullable()();
  TextColumn get resolution =>
      text().named('resolution').nullable()(); // local | remote | merged

  @override
  Set<Column> get primaryKey => {id};
}
