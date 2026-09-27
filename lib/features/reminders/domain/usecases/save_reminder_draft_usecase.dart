import 'package:logger/logger.dart';
import '../entities/reminder_form_draft.dart';
import '../repositories/reminders_repository.dart';

/// Автосейв черновика формы (каждые 5 сек, ТЗ 6.3.12.14).
class SaveReminderDraftUseCase {
  SaveReminderDraftUseCase({
    required RemindersRepository repository,
    required Logger logger,
  })  : _repository = repository,
        _logger = logger;

  final RemindersRepository _repository;
  final Logger _logger;

  Future<void> call(String userId, ReminderFormDraft draft) async {
    try {
      await _repository.saveDraft(userId, draft);
    } catch (e, st) {
      // Черновик не критичен: логируем и не роняем UI.
      _logger.w('SaveReminderDraft failed: $e', error: e, stackTrace: st);
    }
  }
}