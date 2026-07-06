// lib/core/database/tables/notifications.dart
import 'package:drift/drift.dart';
import 'syncable_mixin.dart';
import 'users.dart';
import 'spaces.dart';

class Notifications extends Table with SyncableTable {
  TextColumn get id => text().named('id')();
  TextColumn get userId => text().named('user_id').references(Users, #id)();
  TextColumn get spaceId =>
      text().named('space_id').references(Spaces, #id).nullable()();
  TextColumn get type => text().named('type')(); // 27 типов из ТОМ 5
  TextColumn get title => text().named('title')(); // [E2E]
  TextColumn get body => text().named('body')(); // [E2E]
  BoolColumn get isRead =>
      boolean().named('is_read').withDefault(const Constant(false))();
  TextColumn get relatedEntityId =>
      text().named('related_entity_id').nullable()();
  TextColumn get actionTaken =>
      text().named('action_taken').nullable()(); // confirmed | dismissed

  @override
  Set<Column> get primaryKey => {id};
}
