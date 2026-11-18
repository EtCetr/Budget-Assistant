import 'package:budget_assistant/core/enums/transaction_enums.dart';
import 'package:budget_assistant/features/receipts/domain/dtos/receipt_category_lookup.dart';
import 'package:budget_assistant/features/receipts/domain/dtos/receipt_offer_settings.dart';
import 'package:budget_assistant/features/receipts/domain/dtos/transaction_match_candidate.dart';
import 'package:budget_assistant/features/receipts/domain/entities/receipt.dart';
import 'package:budget_assistant/features/receipts/domain/entities/receipt_item.dart';
import 'package:budget_assistant/features/receipts/domain/repositories/receipts_repository.dart';
import 'package:budget_assistant/features/transactions/domain/entities/split_position_draft.dart';

/// Этап 24: заглушка репозитория чеков для доменных тестов.
/// Деньги — целые копейки, даты — UTC.
class FakeReceiptsRepository implements ReceiptsRepository {
  final Map<String, Receipt> receipts = <String, Receipt>{};
  final Map<String, List<ReceiptItem>> items = <String, List<ReceiptItem>>{};

  List<TransactionMatchCandidate> matchCandidates =
      <TransactionMatchCandidate>[];
  List<ReceiptCategoryLookup> categories = <ReceiptCategoryLookup>[];
  List<SplitPositionDraft>? splitDraft;

  ReceiptOfferSettings offerSettings = const ReceiptOfferSettings(
    autoOfferNaming: true,
    offerNamingCount: 0,
    autoOfferSplit: true,
    offerSplitCount: 0,
    syncImagesToCloud: false,
  );

  /// Если задано — любой метод бросает эту ошибку.
  Object? error;

  /// Отдельная ошибка привязки (hold-транзакция).
  Object? linkError;

  final List<String> calls = <String>[];
  final List<Receipt> savedReceipts = <Receipt>[];
  final List<({String receiptId, int count})> savedItems =
      <({String receiptId, int count})>[];
  final List<({String receiptId, String transactionId})> links =
      <({String receiptId, String transactionId})>[];
  final List<({String id, String status})> statusUpdates =
      <({String id, String status})>[];
  final List<bool> namingDecisions = <bool>[];
  final List<bool> splitDecisions = <bool>[];
  final List<({String transactionId, int count})> savedSplitDrafts =
      <({String transactionId, int count})>[];
  final List<({
    String receiptId,
    String transactionId,
    String actorUserId,
    List<SplitPositionDraft> positions,
  })> appliedSplits = <({
    String receiptId,
    String transactionId,
    String actorUserId,
    List<SplitPositionDraft> positions,
  })>[];

  void _enter(String name) {
    calls.add(name);
    final e = error;
    if (e != null) throw e;
  }

  @override
  Future<void> createReceipt(Receipt receipt, List<ReceiptItem> list) async {
    _enter('createReceipt');
    receipts[receipt.id] = receipt;
    items[receipt.id] = list;
  }

  @override
  Future<void> updateReceipt(Receipt receipt, List<ReceiptItem> list) async {
    _enter('updateReceipt');
    receipts[receipt.id] = receipt;
    items[receipt.id] = list;
  }

  @override
  Future<void> deleteReceipt(String id) async {
    _enter('deleteReceipt');
    receipts.remove(id);
    items.remove(id);
  }

  @override
  Future<Receipt?> getReceiptById(String id) async {
    _enter('getReceiptById');
    return receipts[id];
  }

  @override
  Future<List<Receipt>> getReceiptsByUser(String userId) async {
    _enter('getReceiptsByUser');
    return receipts.values.where((r) => r.userId == userId).toList();
  }

  @override
  Future<List<ReceiptItem>> getItemsByReceiptId(String receiptId) async {
    _enter('getItemsByReceiptId');
    return items[receiptId] ?? const <ReceiptItem>[];
  }

  @override
  Future<void> updateReceiptStatus(String id, String status) async {
    _enter('updateReceiptStatus');
    statusUpdates.add((id: id, status: status));
    final r = receipts[id];
    if (r != null) receipts[id] = r.copyWith(status: status);
  }

  @override
  Future<void> saveReceipt(Receipt receipt) async {
    _enter('saveReceipt');
    savedReceipts.add(receipt);
    receipts[receipt.id] = receipt;
  }

