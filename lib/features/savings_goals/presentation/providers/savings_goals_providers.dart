import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/features/cashback/presentation/providers/cashback_providers.dart';
import 'package:budget_assistant/features/transactions/presentation/providers/create_transaction_providers.dart';
import '../../domain/usecases/archive_savings_goal_usecase.dart';
import '../../domain/usecases/build_accumulation_chart_usecase.dart';
import '../../domain/usecases/build_savings_goal_draft_usecase.dart';
import '../../domain/usecases/calculate_archive_stats_usecase.dart';
import '../../domain/usecases/calculate_savings_analytics_usecase.dart';
import '../../domain/usecases/calculate_savings_forecast_usecase.dart';
import '../../domain/usecases/calculate_savings_goals_summary_usecase.dart';
import '../../domain/usecases/calculate_savings_plan_usecase.dart';
import '../../domain/usecases/complete_savings_goal_usecase.dart';
import '../../domain/usecases/contribute_to_savings_goal_usecase.dart';
import '../../domain/usecases/create_savings_goal_usecase.dart';
import '../../domain/usecases/get_goal_history_usecase.dart';
import '../../domain/usecases/link_savings_goal_to_account_usecase.dart';
import '../../domain/usecases/restore_savings_goal_usecase.dart';
import '../../domain/usecases/sort_goals_table_usecase.dart';
import '../../domain/usecases/update_savings_goal_progress_usecase.dart';
import '../../domain/usecases/update_savings_goal_usecase.dart';
import '../../domain/usecases/validate_savings_goal_form_usecase.dart';
import '../../domain/usecases/withdraw_from_savings_goal_usecase.dart';
import 'savings_goals_repository_providers.dart';

final Logger _logger = Logger();

// ═══ UseCases целей накопления (Этап 12) ═══
final createSavingsGoalUseCaseProvider = Provider<CreateSavingsGoalUseCase>((ref) {
  return CreateSavingsGoalUseCase(
    repository: ref.watch(savingsGoalsRepositoryProvider),
    logger: _logger,
  );
});

final updateSavingsGoalUseCaseProvider = Provider<UpdateSavingsGoalUseCase>((ref) {
  return UpdateSavingsGoalUseCase(
    repository: ref.watch(savingsGoalsRepositoryProvider),
    logger: _logger,
  );
});

final updateSavingsGoalProgressUseCaseProvider =
    Provider<UpdateSavingsGoalProgressUseCase>((ref) {
  return UpdateSavingsGoalProgressUseCase(
    repository: ref.watch(savingsGoalsRepositoryProvider),
    logger: _logger,
  );
});

final contributeToSavingsGoalUseCaseProvider =
    Provider<ContributeToSavingsGoalUseCase>((ref) {
  return ContributeToSavingsGoalUseCase(
    createTransaction: ref.watch(createTransactionUseCaseProvider),
    logger: _logger,
  );
});

final withdrawFromSavingsGoalUseCaseProvider =
    Provider<WithdrawFromSavingsGoalUseCase>((ref) {
  return WithdrawFromSavingsGoalUseCase(
    createTransaction: ref.watch(createTransactionUseCaseProvider),
    logger: _logger,
  );
});

final completeSavingsGoalUseCaseProvider = Provider<CompleteSavingsGoalUseCase>((ref) {
  return CompleteSavingsGoalUseCase(
    repository: ref.watch(savingsGoalsRepositoryProvider),
    logger: _logger,
  );
});

final archiveSavingsGoalUseCaseProvider = Provider<ArchiveSavingsGoalUseCase>((ref) {
  return ArchiveSavingsGoalUseCase(
    repository: ref.watch(savingsGoalsRepositoryProvider),
    logger: _logger,
  );
});

final restoreSavingsGoalUseCaseProvider = Provider<RestoreSavingsGoalUseCase>((ref) {
  return RestoreSavingsGoalUseCase(
    repository: ref.watch(savingsGoalsRepositoryProvider),
    logger: _logger,
  );
});

final linkSavingsGoalToAccountUseCaseProvider =
    Provider<LinkSavingsGoalToAccountUseCase>((ref) {
  return LinkSavingsGoalToAccountUseCase(
    repository: ref.watch(savingsGoalsRepositoryProvider),
    logger: _logger,
  );
});

final calculateSavingsGoalsSummaryUseCaseProvider =
    Provider<CalculateSavingsGoalsSummaryUseCase>((ref) {
  return CalculateSavingsGoalsSummaryUseCase(
    convertCurrency: ref.watch(convertCurrencyUseCaseProvider),
    logger: _logger,
  );
});

final calculateArchiveStatsUseCaseProvider =
    Provider<CalculateArchiveStatsUseCase>((ref) {
  return CalculateArchiveStatsUseCase(
    convertCurrency: ref.watch(convertCurrencyUseCaseProvider),
    logger: _logger,
  );
});

final getGoalHistoryUseCaseProvider = Provider<GetGoalHistoryUseCase>((ref) {
  return GetGoalHistoryUseCase(
    repository: ref.watch(transactionsRepositoryProvider),
    logger: _logger,
  );
});

final buildSavingsGoalDraftUseCaseProvider =
    Provider<BuildSavingsGoalDraftUseCase>((ref) {
  return BuildSavingsGoalDraftUseCase(logger: _logger);
});

final validateSavingsGoalFormUseCaseProvider =
    Provider<ValidateSavingsGoalFormUseCase>((ref) {
  return ValidateSavingsGoalFormUseCase(logger: _logger);
});

final calculateSavingsPlanUseCaseProvider =
    Provider<CalculateSavingsPlanUseCase>((ref) {
  return CalculateSavingsPlanUseCase(logger: _logger);
});

final calculateSavingsForecastUseCaseProvider =
    Provider<CalculateSavingsForecastUseCase>((ref) {
  return CalculateSavingsForecastUseCase(
    convertCurrency: ref.watch(convertCurrencyUseCaseProvider),
    logger: _logger,
  );
});

final calculateSavingsAnalyticsUseCaseProvider =
    Provider<CalculateSavingsAnalyticsUseCase>((ref) {
  return CalculateSavingsAnalyticsUseCase(
    convertCurrency: ref.watch(convertCurrencyUseCaseProvider),
    logger: _logger,
  );
});

final buildAccumulationChartUseCaseProvider =
    Provider<BuildAccumulationChartUseCase>((ref) {
  return BuildAccumulationChartUseCase(
    forecast: ref.watch(calculateSavingsForecastUseCaseProvider),
    convertCurrency: ref.watch(convertCurrencyUseCaseProvider),
    logger: _logger,
  );
});

final sortGoalsTableUseCaseProvider = Provider<SortGoalsTableUseCase>((ref) {
  return SortGoalsTableUseCase(logger: _logger);
});
/// Микро-коммит 12.6: история пополнений/изъятий цели (BottomSheet «История цели»).
final goalHistoryProvider =
    FutureProvider.family<GoalHistory, String>((ref, goalId) {
  return ref.watch(getGoalHistoryUseCaseProvider)(goalId);
});