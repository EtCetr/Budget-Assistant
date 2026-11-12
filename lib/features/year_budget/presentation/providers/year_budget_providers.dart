import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/database/app_database.dart';
import 'package:budget_assistant/core/providers/transactions_trigger_provider.dart';
import 'package:budget_assistant/features/auth/presentation/providers/current_user_provider.dart';
import '../../data/repositories/year_budget_repository_impl.dart';
import '../../domain/models/year_budget_models.dart';
import '../../domain/repositories/year_budget_repository.dart';
import '../../domain/usecases/calculate_month_stats_usecase.dart';
import '../../domain/usecases/calculate_year_budget_usecase.dart';
import '../../domain/usecases/export_year_budget_xlsx_usecase.dart';
import '../../domain/usecases/save_month_budget_usecase.dart';

final yearBudgetRepositoryProvider = Provider<YearBudgetRepository>(
  (ref) => YearBudgetRepositoryImpl(db: AppDatabase(), logger: Logger()),
);

final calculateYearBudgetUseCaseProvider = Provider<CalculateYearBudgetUseCase>(
  (ref) => CalculateYearBudgetUseCase(
    repository: ref.watch(yearBudgetRepositoryProvider),
    logger: Logger(),
  ),
);

final calculateMonthStatsUseCaseProvider = Provider<CalculateMonthStatsUseCase>(
  (ref) => CalculateMonthStatsUseCase(
    repository: ref.watch(yearBudgetRepositoryProvider),
    logger: Logger(),
  ),
);

final saveMonthBudgetUseCaseProvider = Provider<SaveMonthBudgetUseCase>(
  (ref) => SaveMonthBudgetUseCase(
    repository: ref.watch(yearBudgetRepositoryProvider),
    logger: Logger(),
  ),
);

final exportYearBudgetXlsxUseCaseProvider =
    Provider<ExportYearBudgetXlsxUseCase>(
  (ref) => ExportYearBudgetXlsxUseCase(
    repository: ref.watch(yearBudgetRepositoryProvider),
    yearUseCase: ref.watch(calculateYearBudgetUseCaseProvider),
    logger: Logger(),
  ),
);

/// Скоуп отчёта: null = лично, иначе spaceId (D23.5-6).
class YearBudgetScopeNotifier extends Notifier<String?> {
  @override
  String? build() => null;
  void set(String? spaceId) => state = spaceId;
}

final yearBudgetScopeProvider =
    NotifierProvider<YearBudgetScopeNotifier, String?>(
        YearBudgetScopeNotifier.new);

class YearBudgetYearNotifier extends Notifier<int> {
  @override
  int build() => DateTime.now().year;
  void set(int year) => state = year;
}

final yearBudgetYearProvider =
    NotifierProvider<YearBudgetYearNotifier, int>(YearBudgetYearNotifier.new);

final yearBudgetYearsProvider = FutureProvider.autoDispose<List<int>>((ref) async {
  ref.watch(transactionsTriggerProvider);
  final uid = ref.watch(currentUserIdProvider);
  final scope = ref.watch(yearBudgetScopeProvider);
  final years = await ref
      .watch(yearBudgetRepositoryProvider)
      .availableYears(userId: uid, spaceId: scope);
  final now = DateTime.now().year;
  final all = {...years, now}.toList()..sort((a, b) => b.compareTo(a));
  return all;
});

final yearBudgetDataProvider =
    FutureProvider.autoDispose<YearBudgetData>((ref) async {
  ref.watch(transactionsTriggerProvider);
  final uid = ref.watch(currentUserIdProvider);
  final scope = ref.watch(yearBudgetScopeProvider);
  final year = ref.watch(yearBudgetYearProvider);
  return ref.watch(calculateYearBudgetUseCaseProvider)(
    userId: uid,
    year: year,
    spaceId: scope,
  );
});

final monthStatsProvider =
    FutureProvider.autoDispose.family<MonthStatsData, MonthStatsKey>(
        (ref, key) async {
  ref.watch(transactionsTriggerProvider);
  final uid = ref.watch(currentUserIdProvider);
  return ref.watch(calculateMonthStatsUseCaseProvider)(userId: uid, key: key);
});