  @override
  Future<void> saveItems(String receiptId, List<ReceiptItem> list) async {
    _enter('saveItems');
    savedItems.add((receiptId: receiptId, count: list.length));
    items[receiptId] = list;
  }

  @override
  Future<List<TransactionMatchCandidate>> findMatchCandidates({
    required int totalKop,
    required DateTime dateUtc,
  }) async {
    _enter('findMatchCandidates');
    return matchCandidates;
  }

  @override
  Future<void> linkReceiptToTransaction({
    required String receiptId,
    required String transactionId,
  }) async {
    _enter('linkReceiptToTransaction');
    final e = linkError;
    if (e != null) throw e;
    links.add((receiptId: receiptId, transactionId: transactionId));
    final r = receipts[receiptId];
    if (r != null) {
      receipts[receiptId] =
          r.copyWith(transactionId: transactionId, status: 'matched');
    }
  }

  @override
  Future<List<ReceiptCategoryLookup>> getExpenseCategories({
    required String? spaceId,
  }) async {
    _enter('getExpenseCategories');
    return categories;
  }

  @override
  Future<ReceiptOfferSettings> getReceiptOfferSettings(String userId) async {
    _enter('getReceiptOfferSettings');
    return offerSettings;
  }

  @override
  Future<void> recordNamingDecision(
    String userId, {
    required bool accepted,
  }) async {
    _enter('recordNamingDecision');
    namingDecisions.add(accepted);
  }

  @override
  Future<List<SplitPositionDraft>?> getFreshSplitDraft(
    String transactionId,
  ) async {
    _enter('getFreshSplitDraft');
    return splitDraft;
  }

  @override
  Future<void> saveSplitDraft(
    String transactionId,
    List<SplitPositionDraft> positions,
  ) async {
    _enter('saveSplitDraft');
    savedSplitDrafts.add((transactionId: transactionId, count: positions.length));
    splitDraft = positions;
  }

  @override
  Future<void> applyReceiptSplit({
    required String receiptId,
    required String transactionId,
    required String actorUserId,
    required List<SplitPositionDraft> positions,
  }) async {
    _enter('applyReceiptSplit');
    appliedSplits.add((
      receiptId: receiptId,
      transactionId: transactionId,
      actorUserId: actorUserId,
      positions: positions,
    ));
    splitDraft = null;
  }

  @override
  Future<void> recordSplitDecision(
    String userId, {
    required bool accepted,
  }) async {
    _enter('recordSplitDecision');
    splitDecisions.add(accepted);
  }
}

/// Фабрика чека для тестов (копейки, UTC).
Receipt makeReceipt({
  required String id,
  String userId = 'u1',
  String? spaceId,
  String? transactionId,
  String storeName = 'Пятёрочка',
  int totalAmount = 10000,
  DateTime? receiptDate,
  String status = 'draft',
  String currency = 'RUB',
}) =>
    Receipt(
      id: id,
      userId: userId,
      spaceId: spaceId,
      transactionId: transactionId,
      storeName: storeName,
      totalAmount: totalAmount,
      receiptDate: receiptDate ?? DateTime.utc(2026, 7, 15, 12),
      status: status,
      currency: currency,
      createdAt: DateTime.utc(2026, 7, 15),
      updatedAt: DateTime.utc(2026, 7, 15),
      syncStatus: SyncStatus.pending,
    );

/// Фабрика позиции чека для тестов.
ReceiptItem makeReceiptItem({
  required String id,
  String receiptId = 'r1',
  String originalName = 'Молоко',
  String? normalizedName,
  double quantity = 1,
  int unitPrice = 5000,
  int totalPrice = 5000,
  String? categoryId,
  bool isExcluded = false,
}) =>
    ReceiptItem(
      id: id,
      receiptId: receiptId,
      originalName: originalName,
      normalizedName: normalizedName,
      quantity: quantity,
      unitPrice: unitPrice,
      totalPrice: totalPrice,
      categoryId: categoryId,
      isExcluded: isExcluded,
      createdAt: DateTime.utc(2026, 7, 15),
      updatedAt: DateTime.utc(2026, 7, 15),
      syncStatus: SyncStatus.pending,
    );