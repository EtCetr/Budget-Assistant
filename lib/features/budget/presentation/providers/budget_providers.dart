import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/database/database_provider.dart';
import 'package:budget_assistant/features/auth/presentation/providers/current_user_provider.dart';
import '../../data/repositories/budget_limits_repository_impl.dart';
import '../../domain/repositories/budget_limits_repository.dart';
import '../../domain/usecases/calculate_monthly_pnl_usecase.dart';
import '../../domain/usecases/get_effective_limit_usecase.dart';
import '../../domain/usecases/check_budget_alerts_usecase.dart';
import '../../domain/usecases/upsert_budget_limit_usecase.dart';
import '../../domain/usecases/delete_budget_limit_usecase.dart';
import '../../domain/entities/budget_limit.dart';
import '../../domain/entities/monthly_pnl.dart';
import '../../domain/entities/effective_limit.dart';

final Logger _logger = Logger();

final budgetLimitsRepositoryProvider = Provider<BudgetLimitsRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return BudgetLimitsRepositoryImpl(db: db, logger: _logger);
});

final calculateMonthlyPnlUseCaseProvider = Provider<CalculateMonthlyPnlUseCase>(
  (ref) => CalculateMonthlyPnlUseCase(
    repository: ref.watch(budgetLimitsRepositoryProvider),
    logger: _logger,
  ),
);

final getEffectiveLimitUseCaseProvider = Provider<GetEffectiveLimitUseCase>(
  (ref) => GetEffectiveLimitUseCase(
    repository: ref.watch(budgetLimitsRepositoryProvider),
    logger: _logger,
  ),
);

final checkBudgetAlertsUseCaseProvider = Provider<CheckBudgetAlertsUseCase>(
  (ref) => CheckBudgetAlertsUseCase(
    repository: ref.watch(budgetLimitsRepositoryProvider),
    notificationsDao: ref.watch(appDatabaseProvider).notificationsDao,
    logger: _logger,
  ),
);

final upsertBudgetLimitUseCaseProvider = Provider<UpsertBudgetLimitUseCase>(
  (ref) => UpsertBudgetLimitUseCase(
    repository: ref.watch(budgetLimitsRepositoryProvider),
    logger: _logger,
  ),
);

final deleteBudgetLimitUseCaseProvider = Provider<DeleteBudgetLimitUseCase>(
  (ref) => DeleteBudgetLimitUseCase(
    repository: ref.watch(budgetLimitsRepositoryProvider),
    logger: _logger,
  ),
);

/// Список лимитов текущего месяца (реактивный стрим из БД).
final budgetLimitsForCurrentMonthProvider = StreamProvider<List<BudgetLimit>>((
  ref,
) {
  final repo = ref.watch(budgetLimitsRepositoryProvider);
  final userId = ref.watch(currentUserIdProvider);
  final now = DateTime.now();
  return repo.watchForMonth(
    userId: userId,
    spaceId: null,
    year: now.year,
    month: now.month,
  );
});

/// Загрузка одного лимита по ID — для префилла экрана редактирования.
final budgetLimitByIdProvider = FutureProvider.autoDispose
    .family<BudgetLimit?, String>((ref, id) async {
      final repo = ref.watch(budgetLimitsRepositoryProvider);
      try {
        return await repo.getById(id);
      } catch (e, stack) {
        _logger.e(
          'budgetLimitByIdProvider failed',
          error: e,
          stackTrace: stack,
        );
        return null;
      }
    });

/// Реактивный триггер: стрим суммы релевантных транзакций за месяц.
/// Любое изменение транзакций пушит новое значение, и зависимые
/// провайдеры (P&L, эффективный лимит) пересчитываются автоматически.
final budgetTransactionsTriggerProvider = StreamProvider<int>((ref) {
  final repo = ref.watch(budgetLimitsRepositoryProvider);
  final userId = ref.watch(currentUserIdProvider);
  final now = DateTime.now();
  return repo.watchMonthlyTransactionChanges(
    userId: userId,
    spaceId: null,
    year: now.year,
    month: now.month,
  );
});

/// P&L текущего месяца. Реактивный: зависит от триггера транзакций.
final monthlyPnlForCurrentMonthProvider = FutureProvider<MonthlyPnl?>((
  ref,
) async {
  // Реактивная зависимость: пересчёт при изменении транзакций.
  ref.watch(budgetTransactionsTriggerProvider);

  final useCase = ref.watch(calculateMonthlyPnlUseCaseProvider);
  final userId = ref.watch(currentUserIdProvider);
  final now = DateTime.now();
  final result = await useCase(
    userId: userId,
    spaceId: null,
    year: now.year,
    month: now.month,
  );
  return result.valueOrNull;
});

/// Эффективный лимит по категории. Реактивный: зависит и от триггера
/// транзакций (факт трат), и от списка лимитов (изменения лимитов).
final effectiveLimitForCategoryProvider =
    FutureProvider.family<EffectiveLimit?, String>((ref, categoryId) async {
      // Реактивные зависимости.
      ref.watch(budgetTransactionsTriggerProvider);
      ref.watch(budgetLimitsForCurrentMonthProvider);

      final useCase = ref.watch(getEffectiveLimitUseCaseProvider);
      final userId = ref.watch(currentUserIdProvider);
      final now = DateTime.now();

      final db = ref.watch(appDatabaseProvider);
      final settings = await db.appSettingsDao.getForUser(userId);

      final result = await useCase(
        userId: userId,
        spaceId: null,
        categoryId: categoryId,
        year: now.year,
        month: now.month,
        inheritLimit: settings.inheritLimitFromPreviousMonth,
        carryOverUnused: settings.carryOverUnusedLimit,
      );
      return result.valueOrNull;
    });
