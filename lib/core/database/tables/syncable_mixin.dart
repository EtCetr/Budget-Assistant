import 'package:drift/drift.dart';

mixin SyncableTable on Table {
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  DateTimeColumn get updatedAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get syncStatus =>
      text().named('sync_status').withDefault(const Constant('pending'))();
}
