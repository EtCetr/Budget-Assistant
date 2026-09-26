import '../entities/split_position_draft.dart';

/// Локальные черновики экрана разделения транзакции (ТОМ 2 §23.2).
abstract interface class SplitDraftsRepository {
  /// Позиции черновика, если он младше 24 часов; иначе null.
  Future<List<SplitPositionDraft>?> getFreshPositions(String transactionId);
  Future<void> savePositions(
    String transactionId,
    List<SplitPositionDraft> positions,
  );
  Future<void> deleteByTransaction(String transactionId);
}