import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/database/database_provider.dart';
import '../../data/datasources/recurring_transactions_dao.dart';
import '../../data/repositories/recurring_transactions_repository_impl.dart';
import '../../domain/repositories/recurring_transactions_repository.dart';

final Logger _logger = Logger();

final recurringTransactionsDaoProvider =
    Provider<RecurringTransactionsDao>((ref) {
  return RecurringTransactionsDao(ref.watch(appDatabaseProvider));
});

final recurringTransactionsRepositoryProvider =
    Provider<RecurringTransactionsRepository>((ref) {
  return RecurringTransactionsRepositoryImpl(
    dao: ref.watch(recurringTransactionsDaoProvider),
    logger: _logger,
  );
});