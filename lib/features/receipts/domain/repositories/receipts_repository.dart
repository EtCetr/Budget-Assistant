import '../dtos/receipt_category_lookup.dart';
import '../dtos/receipt_offer_settings.dart';
import '../dtos/transaction_match_candidate.dart';
import '../entities/receipt.dart';
import '../entities/receipt_item.dart';
import 'package:budget_assistant/features/transactions/domain/entities/split_position_draft.dart';

abstract class ReceiptsRepository {
  Future<void> createReceipt(Receipt receipt, List<ReceiptItem> items);
  Future<void> updateReceipt(Receipt receipt, List<ReceiptItem> items);
  Future<void> deleteReceipt(String id);
  Future<Receipt?> getReceiptById(String id);
  Future<List<Receipt>> getReceiptsByUser(String userId);
  Future<List<ReceiptItem>> getItemsByReceiptId(String receiptId);
  Future<void> updateReceiptStatus(String id, String status);

  /// Этап 16.4: обновление только строки чека (метаданные).
  Future<void> saveReceipt(Receipt receipt);

  /// Этап 16.4: атомарная замена позиций чека.
  Future<void> saveItems(String receiptId, List<ReceiptItem> items);

  /// Этап 16.4: кандидаты матчинга (type=expense, +/-48ч, +/-5%).
  Future<List<TransactionMatchCandidate>> findMatchCandidates({
    required int totalKop,
    required DateTime dateUtc,
  });

  /// Этап 16.4: привязка чека к транзакции.
  /// Бросает StateError, если транзакция audit_status='pending' (ТЗ 6.3.23.5).
  Future<void> linkReceiptToTransaction({
    required String receiptId,
    required String transactionId,
  });

  /// Этап 16.4: категории expense (space = current OR NULL).
  Future<List<ReceiptCategoryLookup>> getExpenseCategories({
    required String? spaceId,
  });

  /// Этап 16.4: настройки спама/чеков.
  Future<ReceiptOfferSettings> getReceiptOfferSettings(String userId);

  /// Этап 16.4: защита от спама именования (ТЗ 6.3.49.4).
  Future<void> recordNamingDecision(String userId, {required bool accepted});

  /// Этап 16.5: свежий (<24 ч) черновик разделения (split_drafts).
  Future<List<SplitPositionDraft>?> getFreshSplitDraft(String transactionId);

  /// Этап 16.5: автосохранение черновика разделения.
  Future<void> saveSplitDraft(
      String transactionId, List<SplitPositionDraft> positions);

  /// Этап 16.5: атомарное применение разделения чека:
  /// is_split=TRUE + transaction_splits + удаление черновика.
  Future<void> applyReceiptSplit({
    required String receiptId,
    required String transactionId,
    required String actorUserId,
    required List<SplitPositionDraft> positions,
  });

  /// Этап 16.5: спам-защита предложений разделения (ТЗ 6.3.48.8).
  Future<void> recordSplitDecision(String userId, {required bool accepted});
}