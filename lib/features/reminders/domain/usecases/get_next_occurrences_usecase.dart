import 'package:logger/logger.dart';
import 'package:rrule/rrule.dart';

/// Следующие N срабатываний напоминания (UTC).
/// Однократное (rule == null) -> [remindAt] или пусто, если прошло.
/// Любая ошибка парсинга RRULE -> fallback на однократное (log, без rethrow).
class GetNextOccurrencesUseCase {
  GetNextOccurrencesUseCase({required Logger logger}) : _logger = logger;

  final Logger _logger;

  List<DateTime> call({
    required DateTime startUtc,
    String? rrule,
    DateTime? afterUtc,
    int count = 3,
  }) {
    if (rrule?.isEmpty ?? true) {
      if (afterUtc != null && startUtc.isBefore(afterUtc)) return const [];
      return [startUtc];
    }
    try {
      final rule = RecurrenceRule.fromString(rrule!);
      final from = afterUtc?.subtract(const Duration(seconds: 1));
      return rule
          .getInstances(start: startUtc, after: from)
          .take(count)
          .toList(growable: false);
    } catch (e, st) {
      _logger.w('Bad RRULE "$rrule": $e', error: e, stackTrace: st);
      if (afterUtc != null && startUtc.isBefore(afterUtc)) return const [];
      return [startUtc];
    }
  }
}