import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/database/database_provider.dart';
import '../../data/datasources/savings_goals_dao.dart';
import '../../data/repositories/savings_goals_repository_impl.dart';
import '../../domain/repositories/savings_goals_repository.dart';

final Logger _logger = Logger();

/// DAO целей накопления.
final savingsGoalsDaoProvider = Provider<SavingsGoalsDao>((ref) {
  return SavingsGoalsDao(ref.watch(appDatabaseProvider));
});

/// Репозиторий целей накопления.
final savingsGoalsRepositoryProvider = Provider<SavingsGoalsRepository>((ref) {
  return SavingsGoalsRepositoryImpl(
    dao: ref.watch(savingsGoalsDaoProvider),
    logger: _logger,
  );
});