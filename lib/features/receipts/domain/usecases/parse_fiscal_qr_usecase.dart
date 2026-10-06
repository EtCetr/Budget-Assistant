import 'dart:convert';
import 'package:logger/logger.dart';
import '../dtos/fiscal_qr_data.dart';

/// Разбор сырой строки фискального QR: t=дата, s=сумма, fn/fp/i/n=фискальные признаки.
/// Формат даты: yyyyMMddTHHmmss (локальное время чека -> храним UTC-момент как есть).
class ParseFiscalQrUseCase {
  final Logger _logger;
  ParseFiscalQrUseCase(this._logger);

  FiscalQrData? call(String raw) {
    try {
      final pairs = <String, String>{};
      for (final part in raw.split('&')) {
        final kv = part.split('=');
        if (kv.length == 2) pairs[kv[0]] = Uri.decodeComponent(kv[1]);
      }
      final t = pairs['t'];
      final s = pairs['s'];
      if (t == null || s == null) return null;

      DateTime? date;
      if (t.length == 15 && t[8] == 'T') {
        final y = int.tryParse(t.substring(0, 4));
        final mo = int.tryParse(t.substring(4, 6));
        final d = int.tryParse(t.substring(6, 8));
        final h = int.tryParse(t.substring(9, 11));
        final mi = int.tryParse(t.substring(11, 13));
        final se = int.tryParse(t.substring(13, 15));
        if (y != null && mo != null && d != null && h != null && mi != null && se != null) {
          date = DateTime.utc(y, mo, d, h, mi, se);
        }
      }
      date ??= DateTime.tryParse(t)?.toUtc();
      if (date == null) return null;

      final sum = double.tryParse(s.replaceAll(',', '.'));
      if (sum == null) return null;
      final totalKop = (sum * 100).round();

      final fiscal = <String, String>{
        for (final k in ['fn', 'fp', 'i', 'n'])
          if (pairs[k] != null) k: pairs[k]!,
      };
      return FiscalQrData(
        dateUtc: date,
        totalKop: totalKop,
        fiscalDataJson: fiscal.isEmpty ? null : jsonEncode(fiscal),
        raw: raw,
      );
    } catch (e, stack) {
      _logger.w('ParseFiscalQr failed: $e', stackTrace: stack);
      return null;
    }
  }
}