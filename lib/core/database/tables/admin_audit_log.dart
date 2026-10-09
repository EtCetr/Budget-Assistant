import 'package:drift/drift.dart';

/// Журнал действий админов (ТОМ 2 §21.3). metadata_json — только UUID/enum, без plaintext-имён.
/// Колонка "actionType" вместо "action" — зарезервированное слово в Drift/Flutter.
@TableIndex(name: 'idx_audit_space', columns: {#spaceId, #createdAt})
class AdminAuditLog extends Table {
  TextColumn get id => text()();
  TextColumn get spaceId => text()();
  TextColumn get actorUserId => text()();
  TextColumn get actionType => text()();
  TextColumn get targetType => text().withDefault(const Constant('member'))();
  TextColumn get targetId => text().nullable()();
  TextColumn get metadataJson => text().withDefault(const Constant('{}'))();
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  @override
  Set<Column> get primaryKey => {id};
}