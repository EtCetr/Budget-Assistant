import 'package:logger/logger.dart';
import '../entities/reminder_form_draft.dart';
import '../repositories/reminders_repository.dart';

/// Восстановление свежего черновика (< 24 ч) при открытии формы.
class RestoreReminderDraftUseCase {
  RestoreReminderDraftUseCase({
    required RemindersRepository repository,
    required Logger logger,
  })  : _repository = repository,
        _logger = logger;

  final RemindersRepository _repository;
  final Logger _logger;

  Future<ReminderFormDraft?> call(String userId) async {
    try {
      return await _repository.getFreshDraft(userId);
    } catch (e, st) {
      _logger.w('RestoreReminderDraft failed: $e', error: e, stackTrace: st);
      return null;
    }
  }
}