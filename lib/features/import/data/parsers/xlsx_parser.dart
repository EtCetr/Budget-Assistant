import 'dart:io';
import 'dart:convert';

import 'package:archive/archive.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/features/import/domain/entities/parsed_row.dart';
import 'package:budget_assistant/features/import/domain/entities/column_mapping.dart';
import 'import_file_parser.dart';

/// Парсер XLSX через package:archive (ручной OOXML-zip, как в экспорте 12.8).
/// Не требует пакета excel — избегаем конфликтов версий archive.
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
        // ignore: prefer_const_constructors
        return ParseResult(rows: [], rawRows: [], totalRows: 0,
            error: 'Файл не найден: $filePath');
      }

      final bytes = await file.readAsBytes();
      final archive = ZipDecoder().decodeBytes(bytes);

      // Читаем shared strings
      final sharedStrings = _readSharedStrings(archive);

      // Читаем первый лист
      final sheetXml = _findSheetContent(archive);
      if (sheetXml == null) {
        // ignore: prefer_const_constructors
                return const ParseResult(rows: [], rawRows: [], totalRows: 0,
            error: 'Не удалось прочитать лист XLSX');
      }

      final rawRows = _parseSheetXml(sheetXml, sharedStrings);

      if (rawRows.length <= mapping.skipRows) {
        return const ParseResult(rows: [], rawRows: [], totalRows: 0,
            error: 'Файл пуст или содержит только заголовки');
      }

      final dataRows = rawRows.sublist(mapping.skipRows);
      final rows = <ParsedRow>[];
      DateTime? periodStart;
      DateTime? periodEnd;

      for (var i = 0; i < dataRows.length; i++) {
        final cols = dataRows[i];
        try {
          final row = _parseRow(cols, i, mapping);
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

      _logger.i('XLSX: распарсено ${rows.length} из ${dataRows.length} строк');
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

  List<String> _readSharedStrings(Archive archive) {
    final ssFile = archive.findFile('xl/sharedStrings.xml');
    if (ssFile == null) {

      return [];

    }
    final content = utf8.decode(ssFile.content as List<int>);
    final strings = <String>[];
    final regex = RegExp(r'<t[^>]*>([^<]*)</t>');
    for (final match in regex.allMatches(content)) {
      strings.add(match.group(1) ?? '');
    }
    return strings;
  }

  String? _findSheetContent(Archive archive) {
    final sheet = archive.findFile('xl/worksheets/sheet1.xml');
    if (sheet == null) {

      return null;

    }
    return utf8.decode(sheet.content as List<int>);
  }

  List<List<String>> _parseSheetXml(String xml, List<String> sharedStrings) {
    final rows = <List<String>>[];
    final rowRegex = RegExp(r'<row[^>]*>(.*?)</row>', dotAll: true);
    final cellRegex = RegExp(r'<c[^>]*(?:t="([^"]*)")?[^>]*r="[A-Z]+(\d+)"[^>]*>(?:<v>([^<]*)</v>)?</c>');

    for (final rowMatch in rowRegex.allMatches(xml)) {
      final rowContent = rowMatch.group(1) ?? '';
      final cells = <String>[];
      for (final cellMatch in cellRegex.allMatches(rowContent)) {
        final type = cellMatch.group(1);
        final value = cellMatch.group(3) ?? '';
        if (type == 's') {
          final idx = int.tryParse(value) ?? 0;
          cells.add(idx < sharedStrings.length ? sharedStrings[idx] : value);
        } else {
          cells.add(value);
        }
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
    final merchant = cols[m.merchantColumnIndex].trim();
    if (dateStr.isEmpty || amountStr.isEmpty || merchant.isEmpty) {

      return null;

    }

    final date = _parseDate(dateStr, m.dateFormat);
    if (date == null) {

      return null;

    }
    final amountKopecks = _parseAmount(amountStr);
    if (amountKopecks == null) {

      return null;

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
    );
  }

  DateTime? _parseDate(String v, String fmt) {
    // Excel хранит даты как числа (дни от 1900-01-01)
    final numDays = double.tryParse(v);
    if (numDays != null && numDays > 1) {
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
      var c = v.replaceAll(' ', '').replaceAll('\u00A0', '')
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
    } catch (_) { return null; }
  }
}