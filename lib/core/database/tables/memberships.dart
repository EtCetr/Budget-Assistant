// lib/core/database/tables/memberships.dart
import 'package:drift/drift.dart';
import 'syncable_mixin.dart';
import 'users.dart';
import 'spaces.dart';

class Memberships extends Table with SyncableTable {
  TextColumn get id => text().named('id')();
  TextColumn get userId => text().named('user_id').references(Users, #id)();
  TextColumn get spaceId => text().named('space_id').references(Spaces, #id)();
  TextColumn get role => text()
      .named('role')
      .withDefault(const Constant('member'))(); // admin | member
  TextColumn get status => text()
      .named('status')
      .withDefault(const Constant('active'))(); // active | pending | left
  DateTimeColumn get lastActiveAt =>
      dateTime().named('last_active_at').nullable()();
  DateTimeColumn get joinedAt => dateTime().named('joined_at')();
  DateTimeColumn get leftAt => dateTime().named('left_at').nullable()();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
    {userId, spaceId},
  ];
}
