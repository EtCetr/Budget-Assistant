import '../entities/receipt.dart';
import '../entities/receipt_item.dart';

abstract class ReceiptsRepository {
  Future<void> createReceipt(Receipt receipt, List<ReceiptItem> items);
  Future<void> updateReceipt(Receipt receipt, List<ReceiptItem> items);
  Future<void> deleteReceipt(String id);
  Future<Receipt?> getReceiptById(String id);
  Future<List<Receipt>> getReceiptsByUser(String userId);
  Future<List<ReceiptItem>> getItemsByReceiptId(String receiptId);
  Future<void> updateReceiptStatus(String id, String status);
}