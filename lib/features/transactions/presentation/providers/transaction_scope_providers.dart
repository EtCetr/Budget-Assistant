import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import '../../domain/models/transaction_scope.dart';
import '../../domain/usecases/add_transaction_copies_usecase.dart';
import '../../domain/usecases/set_transaction_spaces_usecase.dart';

final addTransactionCopiesUseCaseProvider =
    Provider<AddTransactionCopiesUseCase>(
  (ref) => AddTransactionCopiesUseCase(db: AppDatabase(), logger: Logger()),
);

final setTransactionSpacesUseCaseProvider =
    Provider<SetTransactionSpacesUseCase>(
  (ref) => SetTransactionSpacesUseCase(
    db: AppDatabase(),
    logger: Logger(),
    addCopies: ref.watch(addTransactionCopiesUseCaseProvider),
  ),
);

/// Текущий состав группы копий транзакции (для шита «Пространство»).
final transactionGroupScopesProvider =
    FutureProvider.autoDispose.family<TransactionGroupScopes, String>(
        (ref, transactionId) async {
  final db = AppDatabase();
  final source = await (db.select(db.transactions)
        ..where((t) => t.id.equals(transactionId)))
      .getSingleOrNull();
  if (source == null) {
    return const TransactionGroupScopes(personal: true, spaceIds: {});
  }
  final gid = source.copyGroupId;
  final group = gid == null
      ? [source]
      : await (db.select(db.transactions)
            ..where((t) => t.copyGroupId.equals(gid)))
          .get();
  return TransactionGroupScopes(
    personal: group.any((r) => r.spaceId == null),
    spaceIds: group
        .where((r) => r.spaceId != null)
        .map((r) => r.spaceId!)
        .toSet(),
    groupId: gid,
  );
});