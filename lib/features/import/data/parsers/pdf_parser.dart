import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:pdfx/pdfx.dart' as pdfx;
import 'package:syncfusion_flutter_pdf/pdf.dart' as sf_pdf;
import 'package:budget_assistant/features/import/domain/entities/column_mapping.dart';
import 'package:budget_assistant/features/import/domain/entities/parsed_row.dart';
import 'import_file_parser.dart';
import 'pdf_bank_parsers.dart';

/// Парсер PDF: текстовый движок Syncfusion (слова с координатами -> строки),
/// FALLBACK — OCR (ML Kit) для сканов без текстового слоя.
class PdfParser implements ImportFileParser {
  final Logger _logger;
  final String _configJson;
  static const int _maxPages = 60;
  static const double _renderWidth = 2000;
  static const String _defaultDatePattern = r'\d{2}[./]\d{2}[./]\d{4}';
  static const String _defaultAmountPattern =
      r'[+\-–]?\s?\d{1,3}(?:[\s ]\d{3})*[.,]\d{2}';
  static const List<String> _incomeKeywords = [
    'капитализация процентов', 'поступление', 'зачисление', 'возврат',
    'кэшбэк', 'кешбэк', 'cashback', 'входящий перевод', 'начисление',
  ];
  static const List<String> _skipPatterns = [
    'страница', 'продолжение на следующей странице', 'входящий остаток',
    'исходящий остаток', 'итого списаний', 'итого зачислений',
    'описание операции', 'дата операции', 'сумма в валюте',
    'выписка по договору', 'выписка по счёту', 'номер счёта',
    'с уважением', 'начальник отдела',
  ];

  PdfParser({required Logger logger, required String configJson})
      : _logger = logger,
        _configJson = configJson;

  @override
  Future<ParseResult> parse({
    required String filePath,
    required ColumnMapping mapping,
  }) async {
    final file = File(filePath);
    if (!await file.exists()) {
      return ParseResult(rows: const [], rawRows: const [], totalRows: 0,
          error: 'Файл не найден: $filePath');
    }
    final bytes = await file.readAsBytes();
    final lines = <String>[];
    try {
      final doc = sf_pdf.PdfDocument(inputBytes: bytes);
      try {
        final extractor = sf_pdf.PdfTextExtractor(doc);
        for (var i = 0; i < doc.pages.count; i++) {
          final pageLines =
              extractor.extractTextLines(startPageIndex: i, endPageIndex: i);
          for (final pl in pageLines) {
            final t = _lineText(pl).trim();
            if (t.isNotEmpty) lines.add(t);
          }
        }
      } finally {
        doc.dispose();
      }
    } catch (e, st) {
      _logger.w('PDF: текстовый движок не смог извлечь текст: $e',
          error: e, stackTrace: st);
    }
    _logger.i('PDF: текстовых строк=${lines.length}');
    var rows = <ParsedRow>[];
    if (lines.length >= 5) {
      final bank = BankTextParsers.detectBank(lines.join('\n'));
      rows = BankTextParsers.parse(bank, lines);
      _logger.i('PDF: банк=$bank, транзакций из текста=${rows.length}');
    }
    if (rows.isEmpty) {
      _logger.i('PDF: текст не дал строк — fallback OCR');
      rows = await _ocrParse(filePath);
    }
    DateTime? periodStart;
    DateTime? periodEnd;
    for (final r in rows) {
      if (periodStart == null || r.date.isBefore(periodStart)) periodStart = r.date;
      if (periodEnd == null || r.date.isAfter(periodEnd)) periodEnd = r.date;
    }
    return ParseResult(
      rows: rows,
      rawRows: rows.map((r) => [r.merchantName]).toList(),
      totalRows: rows.length,
      periodStart: periodStart,
      periodEnd: periodEnd,
    );
  }

