import 'package:logger/logger.dart';
import '../models/year_budget_models.dart';
import '../repositories/year_budget_repository.dart';

/// Правки «Выделено», лимита категории и перенос значений из прошлого месяца.
class SaveMonthBudgetUseCase {
  SaveMonthBudgetUseCase({
    required YearBudgetRepository repository,
    required Logger logger,
  })  : _repository = repository,
        _logger = logger;

  final YearBudgetRepository _repository;
  final Logger _logger;

  Future<void> saveAllocated({
    required String userId,
    required MonthStatsKey key,
    required int kopecks,
  }) async {
    try {
      await _repository.saveAllocated(
        userId: userId,
        spaceId: key.spaceId,
        year: key.year,
        month: key.month,
        kopecks: kopecks,
      );
    } catch (e, st) {
      _logger.e('saveAllocated failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  Future<void> saveLimit({
    required String userId,
    required MonthStatsKey key,
    required String categoryId,
    required int kopecks,
  }) async {
    try {
      await _repository.saveLimit(
        userId: userId,
        spaceId: key.spaceId,
        year: key.year,
        month: key.month,
        categoryId: categoryId,
        kopecks: kopecks,
      );
    } catch (e, st) {
      _logger.e('saveLimit failed', error: e, stackTrace: st);
      rethrow;
    }
  }

  Future<int> carryOver({
    required String userId,
    required MonthStatsKey key,
    required int fromYear,
    required int fromMonth,
  }) async {
    try {
      return await _repository.carryOver(
        userId: userId,
        spaceId: key.spaceId,
        fromYear: fromYear,
        fromMonth: fromMonth,
        toYear: key.year,
        toMonth: key.month,
      );
    } catch (e, st) {
      _logger.e('carryOver failed', error: e, stackTrace: st);
      rethrow;
    }
  }
}