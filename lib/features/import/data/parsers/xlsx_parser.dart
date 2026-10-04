import 'dart:io';
import 'dart:convert';
import 'package:archive/archive.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/features/import/domain/entities/parsed_row.dart';
import 'package:budget_assistant/features/import/domain/entities/column_mapping.dart';
import 'import_file_parser.dart';

/// Парсер XLSX через package:archive (ручной OOXML-zip, как в экспорте 12.8).
/// Самозакрывающиеся ячейки &ltc .../&gt учитываются; колонки — по r="A1".
class XlsxParser implements ImportFileParser {
  final Logger _logger;
  XlsxParser({required Logger logger}) : _logger = logger;

  @override
  Future<ParseResult> parse({
    required String filePath,
    required ColumnMapping mapping,
  }) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        return ParseResult(rows: [], rawRows: [], totalRows: 0,
            error: 'Файл не найден: $filePath');
      }
      final bytes = await file.readAsBytes();
      final archive = ZipDecoder().decodeBytes(bytes);
      final sharedStrings = _readSharedStrings(archive);
      final sheetXml = _findSheetContent(archive);
      if (sheetXml == null) {
        return const ParseResult(rows: [], rawRows: [], totalRows: 0,
            error: 'Не удалось прочитать лист XLSX');
      }
      final rawRows = _parseSheetXml(sheetXml, sharedStrings);
      if (rawRows.isEmpty) {
        return const ParseResult(rows: [], rawRows: [], totalRows: 0,
            error: 'Файл пуст или содержит только заголовки');
      }
      final dbg = rawRows.take(30).toList();
      for (var i = 0; i < dbg.length; i++) {
        _logger.i('XLSXDBG[$i] ${dbg[i].join(' | ')}');
      }
      final m = _detectByHeaders(rawRows, mapping);
      final start = m.skipRows < rawRows.length ? m.skipRows : rawRows.length;
      final dataRows = rawRows.sublist(start);
      final rows = <ParsedRow>[];
      DateTime? periodStart;
      DateTime? periodEnd;
      for (var i = 0; i < dataRows.length; i++) {
        final cols = dataRows[i];
        try {
          final row = _parseRow(cols, i, m);
          if (row != null) {
            rows.add(row);
            if (periodStart == null || row.date.isBefore(periodStart)) {
              periodStart = row.date;
            }
            if (periodEnd == null || row.date.isAfter(periodEnd)) {
              periodEnd = row.date;
            }
          }
        } catch (e) {
          _logger.w('XLSX: пропущена строка ${i + 1}: $e');
        }
      }
      _logger.i('XLSX: распарсено ${rows.length} из ${dataRows.length} строк '
          '(колонки: дата=${m.dateColumnIndex}, сумма=${m.amountColumnIndex}, '
          'мерчант=${m.merchantColumnIndex}, hold=${m.holdColumnIndex}, '
          'skip=${m.skipRows})');
      return ParseResult(
        rows: rows,
        rawRows: dataRows,
        totalRows: dataRows.length,
        periodStart: periodStart,
        periodEnd: periodEnd,
      );
    } catch (e, st) {
      _logger.e('XlsxParser.parse failed', error: e, stackTrace: st);
      return ParseResult(rows: [], rawRows: [], totalRows: 0,
          error: 'Ошибка чтения XLSX: $e');
    }
  }

  /// Строка заголовка ищется по именам колонок; HOLD-колонка — ТА,
  /// где маркер HOLD реально встречается в данных (у Альфы «Дата проводки»).
  ColumnMapping _detectByHeaders(List<List<String>> rows, ColumnMapping m) {
    int? dateCol;
    int? amountCol;
    int? amountFallback;
    int? merchantCol;
    int? catCol;
    int? holdPosting;
    int? holdStatus;
    var headerRow = -1;
    final limit = rows.length < 60 ? rows.length : 60;
    for (var r = 0; r < limit; r++) {
      final row = rows[r];
      var fDate = false;
      var fAmount = false;
      var fMerchant = false;
      for (var i = 0; i < row.length; i++) {
        final low = row[i].toLowerCase().trim();
        if (low.isEmpty) continue;
        if (low.contains('дата операции') ||
            low.contains('дата транзакции') ||
            low == 'дата') {
          dateCol = i;
          fDate = true;
        } else if (low.contains('проводки')) {
          holdPosting = i;
        } else if (low.contains('статус')) {
          holdStatus = i;
        }
        if (low.contains('сумма')) {
          if (low.contains('операци') || low.contains('счета')) {
            amountCol = i;
            fAmount = true;
          } else {
            amountFallback = i;
          }
        }
        if (low.contains('описание') ||
            low.contains('контрагент') ||
            low.contains('мерчант') ||
            low.contains('наименование операции') ||
            low.contains('назначение')) {
          merchantCol = i;
          fMerchant = true;
        }
        if (low.contains('категория')) {
          catCol = i;
        }
      }
      if (fDate && fMerchant && (fAmount || amountFallback != null)) {
        headerRow = r;
        break;
      }
    }
    if (headerRow < 0) return m;
    amountCol ??= amountFallback;
    if (dateCol == null || amountCol == null || merchantCol == null) return m;
    int? holdCol;
    for (final candidate in [holdPosting, holdStatus]) {
      if (candidate == null) continue;
      final last =
          (headerRow + 26 < rows.length) ? headerRow + 26 : rows.length - 1;
      for (var r = headerRow + 1; r <= last; r++) {
        final row = rows[r];
        if (candidate < row.length &&
            row[candidate].trim().toUpperCase() == 'HOLD') {
          holdCol = candidate;
          break;
        }
      }
      if (holdCol != null) break;
    }
    return m.copyWith(
      dateColumnIndex: dateCol,
      amountColumnIndex: amountCol,
      merchantColumnIndex: merchantCol,
      categoryColumnIndex: catCol ?? m.categoryColumnIndex,
      holdColumnIndex: holdCol ?? m.holdColumnIndex,
      skipRows: headerRow + 1,
    );
  }

  List<String> _readSharedStrings(Archive archive) {
    final ssFile = archive.findFile('xl/sharedStrings.xml');
    if (ssFile == null) return [];
    final content = utf8.decode(ssFile.content as List<int>);
    final strings = <String>[];
    final siRegex = RegExp(r'<si\b[^>]*>(.*?)</si>', dotAll: true);
    final tRegex = RegExp(r'<t[^>]*>([^<]*)</t>');
    for (final si in siRegex.allMatches(content)) {
      final buf = StringBuffer();
      for (final t in tRegex.allMatches(si.group(1)!)) {
        buf.write(t.group(1) ?? '');
      }
      strings.add(buf.toString());
    }
    return strings;
  }

  String? _findSheetContent(Archive archive) {
    final sheet = archive.findFile('xl/worksheets/sheet1.xml');
    if (sheet == null) return null;
    return utf8.decode(sheet.content as List<int>);
  }

  int _colIndex(String letters) {
    var n = 0;
    for (final ch in letters.codeUnits) {
      if (ch >= 65 && ch <= 90) {
        n = n * 26 + (ch - 64);
      } else {
        break;
      }
    }
    return n - 1;
  }

  List<List<String>> _parseSheetXml(String xml, List<String> sharedStrings) {
    final rows = <List<String>>[];
    final rowRegex = RegExp(r'<row\b[^>]*>(.*?)</row>', dotAll: true);
    final cellRegex = RegExp(r'<c\b([^>]*?)(?:/>|>(.*?)</c>)', dotAll: true);
    final refRe = RegExp(r'r="([A-Z]+)\d+"');
    final typeRe = RegExp(r't="([^"]+)"');
    final vRe = RegExp(r'<v>([^<]*)</v>');
    final tRe = RegExp(r'<t[^>]*>([^<]*)</t>');
    for (final rowMatch in rowRegex.allMatches(xml)) {
      final cells = <String>[];
      for (final cm in cellRegex.allMatches(rowMatch.group(1)!)) {
        final attrs = cm.group(1) ?? '';
        final inner = cm.group(2) ?? '';
        final refM = refRe.firstMatch(attrs);
        final col = refM == null ? cells.length : _colIndex(refM.group(1)!);
        while (cells.length < col) {
          cells.add('');
        }
        final type = typeRe.firstMatch(attrs)?.group(1);
        String value;
        if (type == 's') {
          final v = vRe.firstMatch(inner)?.group(1) ?? '';
          final i = int.tryParse(v) ?? -1;
          value = (i >= 0 && i < sharedStrings.length) ? sharedStrings[i] : v;
        } else if (type == 'inlineStr') {
          value = tRe.firstMatch(inner)?.group(1) ?? '';
        } else {
          value = vRe.firstMatch(inner)?.group(1) ?? '';
        }
        cells.add(value);
      }
      if (cells.isNotEmpty) rows.add(cells);
    }
    return rows;
  }

  ParsedRow? _parseRow(List<String> cols, int rowIndex, ColumnMapping m) {
    if (cols.length <= m.amountColumnIndex ||
        cols.length <= m.dateColumnIndex ||
        cols.length <= m.merchantColumnIndex) {
      return null;
    }
    final dateStr = cols[m.dateColumnIndex].trim();
    final amountStr = cols[m.amountColumnIndex].trim();
    var merchant = cols[m.merchantColumnIndex].trim();
    // Альфа: «Категория: X.Текст» -> оставляем только текст.
    if (merchant.startsWith('Категория:')) {
      final dot = merchant.indexOf('.');
      if (dot > 0 && dot < merchant.length - 1) {
        merchant = merchant.substring(dot + 1).trim();
      }
    }
    if (dateStr.isEmpty || amountStr.isEmpty || merchant.isEmpty) return null;
    final date = _parseDate(dateStr, m.dateFormat);
    if (date == null) return null;
    final amountKopecks = _parseAmount(amountStr);
    if (amountKopecks == null) return null;
    var isHold = false;
    if (m.holdColumnIndex != null && m.holdColumnIndex! < cols.length) {
      isHold = cols[m.holdColumnIndex!].trim().toUpperCase() ==
          m.holdMarker.toUpperCase();
    }
    String? cat;
    if (m.categoryColumnIndex != null && m.categoryColumnIndex! < cols.length) {
      cat = cols[m.categoryColumnIndex!].trim();
      if (cat.isEmpty) cat = null;
    }
    return ParsedRow(
      rowIndex: rowIndex,
      date: date.toUtc(),
      amountKopecks: amountKopecks,
      merchantName: merchant,
      bankCategory: cat,
      isHold: isHold,
    );
  }

  DateTime? _parseDate(String v, String fmt) {
    final numDays = double.tryParse(v);
    if (numDays != null && numDays > 1000) {
      final base = DateTime(1899, 12, 30);
      return base.add(Duration(days: numDays.round()));
    }
    try {
      return DateFormat(fmt).parse(v);
    } catch (_) {}
    try {
      return DateFormat('dd.MM.yyyy').parse(v);
    } catch (_) {}
    try {
      return DateTime.parse(v);
    } catch (_) {
      return null;
    }
  }

  int? _parseAmount(String v) {
    try {
      var c = v.replaceAll(' ', '').replaceAll(' ', '')
          .replaceAll('₽', '').trim();
      final neg = c.startsWith('-') || c.startsWith('(');
      c = c.replaceAll('-', '').replaceAll('(', '').replaceAll(')', '');
      if (c.contains(',') && c.contains('.')) {
        c = c.replaceAll(',', '');
      } else if (c.contains(',')) {
        c = c.replaceAll(',', '.');
      }
      final d = double.parse(c);
      var k = (d * 100).round();
      if (neg) k = -k;
      return k;
    } catch (_) {
      return null;
    }
  }
}