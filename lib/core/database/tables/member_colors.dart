// lib/core/database/tables/member_colors.dart
// Этап 21 (ТЗ 6.3.46): override цветов участников семьи (долг D17-3).
// Базовый цвет вычисляется детерминированно: palette[userId.hashCode % 12]
// (синхронизация не нужна). Кастомный override хранится здесь;
// custom_color_hex шифруется AES-256-GCM при sync (Этап 25).
import 'package:drift/drift.dart';
import 'syncable_mixin.dart';
import 'users.dart';

class MemberColors extends Table with SyncableTable {
  TextColumn get id => text().named('id')();
  TextColumn get userId => text().named('user_id').references(Users, #id)();

  /// Скоуп действия. '' = личный цвет (прецедент D20-5: '' вместо NULL,
  /// иначе UNIQUE(user_id, space_id) в SQLite не работает с NULL).
  /// FK на Spaces сознательно нет из-за ''-скоупа.
  TextColumn get spaceId =>
      text().named('space_id').withDefault(const Constant(''))();

  /// Выбранный цвет (#RRGGBB). [E2E]
  TextColumn get customColorHex => text().named('custom_color_hex')();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<Set<Column>> get uniqueKeys => [
        {userId, spaceId},
      ];
}