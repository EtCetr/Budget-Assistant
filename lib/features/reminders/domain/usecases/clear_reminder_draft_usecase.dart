import 'package:logger/logger.dart';
import '../repositories/reminders_repository.dart';

/// Очистка черновика после успешного сохранения/отмены формы.
class ClearReminderDraftUseCase {
  ClearReminderDraftUseCase({
    required RemindersRepository repository,
    required Logger logger,
  })  : _repository = repository,
        _logger = logger;

  final RemindersRepository _repository;
  final Logger _logger;

  Future<void> call(String userId) async {
    try {
      await _repository.deleteDraftByUser(userId);
    } catch (e, st) {
      _logger.w('ClearReminderDraft failed: $e', error: e, stackTrace: st);
    }
  }
}