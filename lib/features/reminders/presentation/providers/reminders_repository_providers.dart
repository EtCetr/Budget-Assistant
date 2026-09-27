import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/database/database_provider.dart';
import '../../data/datasources/reminders_dao.dart';
import '../../data/repositories/reminders_repository_impl.dart';
import '../../domain/repositories/reminders_repository.dart';

final Logger _logger = Logger();

final remindersDaoProvider = Provider<RemindersDao>((ref) {
  return RemindersDao(ref.watch(appDatabaseProvider));
});

final remindersRepositoryProvider = Provider<RemindersRepository>((ref) {
  return RemindersRepositoryImpl(
    dao: ref.watch(remindersDaoProvider),
    logger: _logger,
  );
});