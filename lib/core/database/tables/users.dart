// lib/core/database/tables/users.dart
import 'package:drift/drift.dart';
import 'syncable_mixin.dart';

class Users extends Table with SyncableTable {
  TextColumn get id => text().named('id')();
  TextColumn get email => text().named('email')();
  TextColumn get displayName => text().named('display_name')(); // [E2E]
  TextColumn get displayNameDative =>
      text().named('display_name_dative').nullable()(); // [E2E]
  TextColumn get avatarUrl => text().named('avatar_url').nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
