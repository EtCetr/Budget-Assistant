import 'package:logger/logger.dart';
import '../repositories/holidays_repository.dart';

/// Удаление личного/семейного праздника (пресеты не удаляются).
class DeleteHolidayUseCase {
  DeleteHolidayUseCase({
    required HolidaysRepository repository,
    required Logger logger,
  })  : _repository = repository,
        _logger = logger;

  final HolidaysRepository _repository;
  final Logger _logger;

  Future<void> call(String holidayId) async {
    try {
      final holiday = await _repository.getById(holidayId);
      if (holiday == null) return;
      if (holiday.isPreset) {
        _logger.w('DeleteHoliday: preset is read-only ($holidayId)');
        return;
      }
      await _repository.deleteById(holidayId);
    } catch (e, st) {
      _logger.e('DeleteHoliday failed', error: e, stackTrace: st);
      rethrow;
    }
  }
}