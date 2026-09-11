// lib/core/database/tables/spaces.dart
import 'package:drift/drift.dart';
import 'syncable_mixin.dart';

class Spaces extends Table with SyncableTable {
  TextColumn get id => text().named('id')();
  TextColumn get name => text().named('name')(); // [E2E]
  TextColumn get encryptionSalt => text().named('encryption_salt')();
  TextColumn get status => text()
      .named('status')
      .withDefault(const Constant('active'))(); // active | dissolved
  TextColumn get currencyCode =>
      text().named('currency_code').withDefault(const Constant('RUB'))();

  @override
  Set<Column> get primaryKey => {id};
}
