import 'package:logger/logger.dart';
import '../repositories/holidays_repository.dart';

/// Вкл/выкл праздника (пресеты РФ не отключаются, ТЗ 6.3.8.3).
class ToggleHolidayUseCase {
  ToggleHolidayUseCase({
    required HolidaysRepository repository,
    required Logger logger,
  })  : _repository = repository,
        _logger = logger;

  final HolidaysRepository _repository;
  final Logger _logger;

  Future<void> call(String holidayId, bool enabled) async {
    try {
      final holiday = await _repository.getById(holidayId);
      if (holiday == null) return;
      if (holiday.isPreset) {
        _logger.w('ToggleHoliday: preset is read-only ($holidayId)');
        return;
      }
      await _repository.setEnabled(holidayId, enabled);
    } catch (e, st) {
      _logger.e('ToggleHoliday failed', error: e, stackTrace: st);
      rethrow;
    }
  }
}