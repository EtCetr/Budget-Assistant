import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/database/database_provider.dart';
import '../../data/datasources/debts_dao.dart';
import '../../data/repositories/debts_repository_impl.dart';
import '../../domain/repositories/debts_repository.dart';

final Logger _logger = Logger();

final debtsDaoProvider = Provider<DebtsDao>((ref) {
  return DebtsDao(ref.watch(appDatabaseProvider));
});

final debtsRepositoryProvider = Provider<DebtsRepository>((ref) {
  return DebtsRepositoryImpl(
    dao: ref.watch(debtsDaoProvider),
    logger: _logger,
  );
});