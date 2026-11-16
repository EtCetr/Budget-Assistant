import 'package:logger/logger.dart';
import 'package:rrule/rrule.dart';

/// Следующие N срабатываний напоминания (UTC).
/// Однократное (rule == null) -> [remindAt] или пусто, если прошло.
/// Любая ошибка парсинга RRULE -> fallback на однократное (log, без rethrow).
///
/// Этап 24 (D24-30): BuildRRuleUseCase пишет наше подмножество БЕЗ префикса
/// ('FREQ=DAILY'), а парсер пакета ожидает свойство iCalendar
/// ('RRULE:FREQ=DAILY'). Без нормализации парсинг падал и любое повторяющееся
/// напоминание превращалось в однократное.
///
/// Этап 24 (D24-31): afterUtc передаётся в пакет только когда он ПОЗЖЕ старта.
/// Планировщик всегда вызывает с afterUtc = «сейчас»; для будущего напоминания
/// это раньше старта, и пакет обрезал выдачу до одного срабатывания вместо 3.
class GetNextOccurrencesUseCase {
  GetNextOccurrencesUseCase({required Logger logger}) : _logger = logger;

  final Logger _logger;

  List<DateTime> call({
    required DateTime startUtc,
    String? rrule,
    DateTime? afterUtc,
    int count = 3,
  }) {
    if (rrule == null || rrule.trim().isEmpty) {
      if (afterUtc != null && startUtc.isBefore(afterUtc)) return const [];
      return [startUtc];
    }
    try {
      final rule = _parse(rrule);
      // Отсекать прошедшие срабатывания нужно только если старт уже прошёл.
      // Если старт в будущем (или ровно сейчас) — берём выдачу от самого старта.
      final from = (afterUtc != null && afterUtc.isAfter(startUtc))
          ? afterUtc.subtract(const Duration(seconds: 1))
          : null;
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

  /// Нормализует строку к виду свойства iCalendar.
  /// Если пакет не принял нормализованную форму — пробуем исходную.
  RecurrenceRule _parse(String raw) {
    final trimmed = raw.trim();
    final normalized =
        trimmed.toUpperCase().startsWith('RRULE:') ? trimmed : 'RRULE:$trimmed';
    try {
      return RecurrenceRule.fromString(normalized);
    } catch (_) {
      return RecurrenceRule.fromString(trimmed);
    }
  }
}