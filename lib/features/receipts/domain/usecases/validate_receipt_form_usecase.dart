import '../dtos/parsed_item_draft.dart';
import '../dtos/receipt_validation_result.dart';

/// Валидация формы чека перед confirm (сумма позиций == итог, копейки в int).
class ValidateReceiptFormUseCase {
  ReceiptValidationResult call({
    required String storeName,
    required DateTime dateUtc,
    required int totalKop,
    required List<ParsedItemDraft> items,
  }) {
    final errors = <String>[];
    if (storeName.trim().isEmpty) errors.add('store_name_empty');
    if (dateUtc.isAfter(DateTime.now().toUtc().add(const Duration(minutes: 5)))) {
      errors.add('date_future');
    }
    if (totalKop <= 0) errors.add('total_nonpositive');
    for (final it in items) {
      if (it.name.trim().isEmpty) errors.add('item_name_empty');
      if (it.totalPriceKop <= 0) errors.add('item_price_nonpositive');
    }
    final sum = items.fold<int>(0, (acc, it) => acc + it.totalPriceKop);
    if (items.isNotEmpty && sum != totalKop) errors.add('sum_mismatch');
    return ReceiptValidationResult(errorCodes: errors);
  }
}