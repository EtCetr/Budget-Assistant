import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/spaces.dart';

part 'spaces_dao.g.dart';

@DriftAccessor(tables: [Spaces])
class SpacesDao extends DatabaseAccessor<AppDatabase> with _$SpacesDaoMixin {
  SpacesDao(super.db);

  Future<Space?> getById(String id) {
    return (select(spaces)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  Stream<Space?> watchById(String id) {
    return (select(spaces)..where((t) => t.id.equals(id))).watchSingleOrNull();
  }

  /// Получить только активные пространства
  Future<List<Space>> getActive() {
    return (select(spaces)..where((t) => t.status.equals('active'))).get();
  }

  Stream<List<Space>> watchActive() {
    return (select(spaces)..where((t) => t.status.equals('active'))).watch();
  }

  Future<void> upsert(Space space) {
    return into(spaces).insertOnConflictUpdate(space.toCompanion(true));
  }

  /// Архивировать пространство (не удаляем, чтобы сохранить историю)
  Future<int> archive(String id) {
    return (update(spaces)..where((t) => t.id.equals(id))).write(
      const SpacesCompanion(
        status: Value('archived'),
        syncStatus: Value('pending'),
      ),
    );
  }
}
