import 'package:logger/logger.dart';
import '../repositories/yearly_aggregates_repository.dart';

class MarkYearInReviewAsViewedUseCase {
  MarkYearInReviewAsViewedUseCase({
    required YearlyAggregatesRepository repository,
    required Logger logger,
  })  : _repository = repository,
        _logger = logger;

  final YearlyAggregatesRepository _repository;
  final Logger _logger;

  Future<void> call({
    required String userId,
    required int year,
    String? spaceId,
  }) async {
    try {
      await _repository.markViewed(
          userId: userId, spaceId: spaceId, year: year);
    } catch (e, st) {
      _logger.e('MarkYearInReviewAsViewed failed', error: e, stackTrace: st);
      rethrow;
    }
  }
}