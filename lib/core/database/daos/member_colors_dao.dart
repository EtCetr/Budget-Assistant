// lib/core/database/daos/member_colors_dao.dart
import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/member_colors.dart';

part 'member_colors_dao.g.dart';

@DriftAccessor(tables: [MemberColors])
class MemberColorsDao extends DatabaseAccessor<AppDatabase>
    with _$MemberColorsDaoMixin {
  MemberColorsDao(super.db);

  /// Все override-цвета скоупа (все участники семьи) — для резолвера цветов.
  Stream<List<MemberColor>> watchAllInScope(String spaceScope) {
    return (select(memberColors)
          ..where((t) => t.spaceId.equals(spaceScope)))
        .watch();
  }

  /// Все override-цвета пользователя в скоупе (реактивно).
  Stream<List<MemberColor>> watchOverrides(String userId, String spaceId) {
    return (select(memberColors)
          ..where((t) =>
              t.userId.equals(userId) & t.spaceId.equals(spaceId)))
        .watch();
  }

  Future<MemberColor?> getOverride(String userId, String spaceId) {
    return (select(memberColors)
          ..where((t) =>
              t.userId.equals(userId) & t.spaceId.equals(spaceId)))
        .getSingleOrNull();
  }

  Future<void> upsertOverride(MemberColorsCompanion entry) {
    return into(memberColors).insertOnConflictUpdate(entry);
  }

  /// Сброс цвета: удалить override -> возврат к детерминированному.
  Future<int> deleteOverride(String userId, String spaceId) {
    return (delete(memberColors)
          ..where((t) =>
              t.userId.equals(userId) & t.spaceId.equals(spaceId)))
        .go();
  }
}