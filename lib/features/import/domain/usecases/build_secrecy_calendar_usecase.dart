import 'package:logger/logger.dart';
import '../entities/secrecy_candidate.dart';

/// Тип дня в календаре секретности.
enum SecrecyDayType { none, secrecyPeriod, holiday }

/// Один день календаря секретности.
class SecrecyCalendarDay {
  final DateTime date;
  final SecrecyDayType type;
  final String? holidayName;
  final String? holidayIconEmoji;
  final bool hasCandidates;

  const SecrecyCalendarDay({
    required this.date,
    required this.type,
    this.holidayName,
    this.holidayIconEmoji,
    this.hasCandidates = false,
  });
}

/// Построение визуального календаря периодов секретности.
class BuildSecrecyCalendarUseCase {
  final Logger _logger;

  BuildSecrecyCalendarUseCase({required Logger logger}) : _logger = logger;

  List<SecrecyCalendarDay> call({
    required int year,
    required int month,
    required List<SecrecyCandidate> candidates,
    required int secrecyDaysBefore,
  }) {
    try {
      final days = <SecrecyCalendarDay>[];
      final daysInMonth = DateTime(year, month + 1, 0).day;

      // Собираем уникальные праздники из кандидатов
      final holidayMap = <String, SecrecyCandidate>{};
      for (final c in candidates) {
        holidayMap.putIfAbsent(c.relatedHolidayId, () => c);
      }

      for (var day = 1; day <= daysInMonth; day++) {
        final date = DateTime(year, month, day);
        var type = SecrecyDayType.none;
        String? hName;
        var hasCand = false;

        for (final entry in holidayMap.entries) {
          final candidate = entry.value;
          final holidayDate = candidate.relatedHolidayDate;
          final secrecyStart =
              holidayDate.subtract(Duration(days: secrecyDaysBefore));

          // Проверяем: это день праздника?
          if (date.year == holidayDate.year &&
              date.month == holidayDate.month &&
              date.day == holidayDate.day) {
            type = SecrecyDayType.holiday;
            hName = candidate.relatedHolidayName;
            break;
          }

          // Проверяем: это период секретности?
          if (date.isAfter(secrecyStart) && date.isBefore(holidayDate)) {
            type = SecrecyDayType.secrecyPeriod;
            hName = candidate.relatedHolidayName;
            break;
          }
        }

        // Проверяем: есть ли кандидаты в этот день?
        hasCand = candidates.any((c) =>
            c.transaction.date.year == date.year &&
            c.transaction.date.month == date.month &&
            c.transaction.date.day == date.day);

        days.add(SecrecyCalendarDay(
          date: date,
          type: type,
          holidayName: hName,
          hasCandidates: hasCand,
        ));
      }

      return days;
    } catch (e, st) {
      _logger.e('BuildSecrecyCalendarUseCase failed', error: e, stackTrace: st);
      return [];
    }
  }
}