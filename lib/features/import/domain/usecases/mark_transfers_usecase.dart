import '../entities/parsed_row.dart';
import '../entities/transfer_profile.dart';

/// Пометка переводов между своими/семейными счетами ТОЛЬКО при импорте,
/// без объединений: строка получает isTransfer и создастся type='transfer'.
/// Критерий (ИЛИ): телефон (последние 10 цифр) / >=2 из 3 токенов ФИО / маркер.
class MarkTransfersUseCase {
  static const List<String> markers = [
    'между счетами одного клиента',
    'внутрибанковский перевод между счетами',
    'перевод с договора',
    'на свой счёт',
    'на свой счет',
    'пополнение. система быстрых платежей',
  ];

  List<ParsedRow> call({
    required List<ParsedRow> rows,
    required TransferProfile profile,
  }) {
    final phones = profile
        .effectivePhones()
        .map(_digits)
        .where((p) => p.length >= 10)
        .map((p) => p.substring(p.length - 10))
        .toList();
    final names = profile.effectiveNames();
    return [
      for (final r in rows)
        r.copyWith(isTransfer: _isTransfer(r, phones, names)),
    ];
  }

  bool _isTransfer(ParsedRow r, List<String> phones, List<String> names) {
    final m = r.merchantName.toLowerCase();
    if (markers.any((k) => m.contains(k))) return true;
    final digits = _digits(r.merchantName);
    if (digits.length >= 10 &&
        phones.any((p) => digits.contains(p))) {
      return true;
    }
    for (final name in names) {
      if (_nameMatch(m, name)) return true;
    }
    return false;
  }

  /// >=2 из 3 токенов ФИО встречаются в мерчанте в любом порядке/регистре.
  bool _nameMatch(String merchant, String name) {
    final tokens = name
        .toLowerCase()
        .split(RegExp(r'[\s.]+'))
        .where((t) => t.length >= 3)
        .toList();
    if (tokens.isEmpty) return false;
    if (tokens.length < 2) return merchant.contains(tokens.first);
    var hits = 0;
    for (final t in tokens) {
      if (merchant.contains(t)) hits++;
    }
    return hits >= 2;
  }

  String _digits(String s) =>
      RegExp(r'\d').allMatches(s).map((m) => m.group(0)!).join();
}