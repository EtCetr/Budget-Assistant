// TODO(24): unit-тесты состава группы - добавить/переместить/убрать,
// запрет пустого состава, обнуление copy_group_id при одной копии.
import 'package:drift/drift.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'add_transaction_copies_usecase.dart';

/// Этап 23.6 (D23.6-3): long-press «Пространство» — привести группу копий
/// к желаемому составу (добавить / переместить / убрать).
/// Пустой состав запрещён (последнюю копию удалить нельзя).
class SetTransactionSpacesUseCase {
  SetTransactionSpacesUseCase({
    required AppDatabase db,
    required Logger logger,
    required AddTransactionCopiesUseCase addCopies,
  })  : _db = db,
        _logger = logger,
        _addCopies = addCopies;

  final AppDatabase _db;
  final Logger _logger;
  final AddTransactionCopiesUseCase _addCopies;

  Future<void> call({
    required String transactionId,
    required bool personal,
    required Set<String> spaceIds,
    required String userId,
  }) async {
    try {
      if (!personal && spaceIds.isEmpty) {
        throw ArgumentError('Нельзя убрать операцию из всех пространств');
      }
      final source = await (_db.select(_db.transactions)
            ..where((t) => t.id.equals(transactionId)))
          .getSingleOrNull();
      if (source == null) return;
      final gid = source.copyGroupId;
      final group = gid == null
          ? [source]
          : await (_db.select(_db.transactions)
                ..where((t) => t.copyGroupId.equals(gid)))
              .get();
      final presentSpaces = group
          .where((r) => r.spaceId != null)
          .map((r) => r.spaceId!)
          .toSet();
      group.any((r) => r.spaceId == null);

      // Добавить недостающие копии.
      final toAdd = spaceIds.difference(presentSpaces).toList();
      if (toAdd.isNotEmpty) {
        await _addCopies(
          transactionId: transactionId,
          spaceIds: toAdd,
          userId: userId,
        );
      }
      // Убрать лишние.
      final toRemoveSpaces = presentSpaces.difference(spaceIds);
      for (final r in group) {
        final isPersonalRow = r.spaceId == null;
        final remove = isPersonalRow ? !personal : toRemoveSpaces.contains(r.spaceId);
        if (!remove) continue;
        await (_db.delete(_db.transactionSplits)
              ..where((s) => s.transactionId.equals(r.id)))
            .go();
        await (_db.delete(_db.transactions)
              ..where((t) => t.id.equals(r.id)))
            .go();
      }
      // Перечитать группу и нормализовать copy_group_id.
      final anchor = personal
          ? await (_db.select(_db.transactions)
                ..where((t) =>
                    t.copyGroupId.equals(gid ?? '') & t.spaceId.isNull()))
              .getSingleOrNull()
          : null;
      final remaining = gid == null
          ? <TransactionDb>[]
          : await (_db.select(_db.transactions)
                ..where((t) => t.copyGroupId.equals(gid)))
              .get();
      if (remaining.length <= 1) {
        for (final r in remaining) {
          await (_db.update(_db.transactions)
                ..where((t) => t.id.equals(r.id)))
              .write(const TransactionsCompanion(copyGroupId: Value(null)));
        }
      } else if (gid == null && anchor != null) {
        await (_db.update(_db.transactions)
              ..where((t) => t.id.equals(anchor.id)))
            .write(TransactionsCompanion(copyGroupId: Value(const Uuid().v4())));
      }
    } catch (e, st) {
      _logger.e('SetTransactionSpaces failed', error: e, stackTrace: st);
      rethrow;
    }
  }
}