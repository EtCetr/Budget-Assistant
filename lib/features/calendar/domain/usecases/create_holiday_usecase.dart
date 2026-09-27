import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';
import 'package:budget_assistant/core/enums/transaction_enums.dart';
import '../entities/holiday.dart';
import '../repositories/holidays_repository.dart';

/// Параметры создания личного/семейного праздника (ТЗ 6.3.8.4).
class CreateHolidayParams {
  const CreateHolidayParams({
    required this.userId,
    this.spaceId,
    required this.name,
    required this.dateUtc,
    this.isAnnuallyRecurring = true,
    this.iconEmoji,
    this.colorHex,
  });

  final String userId;
  final String? spaceId;
  final String name;
  final DateTime dateUtc;
  final bool isAnnuallyRecurring;
  final String? iconEmoji;
  final String? colorHex;
}

/// Создание праздника (пресеты РФ создаются только сидом БД).
class CreateHolidayUseCase {
  CreateHolidayUseCase({
    required HolidaysRepository repository,
    required Logger logger,
  })  : _repository = repository,
        _logger = logger;

  final HolidaysRepository _repository;
  final Logger _logger;
  static const Uuid _uuid = Uuid();

  Future<void> call(CreateHolidayParams p) async {
    try {
      final now = DateTime.now().toUtc();
      await _repository.insert(
        Holiday(
          id: _uuid.v4(),
          spaceId: p.spaceId,
          userId: p.userId,
          name: p.name,
          date: p.dateUtc,
          isAnnuallyRecurring: p.isAnnuallyRecurring,
          iconEmoji: p.iconEmoji,
          colorHex: p.colorHex,
          isPreset: false,
          isEnabled: true,
          createdAt: now,
          updatedAt: now,
          syncStatus: SyncStatus.pending,
        ),
      );
    } catch (e, st) {
      _logger.e('CreateHoliday failed', error: e, stackTrace: st);
      rethrow;
    }
  }
}