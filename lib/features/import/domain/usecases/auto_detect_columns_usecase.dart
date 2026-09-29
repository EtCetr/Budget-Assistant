import 'dart:math' as math;

import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import '../entities/column_detection_result.dart';
import '../entities/column_mapping.dart';

/// Автоопределение колонок даты/суммы/мерчанта по первым 10 строкам
/// (ТЗ 6.3.25.13). Уверенность >= 0.8 → автозаполнение в UI.
class AutoDetectColumnsUseCase {
  final Logger _logger;

  static final RegExp _dateRe = RegExp(r'\d{1,2}[./-]\d{1,2}[./-]\d{2,4}');
  static final RegExp _moneyRe =
      RegExp(r'^-?\d{1,3}(?:[\s ]\d{3})*[.,]\d{2}\s*(?:₽|руб\.?|RUB)?$',
          caseSensitive: false);
  static final RegExp _textRe = RegExp(r'[A-Za-zА-Яа-я]{2,}');

  static const List<String> _dateFormats = [
    'dd.MM.yyyy HH:mm:ss',
    'dd.MM.yyyy',
    'dd/MM/yyyy',
    'yyyy-MM-dd',
  ];

  AutoDetectColumnsUseCase({required Logger logger}) : _logger = logger;

  ColumnDetectionResult call({
    required List<List<String>> rawRows,
    required ColumnMapping base,
  }) {
    try {
      if (rawRows.isEmpty) {
        return ColumnDetectionResult(mapping: base, confidence: 0);
      }

      // skipRows: ведущие строки без дат = заголовки банка.
      var skip = 0;
      for (final row in rawRows.take(6)) {
        if (row.any((c) => _dateRe.hasMatch(c))) break;
        skip++;
      }

      final data = rawRows.skip(skip).take(10).toList();
      if (data.isEmpty) {
        return ColumnDetectionResult(
          mapping: base.copyWith(skipRows: skip),
          confidence: 0,
        );
      }

      final colCount = data.map((r) => r.length).reduce(math.max);
      if (colCount < 3) {
        return ColumnDetectionResult(
          mapping: base.copyWith(skipRows: skip),
          confidence: 0,
        );
      }

      final dateScores = List<int>.filled(colCount, 0);
      final amountScores = List<int>.filled(colCount, 0);
      final textScores = List<int>.filled(colCount, 0);

      for (final row in data) {
        for (var i = 0; i < row.length; i++) {
          final c = row[i].trim();
          if (c.isEmpty) continue;
          if (_dateRe.hasMatch(c)) {
            dateScores[i]++;
          } else if (_moneyRe.hasMatch(c)) {
            amountScores[i]++;
          } else if (_textRe.hasMatch(c)) {
            textScores[i]++;
          }
        }
      }

      final n = data.length;
      final dateIdx = _bestIndex(dateScores);
      final amountIdx = _bestIndex(amountScores);
      final merchantIdx = _bestTextIndex(textScores, {dateIdx, amountIdx});

      if (dateScores[dateIdx] == 0 ||
          amountScores[amountIdx] == 0 ||
          textScores[merchantIdx] == 0) {
        return ColumnDetectionResult(
          mapping: base.copyWith(skipRows: skip),
          confidence: 0,
        );
      }

      final confidence = [
        dateScores[dateIdx] / n,
        amountScores[amountIdx] / n,
        textScores[merchantIdx] / n,
      ].reduce(math.min);

      final dateFormat = _detectDateFormat(data, dateIdx) ?? base.dateFormat;
      final hasNegative = data.any((row) =>
          dateIdx < row.length &&
          row.length > amountIdx &&
          row[amountIdx].trim().startsWith('-'));

      final mapping = base.copyWith(
        skipRows: skip,
        dateColumnIndex: dateIdx,
        amountColumnIndex: amountIdx,
        merchantColumnIndex: merchantIdx,
        dateFormat: dateFormat,
        expenseIsNegative: hasNegative ? true : base.expenseIsNegative,
      );
      return ColumnDetectionResult(mapping: mapping, confidence: confidence);
    } catch (e, st) {
      _logger.e('AutoDetectColumnsUseCase failed', error: e, stackTrace: st);
      return ColumnDetectionResult(mapping: base, confidence: 0);
    }
  }

  int _bestIndex(List<int> scores) {
    var best = 0;
    for (var i = 1; i < scores.length; i++) {
      if (scores[i] > scores[best]) best = i;
    }
    return best;
  }

  int _bestTextIndex(List<int> scores, Set<int> excluded) {
    var best = -1;
    for (var i = 0; i < scores.length; i++) {
      if (excluded.contains(i)) continue;
      if (best == -1 || scores[i] > scores[best]) best = i;
    }
    return best == -1 ? 0 : best;
  }

  String? _detectDateFormat(List<List<String>> data, int dateIdx) {
    final values = data
        .where((r) => dateIdx < r.length)
        .map((r) => r[dateIdx].trim())
        .where((v) => v.isNotEmpty)
        .toList();
    if (values.isEmpty) return null;
    for (final fmt in _dateFormats) {
      var ok = 0;
      for (final v in values) {
        try {
          DateFormat(fmt).parseStrict(v);
          ok++;
        } catch (_) {}
      }
      if (ok / values.length >= 0.8) return fmt;
    }
    return null;
  }
}