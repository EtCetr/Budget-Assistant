import 'package:logger/logger.dart';
import '../../../calendar/domain/entities/holiday.dart';
import '../../../calendar/domain/repositories/holidays_repository.dart';
import '../repositories/reminders_repository.dart';

/// Контекст дня для ReminderDetailsScreen (ТЗ 6.3.11.5):
/// праздник на дату + количество других активных напоминаний.
class DayContext {
  const DayContext({this.holiday, this.otherRemindersCount = 0});
  final Holiday? holiday;
  final int otherRemindersCount;
}

class GetDayContextUseCase {
  GetDayContextUseCase({
    required HolidaysRepository holidaysRepository,
    required RemindersRepository remindersRepository,
    required Logger logger,
  })  : _holidaysRepository = holidaysRepository,
        _remindersRepository = remindersRepository,
        _logger = logger;

  final HolidaysRepository _holidaysRepository;
  final RemindersRepository _remindersRepository;
  final Logger _logger;

  Future<DayContext> call({
    required DateTime day,
    required String userId,
    String? spaceId,
    String? excludeReminderId,
  }) async {
    try {
      final holidays = await _holidaysRepository
          .watchAllEnabled(userId: userId, spaceId: spaceId)
          .first;
      Holiday? holiday;
      for (final h in holidays) {
        if (h.matchesDay(day)) {
          holiday = h;
          break;
        }
      }
      final start = DateTime.utc(day.year, day.month, day.day);
      final end = start.add(const Duration(days: 1));
      final reminders = await _remindersRepository
          .watchByDay(
            userId: userId,
            spaceId: spaceId,
            startUtc: start,
            endUtc: end,
          )
          .first;
      final others = reminders
          .where((r) => r.id != excludeReminderId && !r.isCompleted)
          .length;
      return DayContext(holiday: holiday, otherRemindersCount: others);
    } catch (e, st) {
      _logger.w('GetDayContext failed: $e', error: e, stackTrace: st);
      return const DayContext();
    }
  }
}