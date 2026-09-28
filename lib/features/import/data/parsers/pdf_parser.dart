import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:pdfx/pdfx.dart';

import 'package:budget_assistant/features/import/domain/entities/column_mapping.dart';
import 'package:budget_assistant/features/import/domain/entities/parsed_row.dart';
import 'import_file_parser.dart';

/// Парсер PDF-выписок банков.
/// Пайплайн: pdfx (нативный PdfRenderer) -> bitmap страницы ->
/// ML Kit Text Recognition (офлайн, модель в APK) -> regex из parser_configs.
/// Кириллица поддерживается латинской моделью ML Kit v2.
class PdfParser implements ImportFileParser {
  final Logger _logger;

  /// config_json выбранного банка (секция pdf.regex_patterns).
  final String _configJson;

  static const int _maxPages = 60;
  static const double _renderWidth = 1400;

  static const String _defaultDatePattern = r'\d{2}[./]\d{2}[./]\d{4}';
  static const String _defaultAmountPattern =
      r'-?\d{1,3}(?:[\s\u00A0]\d{3})*[.,]\d{2}';

  static const List<String> _incomeKeywords = [
    'поступление', 'зачисление', 'возврат', 'кэшбэк', 'кешбэк',
    'cashback', 'перевод от', 'сбп от',
  ];

  PdfParser({required Logger logger, required String configJson})
      : _logger = logger,
        _configJson = configJson;

  @override
  Future<ParseResult> parse({
    required String filePath,
    required ColumnMapping mapping,
  }) async {
    PdfDocument? doc;
    Directory? tmpDir;
    final recognizer = TextRecognizer();
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        return ParseResult(
          rows: const [],
          rawRows: const [],
          totalRows: 0,
          error: 'Файл не найден: $filePath',
        );
      }

      doc = await PdfDocument.openFile(filePath);
      tmpDir = await Directory.systemTemp.createTemp('pdf_import');

      final lines = <String>[];
      final pageCount = math.min(doc.pagesCount, _maxPages);

      for (var i = 1; i <= pageCount; i++) {
        final page = await doc.getPage(i);
        try {
          const double width = _renderWidth;
          final double height = width * page.height / page.width;
          final PdfPageImage? image = await page.render(
            width: width,
            height: height,
            format: PdfPageImageFormat.png,
            backgroundColor: '#FFFFFF',
          );
          final Uint8List? bytes = image?.bytes;
          if (bytes == null || bytes.isEmpty) continue;

          final imgFile = File('${tmpDir.path}/page_$i.png');
          await imgFile.writeAsBytes(bytes, flush: true);
          final inputImage = InputImage.fromFilePath(imgFile.path);
          final recognized = await recognizer.processImage(inputImage);
          for (final block in recognized.blocks) {
            for (final line in block.lines) {
              final text = line.text.trim();
              if (text.isNotEmpty) lines.add(text);
            }
          }
          await imgFile.delete();
        } finally {
          await page.close();
        }
      }

      final dateRe = RegExp(_patternFromConfig('date') ?? _defaultDatePattern);
      final amountRe =
          RegExp(_patternFromConfig('amount') ?? _defaultAmountPattern);

      final rows = <ParsedRow>[];
      DateTime? periodStart;
      DateTime? periodEnd;

      for (var i = 0; i < lines.length; i++) {
        final row = _parseLine(lines[i], i, dateRe, amountRe, mapping);
        if (row == null) continue;
        rows.add(row);
        if (periodStart == null || row.date.isBefore(periodStart)) {
          periodStart = row.date;
        }
        if (periodEnd == null || row.date.isAfter(periodEnd)) {
          periodEnd = row.date;
        }
      }

      _logger.i('PDF: строк распознано ${lines.length}, '
          'транзакций извлечено ${rows.length}');
      return ParseResult(
        rows: rows,
        rawRows: lines.map((e) => [e]).toList(),
        totalRows: lines.length,
        periodStart: periodStart,
        periodEnd: periodEnd,
      );
    } catch (e, st) {
      _logger.e('PdfParser.parse failed', error: e, stackTrace: st);
      return ParseResult(
        rows: const [],
        rawRows: const [],
        totalRows: 0,
        error: 'Ошибка чтения PDF: $e',
      );
    } finally {
      await recognizer.close();
      try {
        await doc?.close();
      } catch (_) {}
      try {
        await tmpDir?.delete(recursive: true);
      } catch (_) {}
    }
  }

  /// Достаёт regex из config_json банка: секция pdf.regex_patterns,
  /// ключи 'date' и 'amount'.
  String? _patternFromConfig(String key) {
    try {
      final cfg = jsonDecode(_configJson);
      if (cfg is Map<String, dynamic>) {
        final pdf = cfg['pdf'];
        if (pdf is Map<String, dynamic>) {
          final patterns = pdf['regex_patterns'];
          if (patterns is Map<String, dynamic>) {
            final v = patterns[key];
            if (v is String && v.isNotEmpty) return v;
          }
        }
      }
    } catch (_) {}
    return null;
  }

  ParsedRow? _parseLine(
    String line,
    int idx,
    RegExp dateRe,
    RegExp amountRe,
    ColumnMapping mapping,
  ) {
    final dateMatch = dateRe.firstMatch(line);
    if (dateMatch == null) return null;
    final amounts = amountRe.allMatches(line).toList();
    if (amounts.isEmpty) return null;

    final dateStr = dateMatch.group(0)!;
    final amountStr = amounts.last.group(0)!;

    var merchant = line
        .replaceFirst(dateStr, ' ')
        .replaceFirst(amountStr, ' ')
        .replaceAll(RegExp(r'₽|руб\.?|RUB', caseSensitive: false), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    if (merchant.length < 2) return null;

    final date = _parseDate(dateStr, mapping.dateFormat);
    if (date == null) return null;
    final parsed = _parseAmount(amountStr);
    if (parsed == null) return null;

    // Знак: явный минус -> расход; ключевые слова дохода -> доход;
    // иначе дефолт выписки -> расход.
    final lower = line.toLowerCase();
    final isIncome = _incomeKeywords.any((k) => lower.contains(k));
    final kopecks =
        (!amountStr.startsWith('-') && isIncome) ? parsed.abs() : -parsed.abs();

    return ParsedRow(
      rowIndex: idx,
      date: date.toUtc(),
      amountKopecks: kopecks,
      merchantName: merchant,
    );
  }

  DateTime? _parseDate(String v, String fmt) {
    try {
      return DateFormat(fmt).parse(v);
    } catch (_) {}
    try {
      return DateFormat('dd.MM.yyyy').parse(v);
    } catch (_) {}
    try {
      return DateFormat('dd/MM/yyyy').parse(v);
    } catch (_) {}
    return null;
  }

  int? _parseAmount(String v) {
    try {
      var c = v.replaceAll(' ', '').replaceAll('\u00A0', '').trim();
      final neg = c.startsWith('-');
      c = c.replaceAll('-', '');
      if (c.contains(',') && c.contains('.')) {
        c = c.replaceAll(',', '');
      } else if (c.contains(',')) {
        c = c.replaceAll(',', '.');
      }
      final d = double.parse(c);
      final k = (d * 100).round();
      return neg ? -k : k;
    } catch (_) {
      return null;
    }
  }
}