import 'package:intl/intl.dart';
import 'package:budget_assistant/features/import/domain/entities/parsed_row.dart';

/// Текстовые парсеры форматов банковских выписок (текстовый движок Этапа 15).
/// Даты парсятся ВМЕСТЕ со временем, если оно есть в выписке.
class BankTextParsers {
  static String normalize(String s) {
    return s
        .replaceAll(' ', ' ')
        .replaceAll(RegExp('[ -​　]'), ' ')
        .replaceAll(RegExp('[–−‐‑‒]'), '-')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  static String? detectBank(String text) {
    final t = normalize(text).toLowerCase();
    if (t.contains('ozon банк') || t.contains('озон банк')) return 'ozon';
    if (t.contains('яндекс банк')) return 'yandex';
    if (t.contains('тбанк') || t.contains('tbank')) return 'tbank';
    if (t.contains('сбербанк') || t.contains('sberbank')) return 'sber';
    if (t.contains('втб') || t.contains('vtb')) return 'vtb';
    return null;
  }

  static List<ParsedRow> parse(String? bank, List<String> rawLines) {
    final lines = rawLines.map(normalize).where((l) => l.isNotEmpty).toList();
    final text = lines.join(' ');
    List<ParsedRow> rows;
    switch (bank) {
      case 'yandex':
        rows = _yandex(text);
        break;
      case 'tbank':
        rows = _tbank(text);
        break;
      case 'sber':
        rows = _sber(text);
        break;
      case 'vtb':
        rows = _vtb(text);
        break;
      case 'ozon':
        rows = _ozon(lines);
        break;
      default:
        rows = const [];
    }
    if (rows.length < 3 && lines.length > 15) {
      rows = _generic(lines);
    }
    return rows;
  }

  static int? _kop(String raw) {
    var s = raw.replaceAll(' ', '').replaceAll(',', '.');
    final neg = s.startsWith('-');
    s = s.replaceAll(RegExp(r'[+-]'), '');
    final d = double.tryParse(s);
    if (d == null) return null;
    final k = (d * 100).round();
    return neg ? -k : k;
  }

  static DateTime? _date(String v) {
    try {
      return DateFormat('dd.MM.yyyy').parse(v);
    } catch (_) {
      return null;
    }
  }

  /// Дата + время (HH:mm:ss или HH:mm) локальным временем выписки.
  static DateTime? _dt(String d, String t) {
    for (final f in ['dd.MM.yyyy HH:mm:ss', 'dd.MM.yyyy HH:mm']) {
      try {
        return DateFormat(f).parse('$d $t');
      } catch (_) {}
    }
    return _date(d);
  }

  static bool _hasSkip(String s) {
    const bad = [
      'страница',
      'продолжение на',
      'входящий остаток',
      'исходящий остаток',
      'итого списаний',
      'итого зачислений',
      'с уважением',
      'лицензия',
      'паспорт',
      'выписка по договору',
      'номер счёта',
    ];
    final low = s.toLowerCase();
    return bad.any((b) => low.contains(b));
  }

  // === Яндекс (время в выписке отсутствует) ===
  static final _yandexCut = RegExp(
      r'(Страница \d+ из \d+|Продолжение на следующей странице|Описание операции|Дата операции МСК|Сумма в валюте договора)',
      caseSensitive: false);

  static List<ParsedRow> _yandex(String text) {
    final re = RegExp(r'(\d{2}\.\d{2}\.\d{4})\s*([+-][\d ]+,\d{2})\s*₽');
    final rows = <ParsedRow>[];
    var idx = 0;
    var lastEnd = 0;
    for (final m in re.allMatches(text)) {
      var desc = text.substring(lastEnd, m.start).trim();
      lastEnd = m.end;
      final cuts = _yandexCut.allMatches(desc);
      if (cuts.isNotEmpty) {
        desc = desc.substring(cuts.last.end).trim();
      }
      final low = desc.toLowerCase();
      if (desc.isEmpty || desc.length > 200) continue;
      if (low.contains('итого') ||
          low.contains('с уважением') ||
          low.contains('остаток на')) {
        continue;
      }
      final date = _date(m.group(1)!);
      final kop = _kop(m.group(2)!);
      if (date == null || kop == null) continue;
      String? cat;
      if (low.contains('капитализация')) {
        cat = 'income';
      } else if (low.contains('между счетами одного клиента') ||
          low.contains('внутрибанковский')) {
        cat = 'transfer';
      }
      rows.add(ParsedRow(
        rowIndex: idx++,
        date: date.toUtc(),
        amountKopecks: kop,
        merchantName: desc,
        bankCategory: cat,
      ));
    }
    return rows;
  }

  // === Т-Банк: дата + HH:mm ===
  static List<ParsedRow> _tbank(String text) {
    final re = RegExp(
        r'(\d{2}\.\d{2}\.\d{4})\s*(\d{2}:\d{2})\s+(\d{2}\.\d{2}\.\d{4})\s*(\d{2}:\d{2})\s+([+-][\d ]+\.\d{2})\s*₽\s+([+-][\d ]+\.\d{2})\s*₽\s+(.+?)(?=\d{2}\.\d{2}\.\d{4}\s*\d{2}:\d{2}\s+\d{2}\.\d{2}\.\d{4}\s*\d{2}:\d{2}|АКЦИОНЕРНОЕ ОБЩЕСТВО|Пополнения:|Расходы:|$)');
    final rows = <ParsedRow>[];
    var idx = 0;
    for (final m in re.allMatches(text)) {
      final date = _dt(m.group(1)!, m.group(2)!);
      final kop = _kop(m.group(5)!);
      if (date == null || kop == null) continue;
      var desc = (m.group(7) ?? '').replaceAll(RegExp(r'\s*\d{4}$'), '').trim();
      if (desc.isEmpty || desc == '-') desc = 'Операция Т-Банк';
      String? cat;
      final d = desc.toLowerCase();
      if (d.contains('кэшбэк') || d.contains('кешбэк')) cat = 'income';
      rows.add(ParsedRow(
        rowIndex: idx++,
        date: date.toUtc(),
        amountKopecks: kop,
        merchantName: desc,
        bankCategory: cat,
      ));
    }
    return rows;
  }

  // === Сбер: расход без знака, доход с «+», дата + HH:mm ===
  static List<ParsedRow> _sber(String text) {
    final re = RegExp(
        r'(\d{2}\.\d{2}\.\d{4})\s*(\d{2}:\d{2})\s+([A-ZА-ЯЁa-zа-яё][^0-9]{2,40}?)\s+([+-]?[\d ]+,\d{2})\s+([+-]?[\d ]+,\d{2})\s+(\d{2}\.\d{2}\.\d{4})\s+(\d{6})\s+(.+?)(?=\d{2}\.\d{2}\.\d{4}\s*\d{2}:\d{2}|Заказано в|Дата формирования|Страница \d|$)');
    final rows = <ParsedRow>[];
    var idx = 0;
    for (final m in re.allMatches(text)) {
      final date = _dt(m.group(1)!, m.group(2)!);
      final rawAmount = m.group(4)!;
      final base = _kop(rawAmount);
      if (date == null || base == null) continue;
      final kop = rawAmount.trim().startsWith('+') ? base.abs() : -base.abs();
      rows.add(ParsedRow(
        rowIndex: idx++,
        date: date.toUtc(),
        amountKopecks: kop,
        merchantName: m.group(8)!.trim(),
        bankCategory: m.group(3)!.trim(),
        bankTransactionId: m.group(7),
      ));
    }
    return rows;
  }

  // === ВТБ: дата + HH:mm:ss ===
  static List<ParsedRow> _vtb(String text) {
    final re = RegExp(
        r'(\d{2}\.\d{2}\.\d{4})\s*(\d{2}:\d{2}:\d{2})\s+(\d{2}\.\d{2}\.\d{4})\s+([+-]?\d+(?:\.\d+)?)\s+RUB\s+([+-]?\d+(?:\.\d+)?)\s+(\d+(?:\.\d+)?)\s+RUB\s+(.+?)(?=\d{2}\.\d{2}\.\d{4}\s*\d{2}:\d{2}:\d{2}|Спасибо, что|Всегда ваш|Страница \d|$)');
    const prefix = 'Оплата товаров и услуг.';
    final rows = <ParsedRow>[];
    var idx = 0;
    for (final m in re.allMatches(text)) {
      final date = _dt(m.group(1)!, m.group(2)!);
      final kop = _kop(m.group(4)!);
      if (date == null || kop == null) continue;
      var desc = (m.group(7) ?? '').trim();
      if (desc.startsWith(prefix)) {
        desc = desc.substring(prefix.length).trim();
      }
      while (desc.endsWith('.')) {
        desc = desc.substring(0, desc.length - 1).trim();
      }
      if (desc.isEmpty) continue;
      rows.add(ParsedRow(
        rowIndex: idx++,
        date: date.toUtc(),
        amountKopecks: kop,
        merchantName: desc,
      ));
    }
    return rows;
  }

  // === Ozon: старт-строка = дата+время + документ + начало назначения;
  // === суммы приходят одной строкой дважды («- 229.00 ₽ - 229.00 ₽»).
  static List<ParsedRow> _ozon(List<String> lines) {
    final startRe = RegExp(r'^(\d{2}\.\d{2}\.\d{4} \d{2}:\d{2}:\d{2}) (\d+) (.+)$');
    final amount2Re = RegExp(r'^([+-]) ([\d ]+\.\d{2}) ₽ ([+-]) ([\d ]+\.\d{2}) ₽$');
    final amount1Re = RegExp(r'^([+-]) ([\d ]+\.\d{2}) ₽$');
    final rows = <ParsedRow>[];
    var idx = 0;
    DateTime? date;
    String? doc;
    final purpose = <String>[];
    for (final raw in lines) {
      final line = raw.trim();
      if (line.isEmpty) continue;
      final sm = startRe.firstMatch(line);
      if (sm != null) {
        final stamp = sm.group(1)!;
        date = _dt(stamp.substring(0, 10), stamp.substring(11));
        doc = sm.group(2);
        purpose
          ..clear()
          ..add(sm.group(3)!);
        continue;
      }
      if (date == null) continue;
      final a2 = amount2Re.firstMatch(line);
      final a1 = a2 == null ? amount1Re.firstMatch(line) : null;
      if (a2 != null || a1 != null) {
        final mm = (a2 ?? a1)!;
        final kop = _kop(mm.group(2)!);
        if (kop == null) continue;
        final sign = mm.group(1) == '-' ? -1 : 1;
        final p = purpose.join(' ').replaceAll(RegExp(r'\s+'), ' ').trim();
        rows.add(ParsedRow(
          rowIndex: idx++,
          date: date.toUtc(),
          amountKopecks: sign * kop.abs(),
          merchantName: p.isEmpty ? 'Операция Ozon Банк' : p,
          bankTransactionId: doc,
        ));
        date = null;
        doc = null;
        purpose.clear();
        continue;
      }
      purpose.add(line);
    }
    return rows;
  }

  // === Универсальный fallback ===
  static List<ParsedRow> _generic(List<String> lines) {
    final dateRe = RegExp(r'\d{2}\.\d{2}\.\d{4}');
    final amountRe = RegExp(r'[+-]\d[\d ]*[.,]\d{2}');
    final rows = <ParsedRow>[];
    var idx = 0;
    for (final line in lines) {
      if (_hasSkip(line)) continue;
      final dm = dateRe.firstMatch(line);
      if (dm == null) continue;
      final amounts = amountRe.allMatches(line).toList();
      if (amounts.isEmpty) continue;
      final amountStr = amounts.last.group(0)!;
      final kop = _kop(amountStr);
      final date = _date(dm.group(0)!);
      if (kop == null || date == null) continue;
      var merchant = line
          .replaceFirst(dm.group(0)!, ' ')
          .replaceFirst(amountStr, ' ')
          .replaceAll(RegExp(r'₽|руб\.?|RUB', caseSensitive: false), ' ')
          .replaceAll(RegExp(r'\s+'), ' ')
          .trim();
      if (merchant.length < 3) continue;
      rows.add(ParsedRow(
        rowIndex: idx++,
        date: date.toUtc(),
        amountKopecks: kop,
        merchantName: merchant,
      ));
    }
    return rows;
  }
}