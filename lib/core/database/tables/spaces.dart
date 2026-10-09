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
  // Этап 18 (6.3.36): identity + dissolve. icon_* — открытые метаданные,
  // monthly_budget_limit — [E2E] при синке. encryption_salt неизменяем.
  TextColumn get iconEmoji => text().named('icon_emoji').nullable()();
  TextColumn get iconColor => text().named('icon_color').nullable()();
  IntColumn get monthlyBudgetLimit =>
      integer().named('monthly_budget_limit').nullable()();
  DateTimeColumn get dissolvedAt => dateTime().named('dissolved_at').nullable()();
  TextColumn get dissolvedBy => text().named('dissolved_by').nullable()();

  @override
  Set<Column> get primaryKey => {id};
}
