import 'package:drift/drift.dart';

/// Инвайты в пространство (ТОМ 2 §2.4). Токен — секрет ссылки (IKM для HKDF).
@TableIndex(name: 'idx_invitations_space', columns: {#spaceId})
@TableIndex(name: 'idx_invitations_sync', columns: {#syncStatus})
class Invitations extends Table {
  TextColumn get id => text()();
  TextColumn get spaceId => text()();
  TextColumn get token => text().unique()();
  TextColumn get encryptedSalt => text()();
  TextColumn get role => text().withDefault(const Constant('member'))();
  TextColumn get status => text().withDefault(const Constant('active'))();
  TextColumn get createdBy => text()();
  TextColumn get acceptedBy => text().nullable()();
  DateTimeColumn get acceptedAt => dateTime().nullable()();
  DateTimeColumn get expiresAt => dateTime()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending'))();
  @override
  Set<Column> get primaryKey => {id};
}