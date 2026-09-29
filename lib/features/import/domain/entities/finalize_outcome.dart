import 'parsed_row.dart';

/// Созданная при финализации транзакция (ID + исходная строка).
class CreatedImportedTransaction {
  const CreatedImportedTransaction({required this.id, required this.row});
  final String id;
  final ParsedRow row;
}

/// Итог финализации импорта.
class FinalizeOutcome {
  const FinalizeOutcome({
    required this.created,
    required this.updatedExistingCount,
    required this.transfersCreatedCount,
    required this.balanceDeltaKopecks,
  });
  final List<CreatedImportedTransaction> created;
  final int updatedExistingCount;
  final int transfersCreatedCount;
  final int balanceDeltaKopecks;
}