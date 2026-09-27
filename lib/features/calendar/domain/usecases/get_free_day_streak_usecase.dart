import 'package:logger/logger.dart';
import '../../data/datasources/calendar_dao.dart';

/// Локальный ключ дня 'YYYY-MM-DD' (совпадает с ключами SQL 'localtime').
String localDayKey(DateTime day) {
  return '${day.year.toString().padLeft(4, '0')}-'
      '${day.month.toString().padLeft(2, '0')}-'
      '${day.day.toString().padLeft(2, '0')}';
}

/// Streak «бесплатных дней» подряд (ТЗ 6.3.6): от сегодня назад по
/// дням без расходов; если сегодня уже были траты — считаем от вчера.
class GetFreeDayStreakUseCase {
  GetFreeDayStreakUseCase({
    required CalendarDao dao,
    required Logger logger,
  })  : _dao = dao,
        _logger = logger;

  final CalendarDao _dao;
  final Logger _logger;
  static const int _maxLookback = 120;

  Future<int> call({
    required String userId,
    String? spaceId,
    required DateTime fromDay,
  }) async {
    try {
      final today = DateTime(fromDay.year, fromDay.month, fromDay.day);
      final start = today.subtract(const Duration(days: _maxLookback));
      final end = today.add(const Duration(days: 1));
      final totals = await _dao.getExpenseTotalsByDay(
        userId: userId,
        spaceId: spaceId,
        startUtc: start.toUtc(),
        endUtc: end.toUtc(),
      );
      int streak = 0;
      DateTime d = today;
      if ((totals[localDayKey(d)] ?? 0) > 0) {
        d = d.subtract(const Duration(days: 1));
      }
      while (streak < _maxLookback && (totals[localDayKey(d)] ?? 0) == 0) {
        streak++;
        d = d.subtract(const Duration(days: 1));
      }
      return streak;
    } catch (e, st) {
      _logger.e('GetFreeDayStreak failed', error: e, stackTrace: st);
      rethrow;
    }
  }
}