  /// Восстановление строки из слов с координатами: пробел вставляется
  /// по зазору между словами (лечит склейку «APTECHNOEUCHREZHDENIE»).
  String _lineText(dynamic pl) {
    try {
      final dynamic dl = pl;
      final dynamic wordsDyn = dl.words;
      if (wordsDyn is List && wordsDyn.isNotEmpty) {
        final ws = <_Word>[];
        for (final w in wordsDyn) {
          final b = (w as dynamic).bounds as ui.Rect;
          ws.add(_Word((w as dynamic).text as String, b.left, b.width));
        }
        ws.sort((a, b) => a.left.compareTo(b.left));
        final sb = StringBuffer();
        for (var i = 0; i < ws.length; i++) {
          if (i > 0) {
            final gap = ws[i].left - (ws[i - 1].left + ws[i - 1].width);
            if (gap > 1.0) sb.write(' ');
          }
          sb.write(ws[i].text);
        }
        final s = sb.toString().trim();
        if (s.isNotEmpty) return s;
      }
    } catch (_) {
      // Фолбэк на обычный текст строки.
    }
    return (pl.text as String?) ?? '';
  }

  Future<List<ParsedRow>> _ocrParse(String filePath) async {
    pdfx.PdfDocument? doc;
    Directory? tmpDir;
    final recognizer = TextRecognizer();
    try {
      doc = await pdfx.PdfDocument.openFile(filePath);
      tmpDir = await Directory.systemTemp.createTemp('pdf_import');
      final lines = <String>[];
      final pageCount = math.min(doc.pagesCount, _maxPages);
      for (var i = 1; i <= pageCount; i++) {
        final page = await doc.getPage(i);
        try {
          const double width = _renderWidth;
          final double height = width * page.height / page.width;
          final pdfx.PdfPageImage? image = await page.render(
            width: width, height: height,
            format: pdfx.PdfPageImageFormat.png,
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
              if (text.isNotEmpty) lines.add(BankTextParsers.normalize(text));
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
      for (var i = 0; i < lines.length; i++) {
        final row = _parseOcrLine(lines[i], i, dateRe, amountRe);
        if (row != null) rows.add(row);
      }
      return rows;
    } catch (e, st) {
      _logger.e('PdfParser OCR failed', error: e, stackTrace: st);
      return const [];
    } finally {
      await recognizer.close();
      try { await doc?.close(); } catch (_) {}
      try { await tmpDir?.delete(recursive: true); } catch (_) {}
    }
  }

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

  ParsedRow? _parseOcrLine(
      String line, int idx, RegExp dateRe, RegExp amountRe) {
    final lower = line.toLowerCase();
    for (final pattern in _skipPatterns) {
      if (lower.contains(pattern)) return null;
    }
    final dateMatch = dateRe.firstMatch(line);
    if (dateMatch == null) return null;
    final dateStr = dateMatch.group(0)!;
    DateTime? date;
    try {
      date = DateFormat('dd.MM.yyyy').parse(dateStr);
    } catch (_) {
      return null;
    }
    final amounts = amountRe.allMatches(line).toList();
    if (amounts.isEmpty) return null;
    final amountStr = amounts.last.group(0)!;
    final parsed = _parseAmount(amountStr);
    if (parsed == null) return null;
    final isIncome = amountStr.trimLeft().startsWith('+') ||
        _incomeKeywords.any((k) => lower.contains(k));
    final kopecks = isIncome ? parsed.abs() : -parsed.abs();
    var merchant = line
        .replaceFirst(dateStr, ' ')
        .replaceFirst(amountStr, ' ')
        .replaceAll(RegExp(r'₽|руб\.?|RUB', caseSensitive: false), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    if (merchant.length < 3) return null;
    return ParsedRow(
      rowIndex: idx, date: date.toUtc(),
      amountKopecks: kopecks, merchantName: merchant,
    );
  }

  int? _parseAmount(String v) {
    try {
      var c = v.replaceAll(' ', '').replaceAll(' ', '')
          .replaceAll('–', '-').replaceAll('+', '').trim();
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

class _Word {
  final String text;
  final double left;
  final double width;
  _Word(this.text, this.left, this.width);
}