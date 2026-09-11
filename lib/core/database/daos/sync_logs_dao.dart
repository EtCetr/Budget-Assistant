import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/sync_logs.dart';

part 'sync_logs_dao.g.dart';

@DriftAccessor(tables: [SyncLogs])
class SyncLogsDao extends DatabaseAccessor<AppDatabase>
    with _$SyncLogsDaoMixin {
  SyncLogsDao(super.db);

  /// Получить последние N логов синхронизации
  Future<List<SyncLog>> getRecent(String userId, {int limit = 50}) {
    return (select(syncLogs)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([(t) => OrderingTerm.desc(t.timestamp)])
          ..limit(limit))
        .get();
  }

  /// Записать успешную синхронизацию
  Future<void> logSuccess(String userId, int entitiesSynced) {
    return into(syncLogs).insert(
      SyncLogsCompanion.insert(
        id: 'sync_${DateTime.now().toUtc().millisecondsSinceEpoch}',
        userId: userId,
        timestamp: DateTime.now().toUtc(),
        status: 'success',
        entitiesSyncedCount: Value(entitiesSynced),
      ),
    );
  }

  /// Записать неудачную синхронизацию
  Future<void> logFailure(String userId, String errorMessage) {
    return into(syncLogs).insert(
      SyncLogsCompanion.insert(
        id: 'sync_${DateTime.now().toUtc().millisecondsSinceEpoch}',
        userId: userId,
        timestamp: DateTime.now().toUtc(),
        status: 'failed',
        errorMessage: Value(errorMessage),
      ),
    );
  }

  /// Очистка старых логов (старше 30 дней)
  Future<int> cleanupOld() {
    final cutoff = DateTime.now().toUtc().subtract(const Duration(days: 30));
    return (delete(
      syncLogs,
    )..where((t) => t.timestamp.isSmallerThanValue(cutoff))).go();
  }
}
