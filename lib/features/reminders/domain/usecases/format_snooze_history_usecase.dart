import 'dart:convert';
import 'package:logger/logger.dart';
import '../entities/snooze_history_entry.dart';

/// Парсинг локального JSON-поля snooze_history (ТЗ 6.3.11.6).
/// Ошибка формата -> пустой список (лог, без rethrow).
class FormatSnoozeHistoryUseCase {
  FormatSnoozeHistoryUseCase({required Logger logger}) : _logger = logger;

  final Logger _logger;

  List<SnoozeHistoryEntry> call(String? json) {
    if (json == null || json.isEmpty) return const [];
    try {
      final decoded = jsonDecode(json);
      if (decoded is! List) return const [];
      final result = <SnoozeHistoryEntry>[];
      for (final e in decoded) {
        if (e is! Map<String, dynamic>) continue;
        final at = DateTime.tryParse(e['atUtc'] as String? ?? '');
        final from = DateTime.tryParse(e['fromUtc'] as String? ?? '');
        final to = DateTime.tryParse(e['toUtc'] as String? ?? '');
        if (at == null || from == null || to == null) continue;
        result.add(SnoozeHistoryEntry(atUtc: at, fromUtc: from, toUtc: to));
      }
      return result;
    } catch (e, st) {
      _logger.w('Bad snooze_history json: $e', error: e, stackTrace: st);
      return const [];
    }
  }

  /// «Отложено 10.07 на 3 дн.»
  String formatEntry(SnoozeHistoryEntry entry) {
    final days = entry.toUtc.difference(entry.fromUtc).inDays;
    final d = entry.atUtc;
    return 'Отложено ${d.day.toString().padLeft(2, '0')}.'
        '${d.month.toString().padLeft(2, '0')} на $days дн.';
  }
}