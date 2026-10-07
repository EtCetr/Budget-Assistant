/// Парсинг/формат денег (копейки в int, без double в хранении).
abstract final class ReceiptMoneyUtils {
  static int? parseKop(String text) {
    final t = text.trim().replaceAll(' ', '');
    if (t.isEmpty) return null;
    final parts = t.split(RegExp('[.,]'));
    if (parts.length == 1) {
      final r = int.tryParse(parts[0]);
      return r == null ? null : r * 100;
    }
    if (parts.length != 2) return null;
    final rub = int.tryParse(parts[0]);
    if (rub == null) return null;
    var kop = parts[1];
    if (kop.length > 2) kop = kop.substring(0, 2);
    final k = int.tryParse(kop.padRight(2, '0'));
    if (k == null) return null;
    return rub * 100 + k;
  }

  static String formatKop(int kop) {
    final sign = kop < 0 ? '-' : '';
    final a = kop.abs();
    return '$sign${a ~/ 100},${(a % 100).toString().padLeft(2, '0')}';
  }

  static String formatQty(double q) =>
      q == q.truncateToDouble() ? q.toStringAsFixed(0) : q.toString();

  static double? parseQty(String s) =>
      double.tryParse(s.trim().replaceAll(',', '.'));

  static String formatDateUtc(DateTime d) {
    final l = d.toLocal();
    final dd = l.day.toString().padLeft(2, '0');
    final mm = l.month.toString().padLeft(2, '0');
    final hh = l.hour.toString().padLeft(2, '0');
    final mi = l.minute.toString().padLeft(2, '0');
    return '$dd.$mm.${l.year} $hh:$mi';
  }
}