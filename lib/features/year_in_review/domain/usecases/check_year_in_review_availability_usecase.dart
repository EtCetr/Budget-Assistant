import 'dart:convert';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/database/daos/app_settings_dao.dart';
import '../models/year_in_review_data.dart';
import '../repositories/yearly_aggregates_repository.dart';
import 'recalculate_yearly_aggregates_usecase.dart';

/// Авто-показ после 27 декабря (6.3.37.12): возвращает год для оверлея
/// или null, если показывать нечего.
///
/// Этап 24 (D24-81): необязательный [now] для детерминированных тестов.
/// Прецедент — GenerateDailyDigestUseCase.maybeGenerate(userId, now).
/// Без параметра поведение прежнее: берётся DateTime.now().
class CheckYearInReviewAvailabilityUseCase {
  CheckYearInReviewAvailabilityUseCase({
    required YearlyAggregatesRepository repository,
    required RecalculateYearlyAggregatesUseCase recalculate,
    required AppSettingsDao settingsDao,
    required Logger logger,
  })  : _repository = repository,
        _recalculate = recalculate,
        _settingsDao = settingsDao,
        _logger = logger;

  final YearlyAggregatesRepository _repository;
  final RecalculateYearlyAggregatesUseCase _recalculate;
  final AppSettingsDao _settingsDao;
  final Logger _logger;

  Future<int?> call(String userId, {DateTime? now}) async {
    try {
      final at = now ?? DateTime.now();
      if (!(at.month == 12 && at.day >= 27)) return null;

      final settings = await _settingsDao.getForUser(userId);
      if (!settings.enableYearInReviewAlerts) return null;

      final row = await _repository.getForScope(
        userId: userId,
        spaceId: null,
        year: at.year,
      );

      if (row == null) {
        // Воркер ещё не сработал — считаем на лету (одноразово).
        final data = await _recalculate(
          userId: userId,
          year: at.year,
          spaceId: null,
          baseCurrency: settings.baseCurrency,
        );
        if (data == null || data.transactionCount == 0) return null;
        return at.year;
      }

      if (row.isViewed) return null;
      final data = YearInReviewData.fromJson(
        jsonDecode(row.dataJson) as Map<String, dynamic>,
      );
      if (data.transactionCount == 0) return null;
      return at.year;
    } catch (e, st) {
      _logger.e('CheckYearInReviewAvailability failed',
          error: e, stackTrace: st);
      return null;
    }
  }
}