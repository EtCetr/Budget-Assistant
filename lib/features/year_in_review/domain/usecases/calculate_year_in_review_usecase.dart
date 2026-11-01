import 'dart:convert';

import 'package:logger/logger.dart';
import 'package:budget_assistant/core/database/daos/app_settings_dao.dart';
import '../models/year_in_review_data.dart';
import '../repositories/yearly_aggregates_repository.dart';
import 'recalculate_yearly_aggregates_usecase.dart';

/// Чтение годовых итогов из кэша (< 100 мс, 6.3.37.16). Если кэша нет —
/// считает на лету и сохраняет (первое открытие до воркера).
class CalculateYearInReviewUseCase {
  CalculateYearInReviewUseCase({
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

  Future<YearInReviewData?> call({
    required String userId,
    required int year,
    String? spaceId,
  }) async {
    try {
      final cached = await _repository.getForScope(
        userId: userId,
        spaceId: spaceId,
        year: year,
      );
      if (cached != null) {
        return YearInReviewData.fromJson(
          jsonDecode(cached.dataJson) as Map<String, dynamic>,
        );
      }
      final settings = await _settingsDao.getForUser(userId);
      return await _recalculate(
        userId: userId,
        year: year,
        spaceId: spaceId,
        baseCurrency: settings.baseCurrency,
      );
    } catch (e, st) {
      _logger.e('CalculateYearInReview failed', error: e, stackTrace: st);
      rethrow;
    }
  }
}