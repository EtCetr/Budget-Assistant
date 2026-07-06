// lib/core/database/tables/syncable_mixin.dart
import 'package:drift/drift.dart';

mixin SyncableTable on Table {
  DateTimeColumn get createdAt => dateTime().named('created_at')();
  DateTimeColumn get updatedAt => dateTime().named('updated_at')();
  TextColumn get syncStatus =>
      text().named('sync_status').withDefault(const Constant('pending'))();
}
