import 'package:logger/logger.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import '../entities/secrecy_candidate.dart';
import '../entities/parsed_row.dart';
import 'detect_gift_candidate_usecase.dart';

/// Проверка режима секретности для импортированных транзакций.
///
/// Логика: если дата транзакции попадает в период
/// [holiday.date - secrecyDaysBefore, holiday.date) → кандидат в подарки.
///
/// Режим секретности — личная настройка (app_settings), не глобальный свитч.
class CheckSecrecyModeUseCase {
  final AppDatabase _db;
  final DetectGiftCandidateUseCase _giftDetector;
  final Logger _logger;

  CheckSecrecyModeUseCase({
    required AppDatabase db,
    required DetectGiftCandidateUseCase giftDetector,
    required Logger logger,
  })  : _db = db,
        _giftDetector = giftDetector,
        _logger = logger;

  Future<List<SecrecyCandidate>> call({
    required List<ParsedRow> transactions,
    required String? targetSpaceId,
    required String userId,
  }) async {
    try {
      // 1. Проверяем глобальный свитч
      final settings = await (_db.select(_db.appSettings)
            ..where((s) => s.userId.equals(userId)))
          .getSingleOrNull();

      if (settings == null || !settings.enableSecrecyMode) {
        return [];
      }

      final secrecyDays = settings.secrecyDaysBefore;

      // 2. Получаем активные праздники
      final holidaysQuery = _db.select(_db.holidays)
        ..where((h) => h.isEnabled.equals(true));
      final holidays = await holidaysQuery.get();

      // Фильтруем по scope: личные (spaceId IS NULL) + семейные
      final relevantHolidays = holidays.where((h) {
        if (h.spaceId == null) return true; // личный
        if (targetSpaceId != null && h.spaceId == targetSpaceId) return true;
        return false;
      }).toList();

      if (relevantHolidays.isEmpty) return [];

      // 3. Проверяем каждую транзакцию
      final candidates = <SecrecyCandidate>[];

      for (final row in transactions) {
        for (final holiday in relevantHolidays) {
          final secrecyStart =
              holiday.date.subtract(Duration(days: secrecyDays));

          if (row.date.isAfter(secrecyStart) &&
              row.date.isBefore(holiday.date)) {
            final confidence = await _giftDetector.call(row: row, db: _db);

            candidates.add(SecrecyCandidate(
              id: '${row.rowIndex}_${holiday.id}',
              transaction: row,
              relatedHolidayId: holiday.id,
              relatedHolidayName: holiday.name,
              relatedHolidayDate: holiday.date,
              confidence: confidence,
              isSelectedByDefault: confidence >= 0.3,
            ));
            break; // Одна транзакция = один праздник
          }
        }
      }

      _logger.i(
          'CheckSecrecyMode: найдено ${candidates.length} кандидатов в подарки');
      return candidates;
    } catch (e, st) {
      _logger.e('CheckSecrecyModeUseCase failed', error: e, stackTrace: st);
      return [];
    }
  }
}