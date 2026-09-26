import 'package:drift/drift.dart';
import 'package:budget_assistant/core/database/app_database.dart';
part 'split_drafts_dao.g.dart';

@DriftAccessor(tables: [SplitDrafts])
class SplitDraftsDao extends DatabaseAccessor<AppDatabase>
    with _$SplitDraftsDaoMixin {
  SplitDraftsDao(super.db);

  Future<SplitDraftDb?> getFresh(String draftId, DateTime sinceUtc) {
    return (select(splitDrafts)
          ..where((d) =>
              d.id.equals(draftId) &
              d.updatedAt.isBiggerOrEqualValue(sinceUtc)))
        .getSingleOrNull();
  }

  Future<void> upsert({
    required String id,
    required String transactionId,
    required String positionsJson,
    required DateTime updatedAt,
  }) {
    return into(splitDrafts).insertOnConflictUpdate(
      SplitDraftsCompanion(
        id: Value(id),
        transactionId: Value(transactionId),
        positionsJson: Value(positionsJson),
        createdAt: Value(updatedAt),
        updatedAt: Value(updatedAt),
      ),
    );
  }

  Future<int> deleteById(String id) {
    return (delete(splitDrafts)..where((d) => d.id.equals(id))).go();
  }

  Future<int> cleanupOld(DateTime olderThanUtc) {
    return (delete(splitDrafts)
          ..where((d) => d.updatedAt.isSmallerThanValue(olderThanUtc)))
        .go();
  }
}