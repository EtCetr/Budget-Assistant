import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:budget_assistant/core/database/database_provider.dart';
import 'package:budget_assistant/features/auth/presentation/providers/current_user_provider.dart';
import 'package:budget_assistant/core/providers/security_providers.dart';
import 'package:budget_assistant/features/cashback/presentation/providers/cashback_providers.dart';
import '../../data/repositories/dashboard_data_repository_impl.dart';
import '../../data/repositories/dashboard_layout_repository_impl.dart';
import '../../domain/entities/dashboard_widget_item.dart';
import '../../domain/usecases/update_dashboard_layout_usecase.dart';

final Logger _logger = Logger();

final dashboardLayoutRepositoryProvider = Provider<DashboardLayoutRepositoryImpl>(
  (ref) => DashboardLayoutRepositoryImpl(
    db: ref.watch(appDatabaseProvider),
    logger: _logger,
  ),
);

final dashboardDataRepositoryProvider = Provider<DashboardDataRepositoryImpl>(
  (ref) => DashboardDataRepositoryImpl(
    db: ref.watch(appDatabaseProvider),
    logger: _logger,
  ),
);

final dashboardLayoutProvider =
    StreamProvider.autoDispose<List<DashboardWidgetItem>>((ref) {
  final userId = ref.watch(currentUserIdProvider);
  final repository = ref.watch(dashboardLayoutRepositoryProvider);
  return Stream.fromFuture(repository.ensureDefaults(userId)).asyncExpand(
    (_) => repository.watchLayout(userId),
  );
});

final updateDashboardLayoutUseCaseProvider =
    Provider<UpdateDashboardLayoutUseCase>(
  (ref) => UpdateDashboardLayoutUseCase(
    repository: ref.watch(dashboardLayoutRepositoryProvider),
    logger: _logger,
  ),
);

final dashboardExpenseFlowProvider =
    FutureProvider.autoDispose<List<ExpenseFlowPoint>>((ref) async {
  final userId = ref.watch(currentUserIdProvider);
  final spaceId = ref.watch(currentSpaceIdProvider);
  final repository = ref.watch(dashboardDataRepositoryProvider);
  return repository.getExpenseFlow(
    userId: userId,
    spaceId: spaceId,
    excludeLargeExpenses: false,
  );
});

/// Виджет «Активный кэшбэк».
///
/// Этап 12 (фикс реактивности): подписан на cashbackMatrixTriggerProvider —
/// перезагружается сразу при изменении cashback_matrix / транзакций / счетов,
/// поэтому добавление, удаление и редактирование категории кэшбэка
/// мгновенно отражается на дашборде.
final dashboardActiveCashbackProvider =
    FutureProvider.autoDispose<List<ActiveCashbackUi>>((ref) async {
  ref.watch(cashbackMatrixTriggerProvider);
  final userId = ref.watch(currentUserIdProvider);
  final repository = ref.watch(dashboardDataRepositoryProvider);
  return repository.getActiveCashback(userId);
});