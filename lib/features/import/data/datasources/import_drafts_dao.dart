import 'package:drift/drift.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/database/tables/import_drafts.dart';

part 'import_drafts_dao.g.dart';

@DriftAccessor(tables: [ImportDrafts])
class ImportDraftsDao extends DatabaseAccessor<AppDatabase>
    with _$ImportDraftsDaoMixin {
  ImportDraftsDao(super.db);

  /// Получить черновик пользователя (последний по обновлению).
  Future<ImportDraftDb?> getForUser(String userId) {
    return (select(importDrafts)
          ..where((t) => t.userId.equals(userId))
          ..orderBy([(t) => OrderingTerm.desc(t.updatedAt)])
          ..limit(1))
        .getSingleOrNull();
  }

  /// Создать или обновить черновик.
  Future<void> upsert(ImportDraftDb row) {
    return into(importDrafts)
        .insert(row, mode: InsertMode.insertOrReplace);
  }

  /// Удалить черновик после успешного импорта.
  Future<void> deleteForUser(String userId) {
    return (delete(importDrafts)
          ..where((t) => t.userId.equals(userId)))
        .go();
  }

  /// Очистка старых черновиков (> 7 дней).
  Future<int> deleteOlderThan(DateTime cutoff) {
    return (delete(importDrafts)
          ..where((t) => t.updatedAt.isSmallerThanValue(cutoff)))
        .go();
  }
}