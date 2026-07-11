import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/sync_conflicts.dart';

part 'sync_conflicts_dao.g.dart';

@DriftAccessor(tables: [SyncConflicts])
class SyncConflictsDao extends DatabaseAccessor<AppDatabase>
    with _$SyncConflictsDaoMixin {
  SyncConflictsDao(super.db);

  Future<List<SyncConflict>> getUnresolved() {
    return (select(syncConflicts)
          ..where((t) => t.resolvedAt.isNull())
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  Stream<List<SyncConflict>> watchUnresolved() {
    return (select(syncConflicts)
          ..where((t) => t.resolvedAt.isNull())
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .watch();
  }

  Future<int> resolve(String id, String resolution) {
    return (update(syncConflicts)..where((t) => t.id.equals(id))).write(
      // SyncConflictsCompanion — от имени таблицы!
      SyncConflictsCompanion(
        resolvedAt: Value(DateTime.now().toUtc()),
        resolution: Value(resolution),
      ),
    );
  }

  Future<void> logConflict(SyncConflict conflict) {
    return into(syncConflicts).insert(conflict.toCompanion(true));
  }
}
