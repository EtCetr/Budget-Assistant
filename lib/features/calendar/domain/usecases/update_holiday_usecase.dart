import 'package:logger/logger.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import '../entities/holiday.dart';
import '../repositories/holidays_repository.dart';

/// Обновление личного/семейного праздника (пресеты не трогаем).
class UpdateHolidayUseCase {
  UpdateHolidayUseCase({
    required HolidaysRepository repository,
    required Logger logger,
  })  : _repository = repository,
        _logger = logger;

  final HolidaysRepository _repository;
  final Logger _logger;

  Future<void> call(Holiday updated) async {
    try {
      if (updated.isPreset) {
        _logger.w('UpdateHoliday: preset is read-only (${updated.id})');
        return;
      }
      await _repository.update(
        updated.copyWith(
          updatedAt: DateTime.now().toUtc(),
          syncStatus: SyncStatus.pending,
        ),
      );
    } catch (e, st) {
      _logger.e('UpdateHoliday failed', error: e, stackTrace: st);
      rethrow;
    }
  }
}