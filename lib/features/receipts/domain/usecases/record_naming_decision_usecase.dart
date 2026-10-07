import 'package:logger/logger.dart';
import '../repositories/receipts_repository.dart';

/// Спам-защита именования товаров (ТЗ 6.3.49.4).
class RecordNamingDecisionUseCase {
  final ReceiptsRepository _repo;
  final Logger _logger;

  RecordNamingDecisionUseCase({
    required ReceiptsRepository repo,
    required Logger logger,
  })  : _repo = repo,
        _logger = logger;

  Future<void> call({
    required String userId,
    required bool accepted,
  }) async {
    try {
      await _repo.recordNamingDecision(userId, accepted: accepted);
    } catch (e, st) {
      _logger.e('RecordNamingDecision failed', error: e, stackTrace: st);
      rethrow;
    }
  }
}