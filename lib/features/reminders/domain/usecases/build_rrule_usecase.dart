import '../models/recurrence_settings.dart';

/// Собирает iCal RRULE строку из настроек конструктора (ТЗ 6.3.12.4).
/// Пишем строку вручную: поддерживаем наше подмножество, API записи
/// пакета rrule не используем (читаем только через fromString).
class BuildRRuleUseCase {
  static const Map<int, String> _dayCodes = {
    1: 'MO',
    2: 'TU',
    3: 'WE',
    4: 'TH',
    5: 'FR',
    6: 'SA',
    7: 'SU',
  };

  String call(RecurrenceSettings s) {
    final sb = StringBuffer('FREQ=${s.freq.name.toUpperCase()}');
    if (s.interval > 1) sb.write(';INTERVAL=${s.interval}');
    if (s.freq == RecurrenceFreq.weekly && s.byWeekday.isNotEmpty) {
      final days = s.byWeekday
          .where(_dayCodes.containsKey)
          .map((d) => _dayCodes[d])
          .join(',');
      if (days.isNotEmpty) sb.write(';BYDAY=$days');
    }
    if (s.freq == RecurrenceFreq.monthly && s.byMonthDay != null) {
      sb.write(';BYMONTHDAY=${s.byMonthDay}');
    }
    if (s.until != null) {
      final u = s.until!.toUtc();
      final stamp = '${u.year.toString().padLeft(4, '0')}'
          '${u.month.toString().padLeft(2, '0')}'
          '${u.day.toString().padLeft(2, '0')}T'
          '${u.hour.toString().padLeft(2, '0')}'
          '${u.minute.toString().padLeft(2, '0')}'
          '${u.second.toString().padLeft(2, '0')}Z';
      sb.write(';UNTIL=$stamp');
    }
    return sb.toString();
  }
}