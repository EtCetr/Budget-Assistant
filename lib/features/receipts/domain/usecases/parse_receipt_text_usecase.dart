import 'package:logger/logger.dart';
import '../dtos/parsed_item_draft.dart';
import '../dtos/parsed_receipt_draft.dart';

/// Эвристический разбор OCR-текста чека:
/// - строка с ценой на конце -> позиция (qty=1, unit=total);
/// - строка с «итого/всего/total» -> сумма чека;
/// - первая строка без цены -> магазин.
class ParseReceiptTextUseCase {
  final Logger _logger;
  ParseReceiptTextUseCase(this._logger);

  static final _priceRe = RegExp(r'(\d[\d\s ]*[.,]\d{2})\s*$');
  static final _totalRe = RegExp(r'(итого|всего|total|сумма)', caseSensitive: false);

  ParsedReceiptDraft call(String text) {
    try {
      final items = <ParsedItemDraft>[];
      int? totalKop;
      String? storeName;
      final lines = text.split('\n').map((l) => l.trim()).where((l) => l.isNotEmpty).toList();
      for (final line in lines) {
        final isTotal = _totalRe.hasMatch(line);
        final m = _priceRe.firstMatch(line);
        if (m != null) {
          final kop = _parseKop(m.group(1)!);
          if (kop == null) continue;
          if (isTotal) {
            totalKop = kop;
          } else {
            final name = line.substring(0, m.start).replaceAll(RegExp(r'[\-\*\u2022]+$'), '').trim();
            if (name.length > 1) {
              items.add(ParsedItemDraft(name: name, quantity: 1.0, unitPriceKop: kop, totalPriceKop: kop));
            }
          }
        } else if (storeName == null && line.length > 2 && !RegExp(r'^[\d\s.,:%]+$').hasMatch(line)) {
          storeName = line;
        }
      }
      return ParsedReceiptDraft(storeName: storeName, totalKop: totalKop, items: items);
    } catch (e, stack) {
      _logger.w('ParseReceiptText failed: $e', stackTrace: stack);
      return const ParsedReceiptDraft(items: []);
    }
  }

  int? _parseKop(String s) {
    final v = double.tryParse(s.replaceAll(' ', '').replaceAll(',', '.'));
    return v == null ? null : (v * 100).round();
  }
}