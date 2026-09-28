import 'dart:convert';
import 'dart:io';

import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/features/import/domain/entities/parsed_row.dart';
import 'package:budget_assistant/features/import/domain/entities/column_mapping.dart';
import 'import_file_parser.dart';

/// Парсер CSV-файлов банковских выписок.
/// Использует dart:convert (без внешних зависимостей).
class CsvParser implements ImportFileParser {
  final Logger _logger;

  CsvParser({required Logger logger}) : _logger = logger;

  @override
  Future<ParseResult> parse({
    required String filePath,
    required ColumnMapping mapping,
  }) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        return ParseResult(
          rows: [],
          rawRows: [],
          totalRows: 0,
          error: 'Файл не найден: $filePath',
        );
      }

      final encoding = _resolveEncoding(mapping.encoding);
      final content = await file.readAsString(encoding: encoding);
      final lines = LineSplitter.split(content).toList();

      if (lines.length <= mapping.skipRows) {
        return const ParseResult(
          rows: [],
          rawRows: [],
          totalRows: 0,
          error: 'Файл пуст или содержит только заголовки',
        );
      }

      // Пропускаем строки заголовков банка
      final dataLines = lines.sublist(mapping.skipRows);
      final rawRows = dataLines
          .map((line) => _splitCsvLine(line, mapping.csvSeparator))
          .toList();

      final rows = <ParsedRow>[];
      DateTime? periodStart;
      DateTime? periodEnd;

      for (var i = 0; i < rawRows.length; i++) {
        final cols = rawRows[i];
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
          _logger.w('CSV: пропущена строка ${i + 1}: $e');
        }
      }

      _logger.i('CSV: распарсено ${rows.length} из ${rawRows.length} строк');
      return ParseResult(
        rows: rows,
        rawRows: rawRows,
        totalRows: rawRows.length,
        periodStart: periodStart,
        periodEnd: periodEnd,
      );
    } catch (e, st) {
      _logger.e('CsvParser.parse failed', error: e, stackTrace: st);
      return ParseResult(
        rows: [],
        rawRows: [],
        totalRows: 0,
        error: 'Ошибка чтения CSV: $e',
      );
    }
  }

  ParsedRow? _parseRow(
    List<String> cols,
    int rowIndex,
    ColumnMapping mapping,
  ) {
    if (cols.length <= mapping.amountColumnIndex ||
        cols.length <= mapping.dateColumnIndex ||
        cols.length <= mapping.merchantColumnIndex) {
      return null;
    }

    final dateStr = cols[mapping.dateColumnIndex].trim();
    final amountStr = cols[mapping.amountColumnIndex].trim();
    final merchant = cols[mapping.merchantColumnIndex].trim();

    if (dateStr.isEmpty || amountStr.isEmpty || merchant.isEmpty) return null;

    final date = _parseDate(dateStr, mapping.dateFormat);
    if (date == null) return null;

    final amountKopecks = _parseAmount(amountStr, mapping.expenseIsNegative);
    if (amountKopecks == null) return null;

    String? bankCategory;
    if (mapping.categoryColumnIndex != null &&
        mapping.categoryColumnIndex! < cols.length) {
      bankCategory = cols[mapping.categoryColumnIndex!].trim();
      if (bankCategory.isEmpty) bankCategory = null;
    }

    String? comment;
    if (mapping.commentColumnIndex != null &&
        mapping.commentColumnIndex! < cols.length) {
      comment = cols[mapping.commentColumnIndex!].trim();
      if (comment.isEmpty) comment = null;
    }

    String? currency;
    if (mapping.currencyColumnIndex != null &&
        mapping.currencyColumnIndex! < cols.length) {
      currency = cols[mapping.currencyColumnIndex!].trim();
      if (currency.isEmpty) currency = null;
    }

    return ParsedRow(
      rowIndex: rowIndex,
      date: date.toUtc(),
      amountKopecks: amountKopecks,
      merchantName: merchant,
      bankCategory: bankCategory,
      comment: comment,
      originalCurrency: currency,
    );
  }

  /// Разбивает CSV-строку с учётом кавычек.
  List<String> _splitCsvLine(String line, String separator) {
    final result = <String>[];
    final buffer = StringBuffer();
    var inQuotes = false;

    for (var i = 0; i < line.length; i++) {
      final char = line[i];
      if (char == '"') {
        if (inQuotes && i + 1 < line.length && line[i + 1] == '"') {
          buffer.write('"');
          i++;
        } else {
          inQuotes = !inQuotes;
        }
      } else if (char == separator && !inQuotes) {
        result.add(buffer.toString());
        buffer.clear();
      } else {
        buffer.write(char);
      }
    }
    result.add(buffer.toString());
    return result;
  }

  DateTime? _parseDate(String value, String format) {
    try {
      final fmt = DateFormat(format);
      return fmt.parse(value);
    } catch (_) {
      // Fallback: dd.MM.yyyy
      try {
        return DateFormat('dd.MM.yyyy').parse(value);
      } catch (_) {
        // Fallback: yyyy-MM-dd
        try {
          return DateTime.parse(value);
        } catch (_) {
          return null;
        }
      }
    }
  }

  /// Парсит сумму в копейки.
  /// "-2 100,50" → -210050
  /// "1 500.00" → 150000
  int? _parseAmount(String value, bool expenseIsNegative) {
    try {
      var cleaned = value
          .replaceAll(' ', '')
          .replaceAll('\u00A0', '') // non-breaking space
          .replaceAll('₽', '')
          .replaceAll('руб.', '')
          .replaceAll('руб', '')
          .trim();

      // Определяем знак
      final isNegative = cleaned.startsWith('-') || cleaned.startsWith('(');
      cleaned = cleaned.replaceAll('-', '').replaceAll('(', '').replaceAll(')', '');

      // Нормализуем разделитель: запятая → точка
      if (cleaned.contains(',') && cleaned.contains('.')) {
        // "1,234.56" — запятая это thousands separator
        cleaned = cleaned.replaceAll(',', '');
      } else if (cleaned.contains(',')) {
        // "1234,56" — запятая это decimal separator
        cleaned = cleaned.replaceAll(',', '.');
      }

      final doubleValue = double.parse(cleaned);
      var kopecks = (doubleValue * 100).round();
      if (isNegative) kopecks = -kopecks;
      return kopecks;
    } catch (_) {
      return null;
    }
  }

  Encoding _resolveEncoding(String name) {
    switch (name.toLowerCase()) {
      case 'windows-1251':
      case 'cp1251':
        return const Windows1251Encoding();
      case 'utf-8':
      default:
        return utf8;
    }
  }
}

/// Минимальная реализация windows-1251 для банковских CSV.
class Windows1251Encoding extends Encoding {
  const Windows1251Encoding();

  @override
  String get name => 'windows-1251';

  @override
  Converter<List<int>, String> get decoder => const _Win1251Decoder();

  @override
  Converter<String, List<int>> get encoder => throw UnimplementedError();
}

class _Win1251Decoder extends Converter<List<int>, String> {
  const _Win1251Decoder();

  @override
  String convert(List<int> input) {
    final buffer = StringBuffer();
    for (final byte in input) {
      if (byte < 128) {
        buffer.writeCharCode(byte);
      } else if (byte >= 192 && byte <= 255) {
        // Кириллица: 192→1040 (А), 224→1072 (а)
        buffer.writeCharCode(byte < 224 ? byte + 848 : byte + 848);
      } else if (byte == 168) {
        buffer.writeCharCode(1025); // Ё
      } else if (byte == 184) {
        buffer.writeCharCode(1105); // ё
      } else {
        buffer.writeCharCode(byte);
      }
    }
    return buffer.toString();
  }
}