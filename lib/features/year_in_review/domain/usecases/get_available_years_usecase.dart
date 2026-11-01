import 'package:logger/logger.dart';
import '../models/yearly_aggregate.dart';
import '../repositories/yearly_aggregates_repository.dart';

/// Список годов с данными для экрана «Статистика по годам».
class GetAvailableYearsUseCase {
  GetAvailableYearsUseCase({
    required YearlyAggregatesRepository repository,
    required Logger logger,
  })  : _repository = repository,
        _logger = logger;

  final YearlyAggregatesRepository _repository;
  final Logger _logger;

  Future<List<YearInReviewYearInfo>> call({required String userId}) async {
    try {
      return await _repository.availableYears(userId: userId);
    } catch (e, st) {
      _logger.e('GetAvailableYears failed', error: e, stackTrace: st);
      rethrow;
    }
  }
}